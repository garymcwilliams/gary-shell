#!/bin/sh
# .bash_profile

#echo in ~/.bash_profile
#date

if [ -r ~/shell/.shell/profile ]; then
 . ~/shell/.shell/profile
fi

#echo after profile
#date
if [ -r ~/shell/.shell/bashrc ]; then
 . ~/shell/.shell/bashrc
fi

#echo after bashrc
#date
# $Id: .bash_profile,v 1.3 2004/11/30 11:13:34 gary Exp $
