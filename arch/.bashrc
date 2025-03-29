#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

alias grep='grep --color=auto'
alias ll="eza --color=always --all --group-directories-first --long --git --icons=always"
alias ls="eza --color=always --all --group-directories-first --long --no-time --git --icons=always"
alias lt="eza --tree --level=2 --long --icons --git"
alias tree="eza --tree"
alias cd="z"
alias vim='nvim'
alias cat='bat'
alias vifm='~/.config/vifm/scripts/vifmrun .'

export EDITOR=nvim
export XDG_CONFIG_HOME=/home/brigadira/.config
export PATH="$XDG_CONFIG_HOME:$PATH"
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_THEME=Arc-Dark:dark
export STARSHIP_CONFIG=~/.config/starship/starship.toml

shopt -s histappend
export PROMPT_COMMAND='history -a'
export HISTCONTROL=ignoreboth
export HISTSIZE=3000
export HISTFILESIZE=10000

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

eval "$(fzf --bash)"
# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"
export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/repos/fzf-git.sh/fzf-git.sh
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ----- Bat (better cat) -----
export BAT_THEME=tokyonight_night

# ---- Zoxide (better cd) ----
eval "$(starship init bash)"
set -o vi
colorscript random
eval "$(zoxide init bash)"
