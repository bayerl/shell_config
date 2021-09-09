# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

unset color_prompt force_color_prompt

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

#export EDITOR='/usr/bin/emacs -nw'
# setup for emacsclient (emacs --daemon is startup program)
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode


# based on https://github.com/artemmavrin/git-venv-prompt/blob/master/git_venv_prompt.sh
# modified for my preferences
git_venv_prompt() {
    # Define the colors that will be used
    local bold="\[$(tput bold)\]"
    local blue="\[$(tput setaf 33)\]"
    local orange="\[$(tput setaf 166)\]"
    local green="\[$(tput setaf 64)\]"
    local yellow="\[$(tput setaf 136)\]"
    local red="\[$(tput setaf 124)\]"
    local cyan="\[$(tput setaf 37)\]"
    local magenta="\[$(tput setaf 125)\]"
    local violet="\[$(tput setaf 61)\]"
    local reset="\[$(tput sgr0)\]"
    local status=""

    PS1="\n"
    
    # Check that we're in a directory managed by git
    if $(git rev-parse &> /dev/null); then
        # Check for any changes
        git update-index --really-refresh -q &> /dev/null

        # Save current directory and move to the top directory of the git repo
        pushd . &> /dev/null
        cd "$(git rev-parse --show-toplevel)"

        PS1+="($yellow"

        # Try to get the current branch name
        PS1+=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) \
            || PS1+=$(git rev-parse --short HEAD 2> /dev/null) \
            || PS1+="unknown branch"
	PS1+="$reset"
	
        # Check that we're not in a subdirectory of .git
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]
        then
            # Check for uncomitted changes
            if ! $(git diff --staged --quiet); then
                status+="$green+"
                status+=$(git diff --staged --numstat | wc -l | sed 's/ //g')
            fi

            # Check for unstaged changes
            if ! $(git diff-files --quiet); then
                status+="$yellow!"
                status+=$(git diff-files | wc -l | sed 's/ //g')
            fi

            # Check for untracked files
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                status+="$red?"
                status+=$(git ls-files --others --exclude-standard \
                    | wc -l | sed 's/ //g')
            fi

            if [ -n "$status" ]; then
                status=" $status"
            fi
        fi
        PS1+="$status$reset) "

        # Return to the current directory
        popd &> /dev/null
    fi

    # print working directory
    PS1+="[$bold$green\w$reset]\n"
    
    # Handling of Python virtual environments
    # https://stackoverflow.com/a/20026992/1917160
    if [ -n "$VIRTUAL_ENV" ]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    if [ -n "$venv" ]; then
        PS1+="($magenta$venv$reset) "
    fi

    PS1+="$bold$cyan\u@\h$reset\$ "    
    export PS1
}

# Run the git_bash_prompt function at every prompt
PROMPT_COMMAND=git_venv_prompt

#export VIRTUAL_ENV_DISABLE_PROMPT=1

# Custom functions
function act() { venv="/home/$USER/venv/$1/bin/activate" && source $venv; }

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
