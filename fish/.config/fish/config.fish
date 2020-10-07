# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

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

# Remove fish greeting
set -x fish_greeting

### sane perltidy defaults (from dboehmer) ###
alias perltidy="perltidy-sweet --backup-and-modify-in-place --backup-file-extension=/ --standard-error-output"

### run various scripts always with sudo ###
alias vpm="sudo vpm"
alias vsv="sudo vsv"
alias reboot="sudo reboot"
alias poweroff="sudo poweroff"

### xbps (void linux pkg-mgr) shortcuts ###
#alias xin="sudo xbps-install -S"
#alias xrm="sudo xbps-remove"
#alias xup="sudo xbps-install -Syu"
#alias xqu="xbps-query -Rs"
