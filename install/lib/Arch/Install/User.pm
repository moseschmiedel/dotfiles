package Arch::Install::User;

use strict;
use warnings;
use utf8;
use v5.10;

sub new {
    my $class = shift;
    my ($name, $shell, @groups) = @_;
    my $self = bless {
            name => $name,
            shell => $shell,
            groups => \@groups,
        }, $class;

    return $self;
}

sub name {
    my $self = shift;
    $self->{name} = shift if (@_);
    return $self->{name};
}

sub shell {
    my $self = shift;
    $self->{shell} = shift if (@_);
    return $self->{shell};
}

sub groups {
    my $self = shift;
    $self->{groups} = (@_) if (@_);
    return $self->{groups};
}

sub add {
    my $self = shift;
    system 'useradd', '-m', '-G', $self->groups, '-s', $self->shell, $self->name;
}

1;
