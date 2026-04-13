# NexOS .bash_profile
# This file is sourced by login shells. It ensures .bashrc is loaded
# for both login and interactive sessions.

# Source .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# Add user's private bin to PATH if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
