# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color)
    color_prompt=yes
    ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# Debian extensions
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'    
fi

#Elias' edits
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

export TMOUT=259200 # 72h
set completion-ignore-case on
alias ..='cd ..'

alias gd='git diff --color-words -w'

function r() {   
  if [[ -n $TMUX ]]; then
    NEW_SSH_AUTH_SOCK=`tmux showenv|grep ^SSH_AUTH_SOCK|cut -d = -f 2`
    if [[ -n $NEW_SSH_AUTH_SOCK ]] && [[ -S $NEW_SSH_AUTH_SOCK ]]; then 
      SSH_AUTH_SOCK=$NEW_SSH_AUTH_SOCK  
    fi
  fi
}

export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=1;30:ow=1;34:st=37;44:ex=01;32:"

function parse_git_deleted {
  [[ $(git status 2> /dev/null | grep deleted:) != "" ]] && echo "${RED}-${RESET}"
}

function parse_git_added {
  [[ $(git status 2> /dev/null | grep "Untracked files:") != "" ]] && echo "${CYAN}+${RESET}"
}

function parse_git_modified {
  [[ $(git status 2> /dev/null | grep modified:) != "" ]] && echo "${YELLOW}*${RESET}"
}

function parse_git_to_be_commited {
  [[ $(git status 2> /dev/null | grep "to be committed:") != "" ]] && echo "${VIOLET}x${RESET}"
}

function parse_git_dirty {
    echo "$(parse_git_added)$(parse_git_modified)$(parse_git_deleted)$(parse_git_to_be_commited)"
}

function parse_git_branch {
  git symbolic-ref HEAD &> /dev/null || return
  echo -n " ("$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* //")$(parse_git_dirty)")"
}

function set_window_title {
  echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"
}

PS1='\u@\h:\w\$ '
if [ "$color_prompt" = yes ]; then
    export CLICOLOR=1
    PROMPT_COMMAND='\
      PS1="\[\033[0;92m\]\u@\h\[\033[00m\]:\[\033[0;34m\]\w\[\033[00m\]$(parse_git_branch)\$ ";\
      if [ -n "$VIRTUAL_ENV" ]; then\
        PS1="(`basename \"$VIRTUAL_ENV\"`)$PS1";\
      fi;\
      set_window_title;'
fi
unset color_prompt force_color_prompt

export JYTHON_HOME=/usr/local//Cellar/jython/2.7-b1/libexec/

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [ -f "$HOME/.bashrc_private" ]; then
  # adds my private bashrc extensions
  . "$HOME/.bashrc_private";
fi
