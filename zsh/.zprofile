# Your previous $HOME/.zprofile file was backed up as $HOME/.zprofile.macports-saved_2025-10-02_at_17:05:41
##

# MacPorts Installer addition on 2025-10-02_at_17:05:41: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# herdr and other user-local binaries
export PATH="$HOME/.local/bin:$PATH"

# Homebrew; keep after MacPorts so brew wins PATH precedence.
# Drop brew's fpath line (emitted as `fpath[1,0]=...` under zsh):
# /usr/local/share/zsh/site-functions is already in zsh's default fpath, and
# the extra prepend makes login-shell fpath differ from nested shells ->
# omz's exact-match check rebuilds $ZSH_COMPDUMP (~1.7s) on every alternation.
eval "$(/usr/local/bin/brew shellenv | grep -vi fpath)"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Amp CLI
export PATH="$HOME/.amp/bin:$PATH"

# X Desktop Group (Freedesktop)
export XDG_CONFIG_HOME="$HOME/.config"

# MySQL@5.7 build flags (compiler flags are space-separated; plain assignment
# keeps them idempotent across nested login shells)
export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"
export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

# Neovim
export EDITOR=nvim
export VISUAL=nvim

# See: https://github.com/MichaelAquilina/zsh-you-should-use#disable-hints-for-specific-aliases
export YSU_IGNORED_ALIASES=("cl")

# Dedupe PATH; must run AFTER all the `export PATH=...` lines above. tmux panes
# are login shells on macOS, so this file re-runs on an already-populated PATH
# and every prepend would stack a duplicate. -U keeps the FIRST occurrence, so
# the re-prepended entries win and the inherited copies drop -- order stays
# identical to a fresh login. NOTE: -U only dedupes on ARRAY assignment; the
# scalar `export PATH="..."` lines above bypass it, hence end-of-file placement
# (attaching -U to an existing array dedupes it immediately).
# (Unrelated to `typeset +x FPATH` in .zshrc, which unexports FPATH.)
typeset -U path
