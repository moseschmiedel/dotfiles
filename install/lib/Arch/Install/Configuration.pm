package Arch::Install::Configuration;

use strict;
use warnings;
use utf8;
use v5.10;

use File::Copy qw/copy/;

sub new {
    my $class = shift;
    my ($origin, $target) = @_;
    my $self = bless {
            origin => $origin,
            target => $target,
        }, $class;

    return $self;
}

sub origin {
    my $self = shift;
    $self->{origin} = shift if (@_);
    return $self->{origin};
}

sub target {
    my $self = shift;
    $self->{target} = shift if (@_);
    return $self->{target};
}

sub copy_config {
    my $self = shift;
    my ($origin, $target) = ($self->origin, $self->target);

    copy($origin, $target)
        or die "Can't copy '$origin' to '$target'";
}

1;
