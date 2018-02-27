#!/bin/sh
# .bash_profile
#; <eric@catastrophe.net> || <http://users.catastrophe.net/~eric/>

#echo "in $(pwd)/.bashrc, TERM=$TERM"

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

if [ -r ~/shell/.shell/bashrc ]; then
#  echo "including ~/shell/.shell/bashrc"
  . ~/shell/.shell/bashrc
fi
