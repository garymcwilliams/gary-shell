#!/bin/sh
# .bash_profile
#; <eric@catastrophe.net> || <http://users.catastrophe.net/~eric/>

#echo "in $(pwd}/.bashrc"

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

if [ -r ~/shell/.shell/bashrc ]; then
  . ~/shell/.shell/bashrc
fi
