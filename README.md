Gary's shell setup
==================

## Background

Shell setup, mostly geared around cygwin & work

As it's shell type, the line endings need to be LF, so this needs to be set (especially on Cygwin on Windows)

git config core.autocrlf input

If you have already checked out files on cygwin and find that the line endings are already wrong, then you need to fix them (after setting the autocrlf):

git ls-files -z | xargs -0 rm
git checkout .

## Compatibility

runs with bash, cygwin-bash and git-bash

## Installation:
cd ~
git clone https://github.com/garymcwilliams/gary-shell.git shell
cp shell/.bashrc .
cp shell/.bash_profile .

## Notes
on git-bash (in work) the default $HOME dir of h: is not writable.
You need to set the $HOME variable in the user environment to something
(for example `d:\users\gmcwilliams\` and cloning the repo into that
