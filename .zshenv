# Oh my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# NVM directory
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Golang
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GOROOT=/usr/local/go

export PATH=$PATH:$GOBIN:$GOROOT/bin
export PATH=/usr/bin/aws_completer:$PATH

