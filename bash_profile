[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

# Include rbenv in path
export PATH="$HOME/.rbenv/bin:$PATH"

# Boxen
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

# Include home bin
export PATH="$HOME/bin:$PATH"

# Load in the git branch prompt script.
source ~/src/my-environment/bin/git-prompt.sh

# Ruby version (from rbenv) in prompt
# rbenv version | sed -e 's/ .*//'
__rbenv_ps1 ()
{
  rbenv_ruby_version=`rbenv version | sed -e 's/ .*//'`
  printf $rbenv_ruby_version
}

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

  export PS1="$GREEN[\t] $YELLOW\W$RED\$(__git_ps1) $YELLOW\$(__rbenv_ps1) $GREEN\u\[\033[00m\] \\$ "
}

prompt

# Git completion
source ~/src/my-environment/git-completion.bash

# Aliases
alias cdi='cd ~/src/icisstaff'
alias cds='cd ~/src/snowflake'
alias cdf='cd ~/projects/filament'

alias glog='git l'
alias vi="vim"
alias cp="cp -iv"
alias rm="rm -iv"
alias mv="mv -iv"
alias ls="ls -FGh"
alias du="du -cksh"
alias df="df -h"
# Use modern regexps for sed, i.e. "(one|two)", not "\(one\|two\)"
alias sed="sed -E"
alias noascii="sed 's/.\\[[0-9][0-9]?m//g'" # remove ASCII color codes
alias grep=egrep
alias grpe=grep # fix typo
alias pgrep="\grep -P" # PCRE-compatible
export GREP_OPTIONS="--color=auto" # removes color when piping
export GREP_COLOR='1;31' # highlight matches in red
[[ -x $(which colordiff) ]] && alias diff="colordiff -u" || alias diff="diff -u"
[[ -x $(which colormake) ]] && alias make=colormake
alias less="less -R" # correctly interpret ASCII color escapes
alias be='bundle exec'
alias rspec='be rspec'
alias cucumber='be cucumber'
alias cuc='cucumber'
alias bake='be rake'
alias fuci='be fuci'
alias spec='be rspec'
alias frbe='foreman run bundle exec'
alias bails='be rails'
alias wipe='clear && tmux clear-history'
alias sspec='spring rspec'

vim()
{
  local ret STTYOPTS="$(stty -g)"
  stty -ixon
  command vim "$@"
  ret=$?
  stty "$STTYOPTS"
  return "$ret"
}

# For nodenv
export PATH="$HOME/.nodenv/bin:$PATH"

# For my scripts
export PATH="$HOME/src/my-environment/icis_scripts:$PATH"
export PATH="$HOME/src/my-environment/bin:$PATH"
export PATH="$HOME/src/toolchest/bin:$PATH"

# Super secret
source ~/.super-secret-staging-password # For Chirp staging dumps
source ~/.super-secret-jira-password # For Jira CLI

# For Jira CLI
export JIRA_AUTH_TYPE=bearer

# For go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# For release script
export EDITOR="vim"

# For special chrome for tests
export PATH_TO_CHROME_FOR_TESTS="/Applications/Google Chrome Tests.app/Contents/MacOS/Google Chrome"

