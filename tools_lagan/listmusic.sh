#!/bin/bash

export HOME=`cygpath --unix $HOME`
echo "gathering listings..."
lstfile=~/tmp/music.txt
echo `date` > $lstfile
find //glenree/music -type d -print >> $lstfile
find //anascaul/music -type d -print >> $lstfile
find '//bfs-product-6/My Music' -type d -print >> $lstfile
echo "listed $lstfile"
