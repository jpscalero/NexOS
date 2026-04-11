# Usa la misma base que NexOS para total compatibilidad
FROM debian:trixie

# Evita prompts de apt
ENV DEBIAN_FRONTEND=noninteractive

# Instala utilidades básicas de desarrollo
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    build-essential \
    lsb-release \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Crea un usuario no-root para Codespaces
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Configura el espacio de trabajo
WORKDIR /workspaces/NexOS
USER $USERNAME
