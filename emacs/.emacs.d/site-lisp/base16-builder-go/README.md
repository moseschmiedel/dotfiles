# base16-builder-go

A simple builder for base16 templates and schemes, modeled off of
[base16-builder-php](https://github.com/chriskempson/base16-builder-php).

This currently implements version 0.9.1 of the [base16
spec](https://github.com/chriskempson/base16).

## Commands

There are two main commands: update and build.

`update` will pull in any template and scheme updates (or clone the repos if
they don't exist).

`build` will build all templates following the spec for all templates and
schemes defined. If additional arguments are passed, only templates matching the
given names will be built.

## Notes

I'm open to making a few template-specific tweaks as long as they'll be useful
to other templates. Below is a listing of the additions to the base16 spec which
this builder supports.

### Additional variables

* `scheme-slug-underscored` - A version of the scheme slug where dashes have
  been replaced with underscores.
