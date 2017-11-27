DIRSTACKSIZE=32

setopt auto_cd
setopt auto_pushd pushd_ignore_dups pushd_silent

setopt always_to_end
setopt auto_list auto_menu list_ambiguous list_rows_first
setopt auto_param_slash
setopt complete_aliases complete_in_word 
setopt glob_complete

setopt no_bad_pattern case_glob case_match glob no_nomatch
setopt warn_create_global

HISTFILE=~/.zsh_history
HISTSIZE=9999999
SAVEHIST=999999

setopt extended_history
setopt hist_ignore_space hist_reduce_blanks
setopt hist_ignore_all_dups hist_find_no_dups hist_save_no_dups
setopt inc_append_history

setopt aliases
setopt no_clobber
setopt no_correct
setopt no_flow_control
setopt print_exit_value

setopt auto_continue
setopt check_jobs no_hup

setopt c_precedences

setopt emacs

WORDCHARS="_"

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit bashcompinit
compinit
bashcompinit

if [[ -n "$INSIDE_EMACS" ]]
then
  autoload -U add-zsh-hook
  update_emacs_pwd() { print -P "\032/%d" }
  add-zsh-hook chpwd update_emacs_pwd
fi

ulimit -c unlimited

# Keyboard bindings
case "$TERM" in
  rxvt*)
    bindkey '^[Oc' vi-forward-word
    bindkey '^[Od' emacs-backward-word
    ;;
  xterm*)
    bindkey '^[[1;5C' vi-forward-word
    bindkey '^[[1;5D' emacs-backward-word
    ;;
esac
bindkey '^[[3;5~' kill-word
