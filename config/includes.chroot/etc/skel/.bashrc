# NexOS Vanguard Bash Configuration
# Professional environment for Pentesting & Sysadmin

# 1. Official NexOS Banner (ASCII Art)
show_banner() {
    echo -e "\e[1;34m"
    echo "  _   _             ____  ____  "
    echo " | \ | | _____  __/ __ \/ ___| "
    echo " |  \| |/ _ \ \/ / |  | \___ \ "
    echo " | |\  |  __/>  <| |__| |___) |"
    echo " |_| \_|\___/_/\_\\____/|____/ "
    echo -e "      Vanguard Edition v1.x\e[0m\n"
}

# Run banner and fastfetch if interactive
if [[ $- == *i* ]]; then
    show_banner
    fastfetch --logo-type small
fi

# 2. Professional Prompt (PS1)
# Format: [nexos@nexos:~/current/dir]$
export PS1="\[\e[1;34m\][\[\e[1;37m\]\u@\h\[\e[1;34m\]:\[\e[1;36m\]\w\[\e[1;34m\]]\[\e[0m\]\$ "

# 3. Useful Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias update-nexos='sudo apt update && sudo apt upgrade'

# 4. PATH and Shell Options
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
shopt -s autocd
shopt -s histappend
HISTFILESIZE=2000
HISTSIZE=1000
