# NexOS .bash_profile
# Este archivo es leído por shells de login. Asegura que .bashrc se cargue
# tanto para sesiones de login como interactivas.

# Cargar .bashrc si existe
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# Añadir bin privado del usuario al PATH si existe
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
