# ============================================================
#  NexOS — Zsh Default Configuration
#  /etc/skel/.zshrc
#  Beautiful, functional Zsh with plugins
# ============================================================

# ── History ───────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# ── Completion ────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{cyan}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{red}No matches%f'
setopt COMPLETE_ALIASES

# ── Key Bindings ──────────────────────────────────────────
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ── Prompt (Starship-like, pure Zsh) ─────────────────────
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
setopt PROMPT_SUBST

# NexOS branded two-line prompt
PROMPT='
%F{cyan}╭─%f %F{green}%n%f%F{white}@%f%F{blue}%m%f %F{yellow}%~%f${vcs_info_msg_0_}
%F{cyan}╰─%f%F{white}❯%f '
RPROMPT='%F{240}%*%f'

# ── Plugins ───────────────────────────────────────────────
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── FZF Integration ───────────────────────────────────────
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && \
    source /usr/share/doc/fzf/examples/completion.zsh

export FZF_DEFAULT_OPTS='
  --height 40% --layout=reverse --border
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'

# ── Load Global Aliases ───────────────────────────────────
[[ -f /etc/profile.d/nexos-aliases.sh ]] && \
    source /etc/profile.d/nexos-aliases.sh

# ── Welcome ───────────────────────────────────────────────
if command -v fastfetch &>/dev/null; then
    fastfetch --logo small
fi
