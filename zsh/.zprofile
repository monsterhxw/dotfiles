# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"
# Java version setting
function setjdk() {
  version=$@
  export JAVA_HOME=$(/usr/libexec/java_home -v "$version");
  java -version
}

function proxy() {
  export http_proxy=127.0.0.1:7890;
  export https_proxy=$http_proxy;
  export all_proxy=socks5://127.0.0.1:7890;
  echo "ok.";
}

function unproxy() {
  unset http_proxy;
  unset https_proxy;
  unset all_proxy;
  echo "ok.";
}

# see {@link https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh }
lfcd () {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"
