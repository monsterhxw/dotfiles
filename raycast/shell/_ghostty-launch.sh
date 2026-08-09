#!/bin/bash
# Shared launcher for the *-in-ghostty Raycast scripts.
#
# Goal: clicking a launcher a second time must NOT open another Ghostty window
# attached to the same target (e.g. a second tmux client on session "lab",
# which triggers tmux 3.7b's pane-content redraw bug -> 100% CPU). Instead we
# focus the window that THIS launcher opened before.
#
# Each launcher tracks ONLY its own window, via a two-line state file:
#
#   line 1: surface UUID  -- Ghostty 1.3.1 assigns every surface a stable id,
#           readable/focusable through its AppleScript dictionary. Used to
#           focus the exact window. May be empty (ambiguous cold start).
#   line 2: payload FINGERPRINT -- identifies OUR payload process precisely:
#           tmux-<sess>: "client_pid client_tty" of the client we attached;
#           herdr:       pid of the herdr we spawned.
#
# The fingerprint is the PRIMARY judge. The hot path checks it with a
# pid-keyed point lookup (_fp_alive, no table scan); the full roster scan
# (_roster) runs only when the fingerprint is dead and unknown payloads must
# be discovered. One check answers every question the old probe/corpse-wait
# cascade needed multiple rounds for:
#   * fingerprint on the roster  => our payload provably alive. Focus the UUID;
#     if the UUID surface has VANISHED (focus miss with a non-empty uuid), the
#     user just Cmd+W'd our window -- Ghostty destroys the surface instantly
#     but delays killing the child ~5s, so the dying client lingers. Reap it
#     (tmux detach-client kills it in ~0.1s; herdr gets SIGTERM) and open the
#     replacement immediately: one click, ~1s, no 5s wait.
#   * fingerprint gone, roster non-empty => a payload WE don't own (manually
#     attached lab / manually launched herdr inside Ghostty). Never touch it,
#     never double-attach: just bring Ghostty forward.
#   * roster empty => nothing alive (covers window-save-state impostors, which
#     restore a closed window under its OLD uuid as a plain shell -- a shell
#     can't fake a tmux client or a herdr process). Open a fresh window.
#
# The roster is deliberately ghostty-scoped (client_termname / process
# ancestry): the same payload hosted by another terminal emulator must neither
# satisfy a focus nor get reaped.
#
# State lives in $TMPDIR (per-user, ephemeral) and is validated on every read,
# so no cleanup hook is needed.
#
# Usage: _ghostty-launch.sh <KEY> <CMD>
#   KEY  "tmux-<session>" or "herdr"; doubles as the state-file name
#   CMD  command line to run in the surface; MUST NOT contain double quotes
#        (it is embedded in an AppleScript double-quoted string).

set -u

KEY="${1:?KEY required}"
CMD="${2:?CMD required}"
SESS="${KEY#tmux-}"     # only meaningful for tmux-* keys

STATE_DIR="${TMPDIR:-/tmp}/ghostty-launch"
mkdir -p "$STATE_DIR"
IDFILE="$STATE_DIR/$KEY.id"
LOCKDIR="$STATE_DIR/$KEY.lock"
LOGFILE="$STATE_DIR/$KEY.log"

# Diagnostics are OFF by default: skips the date-fork + disk append per _log
# call and, at the gated call sites below, the ~0.6s _snapshot osascript.
# Toggle (takes effect on the next click, no script edit needed):
#   touch "${TMPDIR:-/tmp}/ghostty-launch/debug"   # enable
#   rm    "${TMPDIR:-/tmp}/ghostty-launch/debug"   # disable
DEBUG=0
if [ -e "$STATE_DIR/debug" ]; then DEBUG=1; fi

# Raycast runs scripts with a minimal PATH; tmux lives in MacPorts.
TMUX_BIN="/opt/local/bin/tmux"
[ -x "$TMUX_BIN" ] || TMUX_BIN="$(command -v tmux || echo tmux)"

# Append a timestamped diagnostic line. Kept cheap (one echo). Remove the calls
# once the launcher has proven itself stable.
_log() {
    [ "$DEBUG" = 1 ] || return 0
    printf '%s [%s] %s\n' "$(date '+%H:%M:%S')" "$$" "$*" >>"$LOGFILE"
}

# Snapshot every live Ghostty surface (uuid + title) for the log, so we can see
# whether a recorded UUID actually belongs to the intended window.
_snapshot() {
    osascript 2>/dev/null <<'EOF' | tr '\n' '|'
tell application "Ghostty"
    set out to ""
    repeat with t in terminals
        set out to out & (id of t) & "=" & (name of t) & "  "
    end repeat
    return out
end tell
EOF
}

# Serialize concurrent invocations (Raycast can double-fire, and a user whose
# click looks slow WILL click again) so two runs can't both miss the state and
# each open a window. mkdir is atomic. The wait must outlast a full
# create+record run (~5s); steal only after 8s (crashed holder whose EXIT trap
# never fired).
_acquire_lock() {
    local i
    for i in $(seq 1 80); do
        if mkdir "$LOCKDIR" 2>/dev/null; then break; fi
        sleep 0.1
    done
    trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT
}

# Does pid's ancestor chain reach the Ghostty app process? Bounded walk; a
# Raycast- or alacritty-hosted process tops out at launchd without matching.
_has_ghostty_ancestor() {
    local pid="$1" i comm
    for i in $(seq 1 8); do
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
        { [ -n "$pid" ] && [ "$pid" -gt 1 ]; } 2>/dev/null || return 1
        comm=$(ps -o comm= -p "$pid" 2>/dev/null)
        case "$comm" in *[Gg]hostty*) return 0 ;; esac
    done
    return 1
}

# Point lookup: is THIS fingerprint still a live ghostty-hosted payload?
# The hot path (every routine click, the reap poll) uses this instead of
# building the full roster: pid-keyed ps hits sysctl KERN_PROC_PID directly
# (~5ms) while any BY-NAME enumeration must copy the whole process table
# (~36ms floor on macOS -- there is no name index, pgrep scans too).
# _roster below stays only for the rare branches that must discover UNKNOWN
# payloads (foreign detection, fingerprint recording), where a scan is
# genuinely unavoidable.
_fp_alive() {
    local fp="$1"
    [ -n "$fp" ] || return 1
    case "$KEY" in
        tmux-*)
            # The server answers point queries authoritatively; same call
            # shape as _roster but matched on our exact pid+tty.
            "$TMUX_BIN" list-clients -t "$SESS" \
                -F '#{client_pid} #{client_tty} #{client_termname}' 2>/dev/null \
                | grep -q "^$fp .*ghostty"
            ;;
        herdr)
            # Same four predicates the roster encodes, all pid-keyed:
            # exists / is herdr (pid not recycled) / has a tty (not the
            # server) / hosted by Ghostty (not alacritty etc.).
            local tty comm
            read -r tty comm <<EOF
$(ps -p "$fp" -o tty=,ucomm= 2>/dev/null)
EOF
            [ "$comm" = "herdr" ] || return 1
            [ "$tty" != "??" ] || return 1
            _has_ghostty_ancestor "$fp"
            ;;
        *)  return 1 ;;
    esac
}

# Print one fingerprint per line for every live ghostty-hosted payload of this
# KEY's kind (see header). Empty output = nothing alive. Discovery only --
# the hot path never calls this (see _fp_alive).
_roster() {
    case "$KEY" in
        tmux-*)
            "$TMUX_BIN" list-clients -t "$SESS" \
                -F '#{client_pid} #{client_tty} #{client_termname}' 2>/dev/null \
                | awk '$3 ~ /ghostty/ {print $1 " " $2}'
            ;;
        herdr)
            # ps, not pgrep: BSD pgrep silently excludes its own ANCESTORS, so
            # a roster built from a herdr-hosted shell (agent running this
            # script by hand) would miss live payloads. ps has no such rule.
            # tty filter: herdr is client/server -- the SERVER (spawned by the
            # first client, detached, no controlling tty) hosts every pane and
            # agent; fingerprinting or reaping it would destroy them all.
            # Window clients always hold their window's tty, the server shows
            # "??", so only tty-holding processes belong on the roster.
            # awk, not a shell while-read loop: one process over ~400 rows
            # (36ms vs 127ms measured). macOS-only assumptions throughout.
            local pid
            for pid in $(ps -Ao pid=,tty=,ucomm= \
                         | awk '$3 == "herdr" && $2 != "??" {print $1}'); do
                _has_ghostty_ancestor "$pid" && printf '%s\n' "$pid"
            done
            ;;
    esac
}

# Focus the surface with the given UUID. Prints nothing; returns 0 if a live
# surface matched and was focused, 1 otherwise (unknown/stale/closed UUID).
_focus_existing() {
    local uuid="$1"
    [ -n "$uuid" ] || return 1
    local r
    r=$(osascript 2>/dev/null <<EOF
tell application "Ghostty"
    set m to terminals whose id is "$uuid"
    if (count of m) is 1 then
        activate
        focus (item 1 of m)
        return "ok"
    end if
    return "miss"
end tell
EOF
)
    [ "$r" = "ok" ]
}

# Coarse fallback when a payload we don't own is alive in Ghostty: just bring
# the app forward. Never opens a window (that would double-attach).
_activate_only() {
    osascript -e 'tell application "Ghostty" to activate' >/dev/null 2>&1
}

# Kill the fingerprinted payload -- called ONLY when the fingerprint is on the
# roster but its surface is gone, i.e. it is provably OUR dying leftover.
# tmux: detach-client makes the server drop that one client; measured, client
# and process vanish within ~0.1s. Other clients and the session are untouched.
# herdr: SIGTERM (escalate to SIGKILL if ignored; Ghostty would SIGKILL it in
# a few seconds anyway). Then poll _fp_alive until it reports the payload gone.
_reap() {
    local fp="$1" i
    case "$KEY" in
        tmux-*) "$TMUX_BIN" detach-client -t "${fp#* }" 2>/dev/null ;;
        herdr)  kill -TERM "$fp" 2>/dev/null ;;
    esac
    for i in $(seq 1 10); do
        _fp_alive "$fp" || { _log "reap: [$fp] gone after ~$((i * 2))00ms"; return 0; }
        [ "$KEY" = herdr ] && [ "$i" -eq 7 ] && kill -KILL "$fp" 2>/dev/null
        sleep 0.2
    done
    _log "reap: [$fp] STILL listed after 2s (proceeding anyway)"
    return 1
}

# After creating a window: wait for OUR payload to show up on the roster (diff
# against the pre-creation roster captured by the caller) and append its
# fingerprint as idfile line 2. A miss (payload slow to start) just leaves a
# uuid-only idfile: future clicks then land in the safe activate-only branch
# until the window is next rebuilt -- degraded, never wrong.
_record_fingerprint() {
    local before="$1" i fp=""
    for i in $(seq 1 20); do
        if [ -n "$before" ]; then
            fp=$(_roster | grep -vxF "$before" | head -1)
        else
            fp=$(_roster | head -1)
        fi
        [ -n "$fp" ] && break
        sleep 0.25
    done
    if [ -n "$fp" ]; then
        printf '%s\n' "$fp" >>"$IDFILE"
        _log "recorded fingerprint [$fp]"
    else
        _log "fingerprint MISSED (no new payload within 5s) -> coarse mode until next rebuild"
    fi
}

# Create a new window running CMD (warm path: Ghostty already running). CMD is
# injected via the surface's `environment variables` -- the AppleScript
# `command` property would force wait-after-command=true (hardcoded in
# Ghostty's apprt/embedded.zig). Reads
# the new surface's UUID straight off the returned object, then fingerprints
# the payload that starts inside it.
_new_window() {
    local before uuid
    before=$(_roster)
    uuid=$(osascript 2>/dev/null <<EOF
tell application "Ghostty"
    activate
    set cfg to new surface configuration
    set environment variables of cfg to {"GHOSTTY_NEW_WINDOW_CMD=$CMD"}
    set w to new window with configuration cfg
    return id of (focused terminal of selected tab of w)
end tell
EOF
)
    # Gated at the call site: the $(_snapshot) argument would run its ~0.6s
    # osascript BEFORE _log could decline it.
    if [ "$DEBUG" = 1 ]; then
        _log "new_window: created uuid=${uuid:-<empty>} | snapshot: $(_snapshot)"
    fi
    printf '%s\n' "$uuid" >"$IDFILE"
    _record_fingerprint "$before"
}

# Cold start (Ghostty not running). macOS always creates the initial window on
# launch, so we inject CMD app-wide via GHOSTTY_INIT_CMD and let the config
# `initial-command` hook consume it (this preserves the "Raycast/Dock -> plain
# Ghostty window" entry point, which relies on that same hook seeing an empty
# var). env -i keeps the cold start as clean as a Dock launch.
_cold_start() {
    # If Cmd+W on the LAST window quit the app (quit-after-last-window-closed),
    # our dying client may still linger on the tmux server while we relaunch;
    # attaching next to it would briefly double-attach. Reap it first.
    local fp
    fp=$(sed -n 2p "$IDFILE" 2>/dev/null)
    if _fp_alive "$fp"; then
        _log "cold_start: leftover fingerprint [$fp] still live -> reap"
        _reap "$fp"
    fi
    local before
    before=$(_roster)
    # `pgrep` said Ghostty is dead, but that can race with a lingering app right
    # after Cmd+Q: LaunchServices may still consider it running, so `open --env`
    # neither creates a window nor injects the env var -- it just prints an
    # "already running" warning to stderr and returns 0. On a GENUINE cold start
    # `open` is silent. So: any stderr output => misfire => Ghostty is actually
    # alive; fall back to the warm path. Matching on emptiness rather than the
    # message text keeps this locale-independent.
    local err
    err=$(env -i /usr/bin/open -a Ghostty --env "GHOSTTY_INIT_CMD=$CMD" 2>&1 >/dev/null)
    _log "cold_start: open stderr=[${err:-<empty>}]"
    if [ -n "$err" ]; then
        _log "cold_start: misfire (Ghostty was alive) -> fall back to new_window"
        _new_window
        return
    fi
    # Genuine cold start: poll from INSIDE one osascript run (each osascript
    # process costs ~0.6s to spawn). Record the UUID ONLY while the app has
    # exactly one surface -- once window-save-state restores start landing
    # there is no way to tell our initial window from a restored impostor, and
    # recording a wrong UUID is worse than none (an empty uuid degrades to the
    # activate-only branch, harmless). ~4s ceiling.
    local uuid
    uuid=$(osascript 2>/dev/null <<'EOF'
tell application "Ghostty"
    repeat 40 times
        try
            set n to count of terminals
            if n is 1 then
                set theID to id of (focused terminal of selected tab of front window)
                if theID is not "" then return theID
            else if n > 1 then
                return ""
            end if
        end try
        delay 0.1
    end repeat
    return ""
end tell
EOF
)
    if [ "$DEBUG" = 1 ]; then
        _log "cold_start: genuine launch, uuid=${uuid:-<empty, ambiguous or timeout>} | snapshot: $(_snapshot)"
    fi
    printf '%s\n' "$uuid" >"$IDFILE"
    _record_fingerprint "$before"
}

# Is Ghostty already running? A ~10ms process-table scan that, crucially, does
# NOT launch the app -- unlike `tell application "Ghostty" to ...`, which
# auto-starts it and would defeat the cold-start branch. pgrep needs -a
# (macOS/BSD semantics: INCLUDE the caller's ancestors, which pgrep excludes
# by default -- without it, running this script from a shell inside a Ghostty
# window reports "not running" and misfires cold_start). Do NOT replace with
# `ps -Ao ucomm= | grep -x`: ucomm output is right-padded to column width, so
# the whole-line match never fires (caused a live client to be reaped as a
# cold-start leftover on every click; found the hard way).
_ghostty_alive() {
    pgrep -qixa ghostty
}

# --- main -------------------------------------------------------------------
_acquire_lock
_log "=== invoke KEY=$KEY CMD=[$CMD] ==="

if ! _ghostty_alive; then
    _log "alive=no -> cold_start"
    _cold_start
    exit 0
fi

uuid=$(sed -n 1p "$IDFILE" 2>/dev/null)
fp=$(sed -n 2p "$IDFILE" 2>/dev/null)

if _fp_alive "$fp"; then
    # Our payload is provably alive (point lookup, no table scan).
    if _focus_existing "$uuid"; then
        _log "-> REUSE: fingerprint [$fp] live, focused uuid=$uuid"
    elif [ -n "$uuid" ]; then
        # The uuid was focusable on the last click and its surface is now gone
        # while the payload still runs: the user just Cmd+W'd our window and
        # Ghostty's delayed child teardown left this dying leftover. Replace it.
        _log "-> uuid=$uuid vanished, fingerprint [$fp] lingers: reap + rebuild"
        _reap "$fp"
        _new_window
    else
        # Ambiguous cold start left us a fingerprint but no uuid: the window is
        # ours and alive, we just can't single it out. Bring the app forward.
        _activate_only
        _log "-> fingerprint [$fp] live but no uuid: activate only"
    fi
elif [ -n "$(_roster)" ]; then
    # A live payload we did NOT create (manual attach / manual herdr inside
    # Ghostty). Opening a window would double-attach (the CPU bug); reaping
    # would kill the user's own session. Just bring the app forward.
    # NOTE: this raises the app's last-focused window, not necessarily the
    # payload's -- we know the payload's tty but Ghostty 1.3.x cannot look a
    # surface up by tty.
    # TODO: Ghostty 1.4 will expose surface PID/TTY
    # (ghostty-org/ghostty#12065); once released, upgrade this to a precise
    # focus on the payload's window.
    _activate_only
    if [ "$DEBUG" = 1 ]; then
        _log "-> foreign payload on roster: activate only | roster: $(_roster | tr '\n' ';')"
    fi
else
    # Nothing alive anywhere in Ghostty (save-state impostors can't fake a
    # payload). Whatever the idfile said is history; start fresh.
    _log "-> roster empty: new_window"
    _new_window
fi
