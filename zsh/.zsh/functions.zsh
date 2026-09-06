function echo_ok () {
  local caller=${funcstack[2]:-"Unknown"}
  echo "[$caller] OK."
}

# Java version setting
function setjdk() {
  version=$@
  export JAVA_HOME=$(/usr/libexec/java_home -v "$version");
  java -version
}

# function proxy() {
#   export http_proxy=http://127.0.0.1:7890;
#   export https_proxy=http://127.0.0.1:7890;
#   export all_proxy=http://127.0.0.1:7890;
#   echo_ok;
# }
# 
# function unproxy() {
#   unset http_proxy;
#   unset https_proxy;
#   unset all_proxy;
#   unset HTTP_PROXY;
#   unset HTTPS_PROXY;
#   unset ALL_PROXY;
#   echo_ok;
# }

# set SSL KEY LOG FILE
function setsslkey () {
  export SSLKEYLOGFILE="$HOME/project/tmp/sslkey/log/keylogfile.txt";
  echo_ok;
}

# SSL KEY LOG FILE
function unsetsslkey () {
  unset SSLKEYLOGFILE;
  echo_ok;
}

# see {@link https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh }
function lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}

# See [Runlike](https://github.com/lavie/runlike?tab=readme-ov-file#run-without-installing)
# Docker container inspector function
function runlike () {
  # Check if container name/id is provided
  if [ -z "$1" ]; then
    echo "Usage: runlike <container-name|id>"
    return 1
  fi

  # Check Docker daemon
  if ! docker info &>/dev/null; then
    echo "❌ Docker daemon is not running"
    return 1
  fi

  # Check if container exists
  if ! docker inspect "$1" &>/dev/null; then
    echo "❌ Container '$1' not found"
    return 1
  fi

  echo "✅ Inspecting container '$1'..."
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock assaflavie/runlike -p "$1"
}


# Confirming exit in a Tmux session
function exit () {
  if [[ -o interactive && $# -eq 0 && -n $TMUX && $TERM_PROGRAM = "tmux" ]]; then
    echo "You're in a Tmux Session"
  else
    builtin exit "$@"
  fi
}

bri () {
  for p in "$@"; do
    brew install --ignore-dependencies "$p" || :
  done
}

# Run /gen-commit-msg via the cheaper relay in the local settings file, if present.
# No --model here: the CLI flag would override ANTHROPIC_MODEL from that file.
# CLAUDE_CODE_SKIP_PROMPT_HISTORY=1 (undocumented): no transcript, no prompt history, so `claude -c` and /resume skip this throwaway session.
clg () {
  local settings="$HOME/.zsh/local/settings.gen-commit-msg.local.json"
  local -a opts
  [[ -f "$settings" ]] && opts=(--settings "$settings")
  CLAUDE_CODE_SKIP_PROMPT_HISTORY=1 claude "${opts[@]}" "/gen-commit-msg" "$@"
}
