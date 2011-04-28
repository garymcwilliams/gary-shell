#!/bin/bash
d=tags
echo "moving $d $1"
#for r in laganutil lagancentre
for r in lagancentre
do
	echo svn move http://prod-build-1/svn/$r/$d/$1 http://prod-build-1/svn/$r/xx_old_$d/$1 -m "000000:moved $1 to old"
	svn move http://prod-build-1/svn/$r/$d/$1 http://prod-build-1/svn/$r/xx_old_$d/$1 -m "000000:moved $1 to old"
done
