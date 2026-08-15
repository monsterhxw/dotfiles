# Ghostty shell integration extras.
# Sourced from .zshrc only when $GHOSTTY_RESOURCES_DIR is set — the guard
# lives there so non-ghostty shells don't even stat this file.

# Ghostty's ZDOTDIR trick runs the integration only in shells it spawns; cover
# shells that inherit GHOSTTY_RESOURCES_DIR but not ZDOTDIR: `exec zsh`, tmux
# panes, herdr agents. Re-sourcing is a ~2ms no-op ($_ghostty_state early return).
source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration

# Ghostty reports cwd itself; drop omz's OSC 7 hook (forks 2 subshells/prompt, ~4.7ms)
add-zsh-hook -d precmd omz_termsupport_cwd

# `fg` leaves the title stuck at literal "fg" (ghostty-org/ghostty#3961).
# Must be a wrapper: _ghostty_preexec registers last, overwriting any hook.
# jobspec -> job_id parsing from omz:
# https://github.com/ohmyzsh/ohmyzsh/blob/2ac69955e84d5ab2407e848275dfc2768b3b1531/lib/termsupport.zsh#L67-L89
fg() {
  if (( _ghostty_fd )) && [[ $GHOSTTY_SHELL_FEATURES == *title* ]]; then
    builtin emulate -L zsh -o extended_glob
    local job_id jobspec=${1#%}
    case $jobspec in
      <->)    job_id=$jobspec ;;
      ''|%|+) job_id=${(k)jobstates[(r)*:+:*]} ;;
      -)      job_id=${(k)jobstates[(r)*:-:*]} ;;
      [?]*)   job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
      *)      job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
    esac
    [[ -n ${jobtexts[$job_id]} ]] &&
      builtin print -rnu $_ghostty_fd $'\e]2;'${jobtexts[$job_id]//[[:cntrl:]]}$'\a'
  fi
  builtin fg "$@"
}
