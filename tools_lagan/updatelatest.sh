#!/bin/bash
#
# script to resursively migrate the latest (dev) source over a release patch folder
#

outputusage()
{
#	echo "Usage: $0 cvsproject"
	echo "Usage: $0 <destination projects location>"
	echo "   $0 will copy the source files from current heirarchy over the defined folder"
	echo "   The parameter should be the 'project' folder location"
#	echo "   -4 : use frontline 4 build environment"
#	echo "   -5 : use frontline 5 build environment"
	exit 2
}


if [ $# -lt 1 ]
then
	outputusage
fi

# configure the appropriate source & target folders for this build
#src=$MY_ROOT_DIR/../devsource/projects
src=$CVSDEFAULTWORKDIR/workspace/$PROJECT_NAME
dest=`cygpath --unix $1`
#tgt=`cygpath --unix $MY_ROOT_DIR/projects`

echo Moving from $src
echo moving to $dest

# does the matching target folder exist?
if [ -d $dest ]; then
	echo Destination folder does not exist
	outputusage
fi

for j in `ls -F $src`
do
  endch=`expr "$j" : '.*\(.\)$'`
  suffix=`expr "$j" : '.*\.\(.*\)$'`
  #rest=`expr "$j" : '\(.*\).$'`
  #echo j=$j
  #echo endch=$endch
  #echo rest=$rest
  #echo $j ":" suffix=$suffix
  # ignore un-needed files
  if [ "$suffix" = "log" ]; then
	  :
  else
	  if [ "$endch" = "/" ]
		  then
	# ignore project work folders folders
		  if [ $j = "CVS/" ]; then
			  :
		  elif [ $j = "bin/" ]; then
			  :
		  elif [ $j = "temp/" ]; then
			  :
		  else
			  updatelatest.sh $1 $2$j
		  fi
	  else
	# ignore working files
		  lastch=`expr "$j" : '.*\(.\)$'`
		  if [ $lastch = "~" ]; then
			  :
		  elif [ $lastch = "#" ]; then
			  :
		  else
#		if [ $j -nt $dest/$j ]; then
			  echo "  >" copying $j
			  cp -f $j $dest 
#		else
#			echo "  " ignoring $j
#		fi
		  fi
	  fi
  fi
done

# $Id: updatelatest.sh,v 1.4 2004/08/18 07:27:29 gary Exp $
