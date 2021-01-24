#!/bin/perl
use strict;
use warnings;
use utf8;
use v5.10;
use Term::ANSIColor;
use Cwd qw/cwd/;

use lib 'lib';
use Arch::Install::Configuration;
use Arch::Install::User;

sub install_yay {
    my $curr_dir = cwd;
    system 'git', 'clone', 'https://aur.archlinux.org/yay.git', '/tmp/yay';
    chdir '/tmp/yay';
    system 'makepkg', '-sri';
    chdir $curr_dir;
}

sub install_packages {
    my (@pkgs) = @_;
    my @pkgmgr = qw/yay -Syu/;
    system @pkgmgr, @pkgs;
}

# Expects list of users
sub add_users {
    my (@usrs) = @_;
    $_->add() for (@usrs);
}

sub get_dotfiles {
    my ($url, $destination) = @_;
    system 'groupadd', 'dotfiles';
    system 'git', 'clone', $url, $destination;
    system 'chown', '-R', ':dotfiles', $destination;
}

sub copy_configs {
    my (@confs) = @_;
    for my $conf (@confs) {
        $conf->copy_config();
    }
}

sub start_services {
    my (@srvs) = @_;
    my @proc1mgr = qw(systemctl enable --now);
    for (@srvs) {
        system @proc1mgr, $_;
    }
}

my @packages = (
    'sudo', 
    'intel-ucode',
    'xf86-video-nouvea',
    'xorg-server', 'xorg-apps',
    'lightdm', 'lightdm-webkit2-greeter', 'lightdm-webkit-theme-aether',
    'lxappearance',
    'arandr',
    'pulseaudio', 'pulseaudio-bluetooth',
    'networkmanager', 'network-manager-applet',
    'bluez', 'bluez-utils', 'blueman',
    'docker',
    'cups',
    'alacritty',
    'fish',
    'wget', 'curl',
    'ack',
    'httpie',
    'man-pages', 'man-db', 'texinfo',
    'git', 'tk',
    'pandoc',
    'rofi',
    'nitrogen',
    'texlive-core', 'texlive-latexextra', 'texlive-science', 'texlive-most', 'texlive-bin', 'texlive-fontsextra', 'texlive-lang', 'texlive-bibtexextra', 'texlive-pictures',
    'xclip',
    'neovim',
    'pcmanfm',
    'nextcloud-client',
    'sxiv',
    'ffmpeg',
    'mpv',
    'vlc',
    'zeal',
    'inkscape',
    'gimp',
    'libreoffice-fresh',
    'gnucash',
    'dia',
    'chromium',
    'zathura', 'zathura-cb', 'zathura-djvu', 'zathura-pdf-poppler', 'zathura-ps',
);

my @services = ('bluetooth', 'NetworkManager', 'docker', 'lightdm');

my $conf_mod = 'Arch::Install::Configuration';
my $dotfiles_location = '/dotfiles';
my @configurations = (
    $conf_mod->new("$dotfiles_location/lightdm/lightdm.conf", '/etc/lightdm/lightdm.conf'),
    $conf_mod->new("$dotfiles_location/lightdm/lightdm-webkit2-greeter.conf", '/etc/lightdm/lightdm-webkit2-greeter.conf'),
);

my $user_mod = 'Arch::Install::User';
my @users = ($user_mod->new('mose', '/bin/fish', qw/wheel ftp http games log rfkill sys uucp locate audio disk floppy input vkm optical scanner storage video network/),);

install_packages(@packages) 
    && get_dotfiles('https://github.com/moseschmiedel/dotfiles.git', '/dotfiles') 
    && copy_configs(@configurations) 
    && add_users(@users)
    && start_services(@services)
;

1;
