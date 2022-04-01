alias ..='cd ../'
alias ...='cd ../../'

#alias emacs='emacs -nw'
alias emacs='emacsclient -t' # emacs --daemon running from startup
alias emacskill='emacsclient -e '"'"'(client-save-kill-emacs)'"'"''
alias emacskillf='emacsclient -e '"'"'(kill-emacs)'"'"''
alias e='emacs'

alias deact='deactivate'
alias python='python3'

alias dunyamnas='ssh pi@192.168.1.173'
alias h2p='ssh -Y djb184@h2p.crc.pitt.edu'
alias comet='ssh -Y bayerl@comet-ln2.sdsc.edu'
alias bridges='ssh -Y bayerl@bridges.psc.edu'
alias br2='ssh -Y bayerl@bridges2.psc.edu'
alias inl='ssh bayedyla@hpclogin.inl.gov'

alias vesta='/home/db/code/VESTA-gtk3/VESTA'
alias psload='ps -eo s,user,cmd | grep ^[RD] | sort | uniq -c | sort -nbr'
