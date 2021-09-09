# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias ..="cd ../"
alias ...="cd ../../"
alias emacs="emacs -nw"
alias e="emacs -nw"
alias sqs="squeue -u $USER -M all"
alias sqg="squeue -u $USER -M gpu"
alias sqm="squeue -u $USER -M mpi"
alias ccancel="crc-scancel.py "

alias jobi="sacct --format=JobID,Submit,Start,AllocCPUS,MaxRSS,Timelimit,Elapsed -j "

#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[36m\]\h:\[\033[32;1m\]\w\n\[\033[0;33m\]\d@\t[\!:\#]\[\033[m\]\$ "
#export LSCOLORS=ExFxBxDxCxegedabagacad

#module load python/3.7.0 gcc/8.2.0 gnuplot/5.2.4 

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

    PS1+="$bold$cyan\u$magenta@\h$reset\$ "    
    export PS1
}

# Run the git_bash_prompt function at every prompt
PROMPT_COMMAND=git_venv_prompt

#export VIRTUAL_ENV_DISABLE_PROMPT=1

# Custom functions
#function act() { venv="/home/$USER/venv/$1/bin/activate" && source $venv; }

# export FW_CONFIG_FILE=/ihome/gmpourmpakis/djb184/code/atomate/config/FW_config.yaml
# . /ihome/crc/install/python/miniconda3-3.7/etc/profile.d/conda.sh
# conda activate

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/ihome/walsaidi/djb184/code/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/ihome/walsaidi/djb184/code/miniconda/etc/profile.d/conda.sh" ]; then
        . "/ihome/walsaidi/djb184/code/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/ihome/walsaidi/djb184/code/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

