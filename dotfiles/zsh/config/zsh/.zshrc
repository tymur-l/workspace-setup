# TODO: remove after tests
#zmodload zsh/zprof

# zsh options

setopt beep nomatch
unsetopt autocd extendedglob notify

# Shell options

# Disable legacy feature to suspend and result terminal input and unassign the keybidnings for the start and stop characters.
# When enabled (default), by default, it makes CTRL-S and CTRL-Q pause and resume the input in the terminal. These keybindings may interfere with keybindings from other plugins.
stty -ixon ixoff start "" stop ""

# Path

typeset -U path PATH
path=(
  ${path}
  /usr/lib/llvm-18/bin
  /usr/local/go/bin
)
export PATH

# Aliases

alias eza="'eza' --icons='always'"
alias e="'eza' --icons='always'"
alias ela="'eza' -la --icons='always'"
alias ls="'eza' --icons='always'"
alias tree="'eza' --icons='always' --tree"

alias grep="'rg'"

alias cd="'z'"

alias cat="'bat' --paging='never' --color='always'"

alias c="'clear'"

alias g="'git'"
alias gst="'git' status"

alias q="'exit'"

# Envs

export EDITOR="$(which nvim)"
export VISUAL="${EDITOR}"

# Multibyte characters

setopt COMBINING_CHARS

# History

HISTFILE=~/.histfile
HISTSIZE=5000 SAVEHIST=5000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Keybindings

bindkey -v

# Use prefix in the zle to scroll through the commands
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

function bind_after_zvm() {
  bindkey '^p' history-search-backward
  bindkey '^n' history-search-forward

  # Unbind this key to enable fzf-git keybindings to work
  bindkey -r '^g'
}
bind_after_zvm

bindkey '^[[Z' reverse-menu-complete

# Initialize and compile plugins

function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

if [[ "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh" -nt "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh.zwc" ]]; then
  zcompile-many "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh"
fi

if [[ "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh" -nt "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh.zwc" ]]; then
  zcompile-many "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh"
fi

if [ ! -e "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab" ]; then
  git clone --branch="v1.1.2" --depth=1 git@github.com:Aloxaf/fzf-tab.git "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab"
  zcompile-many "${ZSH_CUSTOM_PLUGINS_DIR}"/fzf-tab/{fzf-tab.plugin.zsh,fzf-tab.zsh,lib/**/*.zsh}
fi

if [ ! -e "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting" ]; then
  git clone --branch="cf318e06a9b7c9f2219d78f41b46fa6e06011fd9" --depth=1 git@github.com:zdharma-continuum/fast-syntax-highlighting.git "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting"
  zcompile-many "${ZSH_CUSTOM_PLUGINS_DIR}"/fast-syntax-highlighting/{fast-syntax-highlighting.plugin.zsh,fast-syntax-highlighting,fast-theme,share/**/*.zsh}
fi

if [ ! -e "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions" ]; then
  git clone --branch="v0.7.1" --depth=1 git@github.com:zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions"
  zcompile-many "${ZSH_CUSTOM_PLUGINS_DIR}"/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi

# zsh-vi-mode (ZVM)
## Docs: https://github.com/jeffreytse/zsh-vi-mode

# TODO
# TODO: Esc followed by instant c triggers completions. Figure out how to remove this
# typeset -U zvm_after_init_commands
# zvm_after_init_commands+=(
#   "bind_after_zvm"
# )
# export ZVM_INIT_MODE="sourcing"

# TODO: try with zcompile
# # Antidote
# ## https://getantidote.github.io/install
# 
# ANTIDOTE_PATH="${HOME}/.antidote"
# 
# # Set the root name of the plugins files (.txt and .zsh) antidote will use.
# zsh_plugins_txt="${ZDOTDIR:-~}/.zsh_plugins.txt"
# zsh_plugins_zsh="${XDG_STATE_HOME}/.zsh_plugins.zsh"
# 
# # Ensure the .zsh_plugins.txt file exists so you can add plugins.
# [[ -f "${zsh_plugins_txt}" ]] || touch "${zsh_plugins_txt}"
# 
# # Lazy-load antidote from its functions directory.
# fpath=("${ANTIDOTE_PATH}/functions" ${fpath})
# autoload -Uz antidote
# 
# # Generate a new static file whenever .zsh_plugins.txt is updated.
# if [[ ! "${zsh_plugins_zsh}" -nt "${zsh_plugins_txt}" ]]; then
#   antidote bundle <"${zsh_plugins_txt}" >|"${zsh_plugins_zsh}"
# fi
# 
# # Source your static plugins file.
# source "${zsh_plugins_zsh}"

# Completions

setopt NOCORRECT

zstyle ':completion:*' auto-description 'arg: %d'
zstyle ':completion:*' completer _complete _ignored _correct _approximate _prefix
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'Completing [%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt [%l] (%p): Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+r:|[._-]=** r:|=**' '+l:|=* r:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at [%l] (%p)%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true
zstyle :compinstall filename "${HOME}/.config/zsh/.zshrc"

ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${HOST}"

fpath=("${ZSH_COMPLETIONS_DIR}" $fpath)
autoload -Uz compinit
compinit -d "${ZSH_COMPDUMP}"

[[ "${ZSH_COMPDUMP}.zwc"  -nt "${ZSH_COMPDUMP}" ]] || zcompile-many "${ZSH_COMPDUMP}"
unfunction zcompile-many

# Prompt (starship)
##
## Docs: https://starship.rs/config/

# [ -f "${ZSH_CUSTOM_PLUGINS_DIR}/starship_init" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/starship_init"

# zoxide
##
## Docs:
## - https://github.com/ajeetdsouza/zoxide
## - https://github.com/ajeetdsouza/zoxide/wiki

[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/zoxide-integration.zsh"

# bat-extras
##
## Docs: https://github.com/eth-p/bat-extras

### bat-extras configuration
export BATDIFF_USE_DELTA="true"

### Additional completions for the bat-extras scripts.
compdef batdiff=diff
compdef batwatch=watch
compdef batgrep=rg

# fzf
##
## Docs: https://github.com/junegunn/fzf

FZF_CUSTOM_FLAGS=(
  "--wrap"
)

FZF_CUSTOM_KEYBINDINGS=(
  "--bind=ctrl-e:preview-down"
  "--bind=ctrl-y:preview-up"
  "--bind=ctrl-w:toggle-preview-wrap"
)

# Options to fzf command
FZF_COMPLETION_OPTS="${FZF_CUSTOM_FLAGS}"

FZF_FILE_PREVIEW_COMMAND='bat -n --color=always {}'
FZF_DIRECTORY_PREVIEW_COMMAND='eza -a --icons=always --color=always --tree --level=3 {}'

# Options for path completion (e.g. vim **<TAB>)
FZF_COMPLETION_PATH_OPTS="
  --preview '${FZF_FILE_PREVIEW_COMMAND} || ${FZF_DIRECTORY_PREVIEW_COMMAND}'
  ${FZF_CUSTOM_KEYBINDINGS}
  ${FZF_CUSTOM_FLAGS}"

# Options for directory completion (e.g. cd **<TAB>)
FZF_COMPLETION_DIR_OPTS="
  --preview '${FZF_DIRECTORY_PREVIEW_COMMAND}'
  ${FZF_CUSTOM_KEYBINDINGS}
  ${FZF_CUSTOM_FLAGS}"

FZF_CTRL_T_OPTS="${FZF_COMPLETION_PATH_OPTS}"

FZF_ALT_C_OPTS="${FZF_COMPLETION_DIR_OPTS}"

[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-integration.zsh"

# fzf-tab
##
## Docs: https://github.com/Aloxaf/fzf-tab
##
## fzf-tab must be sourced after the `compinit` but before the zsh-autosuggestions.

[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab/fzf-tab.plugin.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/fzf-tab/fzf-tab.plugin.zsh"

# fzf-git
## Docs: https://github.com/junegunn/fzf-git.sh

function _fzf_git_fzf() {
  'fzf' \
    ${FZF_CUSTOM_FLAGS} \
    ${FZF_CUSTOM_KEYBINDINGS} \
    "$@"
}

# fast-syntax-highlighting
##
## Docs: https://github.com/zdharma-continuum/fast-syntax-highlighting

[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# zsh-autosuggestions
##
## Docs: https://github.com/zsh-users/zsh-autosuggestions
##
## Should come after fast-syntax-highlighting.

[ -f "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "${ZSH_CUSTOM_PLUGINS_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# TODO: remove after tests
#zprof # > zsh.prof
