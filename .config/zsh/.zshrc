#!/usr/bin/env zsh

#--------------------------------------------------------------
# Environment Variables
#--------------------------------------------------------------
source "$HOME/.zshenv"
source "$HOME/.secrets.sh"

export KOPS_STATE_STORE="s3://kops-state-3huq8vsi"

export NVM_LAZY_LOAD=true
export EDITOR=nvim
export VISUAL=nvim

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

if grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null; then
  export CODEPATH="/c/code"
  export DOCKER_HOST=tcp://0.0.0.0:2375
  export BROWSER="explorer.exe"
  unsetopt BG_NICE
else
  export CODEPATH="$HOME/code"
fi

export GOPATH="$CODEPATH/go"
export PATH="$GOPATH/bin:$HOME/.cargo/bin:$XDG_DATA_HOME/npm/bin:$HOME/.local/bin:/usr/local/sbin:$HOME/Library/Python/3.7/bin:$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export AUTOENV_FILE_ENTER=".env"
export AUTOENV_FILE_LEAVE=".out"
export GEOMETRY_PROMPT_PLUGINS=(exec_time jobs node git terraform dcos)
export GEOMETRY_SYMBOL_PROMPT="♪"
export GEOMETRY_SYMBOL_EXIT_VALUE="ø"
export GEOMETRY_SYMBOL_RPROMPT="♮"

source "$XDG_CONFIG_HOME/fzf/theme.sh"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
#--------------------------------------------------------------
# zplug
#--------------------------------------------------------------

export ZPLUG_HOME="$XDG_DATA_HOME/zplug"
source $ZPLUG_HOME/init.zsh

zplug "yous/vanilli.sh"
zplug "Tarrasch/zsh-autoenv"
zplug "geometry-zsh/geometry"
zplug "pbar1/geometry-terraform"
zplug "pbar1/geometry-dcos"
zplug "supercrabtree/k"
zplug "eendroroy/zed-zsh"
zplug "Dbz/zsh-kubernetes"
zplug "pbar1/zsh-terraform"
zplug "lukechilds/zsh-nvm"
zplug "stackexchange/blackbox"
zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma/fast-syntax-highlighting", defer:2

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo
    zplug install
  fi
fi
zplug load

autoload -Uz compinit && compinit

export GEOMETRY_GIT_SEPARATOR=""

#--------------------------------------------------------------
# Completions, etc
#--------------------------------------------------------------
source "$XDG_CONFIG_HOME/zsh/aliases.sh"
source "$XDG_CONFIG_HOME/zsh/siq.sh"
source <(kubectl completion zsh)
source <(helm completion zsh)
source <(kops completion zsh)
source <(stern --completion zsh)
source <(velero completion zsh)
source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh
complete -C "$(which packer)" packer
complete -C "$(which terraform)" terraform
complete -C "$(which consul)" consul
complete -C "$(which vault)" vault
complete -C "$(which nomad)" nomad
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
