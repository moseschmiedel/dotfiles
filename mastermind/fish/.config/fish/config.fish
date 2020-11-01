### ssh_agent integration ###
fish_ssh_agent

### perlbrew integration ###
. ~/perl5/perlbrew/etc/perlbrew.fish

### rakubrew integration ###
/home/mose/.rakubrew/bin/rakubrew init Fish | source

set -x SPICETIFY_INSTALL /home/mose/spicetify-cli
set -x PATH $SPICETIFY_INSTALL $PATH
set -x PATH /opt/texlive/2020/bin/x86_64-linux $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/bin $PATH
set -x PATH $HOME/adb-fastboot/platform-tools $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH /home/mose/go/bin $PATH

# Remove fish greeting
set -x fish_greeting

### sane perltidy defaults (from dboehmer) ###
alias perltidy="perltidy-sweet --backup-and-modify-in-place --backup-file-extension=/ --standard-error-output"

### run various scripts always with sudo ###
alias vpm="sudo vpm"
alias vsv="sudo vsv"
alias reboot="sudo reboot"
alias poweroff="sudo poweroff"

### vim like exit alias
alias q="exit"

### Better defaults
alias ls="ls -h --color"
alias ll="ls -l"
alias la="ls -a"

alias cp="cp -v"
alias mv="mv -v"
alias mkdir="mkdir -v"
alias touch="touch -v"

### xbps (void linux pkg-mgr) shortcuts ###
#alias xin="sudo xbps-install -S"
#alias xrm="sudo xbps-remove"
#alias xup="sudo xbps-install -Syu"
#alias xqu="xbps-query -Rs"

# vim: filetype=sh
