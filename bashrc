# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Load pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Set up prompt
source ./vendor/git-prompt.sh
function prompt {
  local  BLACK="\[\033[0;30m\]"
  local  BLACKBOLD="\[\033[1;30m\]"
  local  RED="\[\033[0;31m\]"
  local  REDBOLD="\[\033[1;31m\]"
  local  GREEN="\[\033[0;32m\]"
  local  GREENBOLD="\[\033[1;32m\]"
  local  YELLOW="\[\033[0;33m\]"
  local  YELLOWBOLD="\[\033[1;33m\]"
  local  BLUE="\[\033[0;34m\]"
  local  BLUEBOLD="\[\033[1;34m\]"
  local  PURPLE="\[\033[0;35m\]"
  local  PURPLEBOLD="\[\033[1;35m\]"
  local  CYAN="\[\033[0;36m\]"
  local  CYANBOLD="\[\033[1;36m\]"
  local  WHITE="\[\033[0;37m\]"
  local  WHITEBOLD="\[\033[1;37m\]"

  export PS1="$GREEN[\t] $YELLOW\W$RED\$(__git_ps1) $GREEN\u\[\033[00m\] \\$ "
}
prompt
