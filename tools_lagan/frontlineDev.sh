#!/bin/bash
#
# Script to run a local version of frontline
#

# where are the development classes
devclasses=`cygpath --mixed /d/projects/frontline5/devsource/bin`
# where are the built classes
buildclasses=`cygpath --mixed /d/projects/frontline5/buildsource/bin`
# where are the 'buildcore' local jars
buildjars=`cygpath --mixed /d/projects/frontline5/frontlinebuild`

# Main:
main=com.lagan.lagancentre.core.coreapplication.Frontline

# which jars do we pick up locally
LOCALJARS="
Application.jar
Interface.jar
Util.jar
Tools.jar
"

# add any extra paths, jars, zips here
extrapaths="
//shannon/Frontline/lib/classes12.zip
"

# the classpath is built from the 'bottom up'.
cp=""

for j in $LOCALJARS
do
	if [ ".$LAGAN_SHELL_TYPE" = ".CYGWIN_BASH" ]; then
		cp="`cygpath --absolute --mixed "${buildjars}/${j}"`;$cp"
	else
#		assume MKS
		cp="${buildjars}/${j};$cp"
	fi
done

for j in $extrapaths
do
	if [ ".$LAGAN_SHELL_TYPE" = ".CYGWIN_BASH" ]; then
		cp="`cygpath --absolute --mixed $j`;$cp"
	else
#		assume MKS
		cp="$j;$cp"
	fi
done

cp="$devclasses;$buildclasses;$cp"

# go to runtime folder (for valid config)
configurl=http://shannon/frontline/odmconfig/

cd /d/Lagan/Frontline
policy=d:/Lagan/Frontline/config/policy
echo CP=$cp
echo POLICY=$policy
#java -Djava.security.policy=file://$policy -classpath $cp $*
java  -Djava.security.policy=$policy -classpath $cp $main $configurl
