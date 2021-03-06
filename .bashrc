shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

PROMPT_COMMAND=set_prompt

function timer_start {
  TIMER=${TIMER:-$SECONDS}
}

function timer_stop {
  TIMER_SHOW=$(($SECONDS - $TIMER))
  unset TIMER
}

trap 'timer_start' DEBUG

function set_prompt {
  local CMDERROR=$?
  if [ "$CMDERROR" -eq "0" ]; then
    local STATUS="\[\e[1;32m\]SUCCESS\[\e[0m\]"
  else
    local STATUS="\[\e[1;31m\]FAILURE [$CMDERROR]\[\e[0m\]"
  fi

  timer_stop

  PS1="${STATUS} in ${TIMER_SHOW}s\n\[\033[38m\]\h:\[\e[38;05;38m\]\$(pwd30)\[\033[32m\]\$(__git_ps1 ' [%s]')\[\033[37m\] $\[\033[00m\] "
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# tmux
alias tn='tmux new-session -s'
alias ta='tmux attach-session -t'
alias tl='tmux list-sessions'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias :e=vim
alias :q=exit

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export GIT_PS1_SHOWDIRTYSTATE=1

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export EDITOR="vim -f"
export P4DIFF="vimdiff"

export PATH=$PATH:~/bin
export LSCOLORS=fxfxcxdxbxegedabagacad

# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
# TODO: more testing needed
# if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
# then
#   STARTED_SCREEN=1 ; export STARTED_SCREEN
#   [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
#   sleep 1
#   screen -RR && exit 0
#   # normally, execution of this rc script ends here...
#   echo "Screen failed! continuing with normal bash startup"
# fi
# [end of auto-screen snippet]

# vim mode
set -o vi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Taking notes!
notes() {
  if [ ! -z "$1" ]; then
    # Place whatever in the file directly
    echo "$@" >> "$HOME/notes.md"
  else
    # Take from STDIN
    cat - >> "$HOME/notes.md"
  fi
}
