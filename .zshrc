autoload -U compinit promptinit
compinit
promptinit

zstyle ':completion:*:default' menu select
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

# Customize to your needs...
bindkey -v
bindkey -M vicmd j vi-down-line-or-history
bindkey -M vicmd k vi-up-line-or-history
alias ll='ls -l'
alias la='ls -a'
alias -s txt=vim
alias -s html=vim
export PATH=/usr/local/bin:$PATH:/usr/local/git/bin:/usr/local/git/man:$HOME/bin
export MANPATH=$MANPATH:/usr/local/git/man
export EDITOR="vim"
unsetopt correct_all
setopt auto_cd
export PROMPT="%c %# " 

export LC_ALL=C
alias whoami=/usr/ucb/whoami
autoload -U compinit promptinit
compinit
promptinit

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

case "$TERM" in
  xterm*|rxvt*)
        function settitle { print -Pn "\e]2;%n@%m: %~\a" }
        function settab { print -Pn "\e]1;%n@%m: %~\a" }
        function chpwd { settab;settitle }
        function preexec { settab;settitle }
        function precmd { settab;settitle }
        settab;settitle
    ;;
esac

update_terminal_cwd() {
    # Identify the directory using a "file:" scheme URL,
    # including the host name to disambiguate local vs.
    # remote connections. Percent-escape spaces.
    local SEARCH=' '
    local REPLACE='%20'
    local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
    printf '\e]7;%s\a' "$PWD_URL"
}
autoload add-zsh-hook
add-zsh-hook chpwd update_terminal_cwd
update_terminal_cwd

setopt append_history
setopt share_history

#typeset -ga preexec_functions
#typeset -ga precmd_functions
#typeset -ga chpwd_functions

#setopt prompt_subst
#export __CURRENT_GIT_BRANCH=

parse_git_branch() {
	git-branch --no-color 2> /dev/null | grep '*' | cut -d ' ' -f2
}

preexec_functions+='zsh_preexec_update_git_vars'
zsh_preexec_update_git_vars() {
    case "$(history $HISTCMD)" in 
	    *git*)
	    export __CURRENT_GIT_BRANCH="$(parse_git_branch)"
	    ;;
    esac
}

chpwd_functions+='zsh_chpwd_update_git_vars'
zsh_chpwd_update_git_vars() {
    export __CURRENT_GIT_BRANCH="$(parse_git_branch)"
}

get_git_prompt_info() {
   echo "`date +"%R"`  %{\e[31m%}$__CURRENT_GIT_BRANCH%{\e[0m%}"
}
pman() {man -t "$@" | open -f -a Preview;}

#RPROMPT='$(get_git_prompt_info)';
