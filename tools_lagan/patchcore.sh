#!/bin/bash
#
# utils etc for patch features in the buildcore file
#
# when a new buildcore is released, we need to include the following within it...
#
# after this line{
#. ./env.ksh
# } add this line {
#. ~/tools/patchcore.sh
# }
# this will include this file in the build
#
# everywhere this line appears {
#		create_resource
# }
# change it to this {
#		copy_patch
#		create_resource
# }


copy_core()
{
	echo "*******************"
	echo "Copying Core Source"
	echo "*******************"

	for dir in $CALLDIRS
	do
		if [ ! -d $BUILD_DIR/$CORE_BASE_DIR/$dir ]
		then
			mkdir -p $BUILD_DIR/$CORE_BASE_DIR/$dir/
			if [ ! -d $BUILD_DIR/$CORE_BASE_DIR/$dir ]
			then
				echo "Failed to make directory $BUILD_DIR/$CORE_BASE_DIR/$dir"
				exit 2
			fi
		fi
		cp $CORE_CODE_DIR/$CORE_BASE_DIR/$dir/*.[jg]* $BUILD_DIR/$CORE_BASE_DIR/$dir
	done
}

