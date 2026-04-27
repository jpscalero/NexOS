#!/bin/bash
# ============================================================
#  NexOS — Global Aliases & Functions
#  /etc/profile.d/nexos-aliases.sh
#  Loaded by both Bash and Zsh
# ============================================================

# ── Color Defaults ────────────────────────────────────────
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# ── File Listing (Modern) ────────────────────────────────
if command -v eza &>/dev/null; then
    alias ll='eza -la --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias l='eza --icons --group-directories-first'
    alias lt='eza -la --icons --tree --level=2'
else
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
fi

# ── Cat Replacement ──────────────────────────────────────
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'
fi

# ── Navigation ───────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ── Safety ───────────────────────────────────────────────
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ── System ───────────────────────────────────────────────
alias update-nexos='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias sysinfo='fastfetch'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me && echo'
alias localip='hostname -I | awk "{print \$1}"'
alias meminfo='free -h'
alias diskinfo='df -h'
alias cpuinfo='lscpu | head -20'

# ── NexOS Tools ──────────────────────────────────────────
alias harden='sudo nexos-harden'
alias cleanup='sudo nexos-clean'
alias netmon='sudo nexos-netmon'

# ── Docker Shortcuts ─────────────────────────────────────
alias dk='docker'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dki='docker images'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'

# ── Git Shortcuts ────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# ── Security & Pentest Quick Access ──────────────────────
alias scan='sudo nmap -sV -sC'
alias fastscan='sudo nmap -F -sV'
alias vulnscan='sudo nmap --script vuln'
alias sniff='sudo tcpdump -i any -n'
alias listen='sudo netstat -tlnp'

# ── Privacy ──────────────────────────────────────────────
alias torstart='sudo systemctl start tor'
alias torstop='sudo systemctl stop tor'
alias torstatus='sudo systemctl status tor'
alias proxyon='proxychains4'
alias macrand='sudo macchanger -r'

# ── Useful Functions ─────────────────────────────────────

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1"    ;;
            *.tar.gz)  tar xzf "$1"    ;;
            *.tar.xz)  tar xJf "$1"    ;;
            *.bz2)     bunzip2 "$1"    ;;
            *.rar)     unrar x "$1"    ;;
            *.gz)      gunzip "$1"     ;;
            *.tar)     tar xf "$1"     ;;
            *.tbz2)    tar xjf "$1"    ;;
            *.tgz)     tar xzf "$1"    ;;
            *.zip)     unzip "$1"      ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1"       ;;
            *)         echo "'$1' no se puede extraer" ;;
        esac
    else
        echo "'$1' no es un archivo válido"
    fi
}

# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Quick HTTP server
serve() { python3 -m http.server "${1:-8000}"; }

# Quick port check
portcheck() { nc -zv "$1" "$2" 2>&1; }

# Get public IP with geolocation
whereami() {
    echo "=== IP Pública ==="
    curl -s ipinfo.io | jq '.' 2>/dev/null || curl -s ipinfo.io
}

# Quick hash of file
hashfile() {
    if [ -f "$1" ]; then
        echo "MD5:    $(md5sum "$1" | awk '{print $1}')"
        echo "SHA1:   $(sha1sum "$1" | awk '{print $1}')"
        echo "SHA256: $(sha256sum "$1" | awk '{print $1}')"
    else
        echo "Archivo no encontrado: $1"
    fi
}
