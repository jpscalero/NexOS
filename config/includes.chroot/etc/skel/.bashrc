# Configuración Bash de NexOS Vanguard
# Entorno profesional para Pentesting y Administración de Sistemas

# 1. Banner oficial de NexOS (Arte ASCII)
show_banner() {
    echo -e "\e[1;34m"
    echo "  _   _             ____  ____  "
    echo " | \ | | _____  __/ __ \/ ___| "
    echo " |  \| |/ _ \ \/ / |  | \___ \ "
    echo " | |\  |  __/>  <| |__| |___) |"
    echo " |_| \_|\___/_/\_\\____/|____/ "
    echo -e "      Vanguard Edition v1.x\e[0m\n"
}

# Ejecutar banner y fastfetch si es interactivo
if [[ $- == *i* ]]; then
    show_banner
    command -v fastfetch &>/dev/null && fastfetch --logo small
fi

# 2. Prompt Profesional (PS1)
export PS1="\[\e[1;34m\][\[\e[1;37m\]\u@\h\[\e[1;34m\]:\[\e[1;36m\]\w\[\e[1;34m\]]\[\e[0m\]\$ "

# 3. Cargar Aliases Globales de NexOS
if [ -f /etc/profile.d/nexos-aliases.sh ]; then
    . /etc/profile.d/nexos-aliases.sh
fi

# 4. PATH y Opciones del Shell
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin:$HOME/.local/bin
shopt -s autocd
shopt -s histappend
shopt -s checkwinsize
HISTFILESIZE=5000
HISTSIZE=2000
HISTCONTROL=ignoreboth

# 5. FZF Integration
[[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && \
    source /usr/share/doc/fzf/examples/key-bindings.bash
