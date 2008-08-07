#####################################################################################
#
# Build script for Frontline Patch Sources
#
# The following JARS are produced:
#
#	Application.jar
#	ApplicationLoader.jar
#	Service.jar
#	Interface.jar
#	Util.jar
# 
# Source: L:/RCS/lagancentre/build/frontline/buildscripts//buildcore.ksh
# Revision: 1.106
# Author(s): Andrew Irvine
#
######################################################################################

if [ ! -f env.ksh ]
then
	echo "Must have an env.ksh in the current directory"
	exit 1
fi

. ./env.ksh
export PATCH_DIR=${MY_PATCH_DIR:-"D:/frontlinebuild"}
export BUILD_CODE_DIR=$CORE_CODE_DIR
export BUILD_ROOT_DIRECTORY=$CORE_ROOT_DIRECTORY
export CORE_CODE_DIR=$PATCH_DIR/projects/lagancentre/code
export UTIL_CODE_DIR=$PATCH_DIR/projects/laganutil/code
export CORE_ROOT_DIRECTORY=$PATCH_DIR/projects/lagancentre

# Remember the directory that this script was run from.
curpwd=`pwd`

#
# These directories contain stuff which goes into the Util jar.
# They are only divided up for readability.
#
UBEANDIRS="		bean"

USWINGDIRS="	swing 							\
				swing/dnd 					\
				swing/event					\
				swing/framemanager 				\
				swing/listener 					\
				swing/ltable					\
				swing/tablepanel				\
				swing/lusertable				\
				swing/spinner 					\
				swing/swingutilities				\
				swing/swingwork"

UUTILDIRS="		util/assert 						\
				util/idgenerator				\
				util/bundlehandler 				\
				util/calendarutilities 				\
           		util/comparator			\
				util/databaseconnection 			\
				util/databasestatement 				\
				util/encryption					\
				util/externalapplicationhandler 		\
				util/fileutilities 				\
				util/logger 					\
				util/objectqueue				\
				util/objectstore				\
				util/objectpool					\
				util/rmi 					\
				util/service 					\
				util/sms					\
				util/stringutilities 				\
				util/statistician				\
				util/numericutilities 				\
				util/timeslice					\
				util/threadpool					\
				util/timeutilities				\
				util/vectorutilities				\
				util/validation"

UALLDIRS="$UBEANDIRS $USWINGDIRS $UUTILDIRS"

#
# The Core Swing and Util directories are in Core but actually go into the Util jar.
#
CSWINGDIRS="	swing/table"
CUTILDIRS="			util						\
                		util/authorisation				\
                		util/bookmark					\
                		util/casetasklists			\
                		util/correspondence				\
				util/scriptflow					\
				util/enquiryinteraction				\
				util/cases					\
				util/odm					\
				util/relationshipmanagement			\
				util/forms					\
				util/eforms					\
				util/event					\
				util/portlet					\
				util/roles					\
				util/search					\
				util/xml/converter
"

#
# The Core Bean directories go into the Application jar,
# and any Stub classes in them go into the Interface jar.
#
CBEANDIRS="		bean/agentcallhistoryview				\
				bean/activeobjectview				\
				bean/alarmbean					\
				bean/applicationevent				\
				bean/blendconfiguremodel			\
				bean/blendconfigureview 			\
				bean/browserbean				\
				bean/campaignmodel				\
				bean/campaignview				\
				bean/casemanagementbean				\
				bean/caseconfigureview				\
				bean/caselistviewer                             \
				bean/casepullmodel                              \
				bean/casepullview                               \
				bean/caseworkflowmodel				\
				bean/caseworkflowconfigview			\
				bean/casedialogs				\
				bean/casetreemodel				\
				bean/clientsetupmodel				\
				bean/clientsetupview				\
				bean/configurationview				\
				bean/componentconfigview			\
				bean/correspondencebean				\
				bean/correspondencemodel			\
				bean/correspondenceview				\
				bean/currentcaseview            	        \
				bean/currentdetailsmodel			\
				bean/currentdetailsview				\
				bean/currentenquirymodel			\
				bean/currentobjectmodel				\
				bean/currentobjectview				\
				bean/currentobjectdetailsmodel			\
				bean/currentobjectdetailsview			\
				bean/currentinteractionmodel			\
				bean/currentinteractionview			\
				bean/dynamicdatamodel				\
				bean/dynamicdataview				\
				bean/datacaptureview				\
				bean/eformmodel					\
				bean/eformsmanager				\
				bean/emailconfigureview				\
				bean/emailmodel					\
				bean/enquiryconfigmodel				\
				bean/enquiryconfigview				\
				bean/enquirysearchmodel				\
				bean/enquirysearchview				\
				bean/enquiryviewers				\
				bean/enquiryhistorymodel			\
				bean/enquiryhistoryview				\
				bean/enquiryclassificationmodel			\
				bean/enquiryinteractiondialogs			\
				bean/enquiryinteractionhistoryview		\
				bean/event					\
				bean/externalapplicationsmodel			\
				bean/externalapplicationsview			\
				bean/frontlineeventsmodel			\
				bean/frontlineeventsview			\
				bean/facetofaceview				\
				bean/facetofacemodel				\
				bean/facetofacecontrolview			\
				bean/groupagentnumberselector			\
				bean/groupconfigurationview			\
				bean/informationbean				\
				bean/informationindicatorview			\
				bean/interactionhandlers			\
				bean/interactionhistorymodel			\
				bean/interactionhistoryview			\
				bean/interactionviewers				\
				bean/loginmodel					\
				bean/loginview					\
				bean/loggingmodel				\
				bean/menubarview				\
				bean/messagingmodel				\
				bean/messagingview				\
				bean/navigationmodel				\
				bean/navigationview				\
				bean/notesviewers				\
				bean/outboundcalldialer				\
				bean/phonenumberselectors			\	
				bean/relationshipmanagementmodel		\
				bean/relationshipmanagementview			\
				bean/scriptflowexecutionmodel			\
				bean/scriptflowexecutionview			\
				bean/scriptflowassociationmodel			\
				bean/scriptflowconfigview			\
				bean/scriptflowconfigmodel			\
				bean/scriptflowtemplatemodel			\
				bean/scriptingmodel				\
				bean/scriptingview				\
				bean/searchmodel				\
				bean/searchview					\
				bean/serviceconfigurationmodel			\
				bean/serviceconfigurationview			\
				bean/slaconfigurationmodel			\
				bean/slaconfigurationview			\
				bean/rtmmodel					\
				bean/rtmview					\
				bean/telephonymodel				\
				bean/taskmodel					\
				bean/taskconfigmodel				\
				bean/qmaticview					\
				bean/qmaticmodel				\
				bean/qmaticworkcontrolview			\
				bean/triggerconfiguremodel			\
				bean/triggerconfigureview			\
				bean/triggerexecutionmodel			\
				bean/useradminmodel				\
				bean/useradminview				\
				bean/userdetailsview				\
				bean/wallboardview				\
				bean/wfmconfigmodel				\
				bean/wfmconfigview				\
				bean/workcontrolview				\
				bean/workmodel					\
				bean/workstatusview				\
				bean/workqueuemodel				\
				bean/workqueueconfigureview			\
				bean/workqueuestatspanel			\
				bean/xmlconfigview         			\
				bean/xmlmodel           			\
				bean/xmlview	           			\
				bean/componentfeaturesretriever			\
				bean/agentnotificationview			\
				guicomponents					\
				guicomponents/dialog				\
				guicomponents/filechooser			\
				guicomponents/fileviewer			\
				guicomponents/internalviewer			\
				guicomponents/portlets				\
				guicomponents/portlets/fields			\
				guicomponents/resourceselection			\
				guicomponents/forms				\
				guicomponents/search				\
				guicomponents/splitter				\
				guicomponents/urlchooser			\
				guicomponents/wizard"

#
# The Core Bean Interface directories go into the Interface jar.
#
CBEANINTFCDIRS="beaninterface/workcontrolbeaninterface			\
				beaninterface/usermessagingmodel	\
				beaninterface/userqmaticmodel		\
				beaninterface/workhandlerinterface"

#
# The Core Service directories go into the Service jar,
# and any Stub classes in them go into the Interface jar.
#
CSERVDIRS="			jms/adaptor					\
				jms/converter					\
				service/alarmservice				\
				service/archiveservice				\
				service/baseservice				\
				service/bidderservice				\
				service/campaignservice				\
				service/casemanservice				\
				service/correspondenceservice			\
				service/documentrepositoryservice		\
				service/emailservice				\
				service/enquiryinteractionservice		\
				service/interactionprofileservice		\
				service/lrmiregistryservice			\
				service/messagingservice			\
				service/qmaticservice				\
				service/relationshipmanager			\
				service/scheduleimportservice			\
				service/schedulerservice			\
				service/scriptflowservice			\
				service/scriptingservice			\
				service/xmlservice     			        \
				service/useradminservice"


#
# The Core Service Interface directories go into the Interface jar.
#
CSERVINTFCDIRS="serviceinterface/alarmserviceinterface						\
				serviceinterface/archiveinterface				\
				serviceinterface/activitylog					\
				serviceinterface/campaigninterface				\
				serviceinterface/casemaninterface				\
				serviceinterface/caseworkflowinterface				\
				serviceinterface/clientsetupinterface				\
				serviceinterface/correspondenceinterface			\
				serviceinterface/currentobjectdetailsinterface			\
				serviceinterface/documentrepositoryinterface			\
				serviceinterface/emailserviceinterface				\
				serviceinterface/facetofaceinterface				\
				serviceinterface/enquiryinteractioninterface			\
				serviceinterface/enquiryconfiginterface				\
				serviceinterface/interactionprofileinterface			\
				serviceinterface/lrmiregistryinterface				\
				serviceinterface/messaginginterface				\
				serviceinterface/odmgateway					\
				serviceinterface/pagelist					\
				serviceinterface/remotefileviewerinterface			\
				serviceinterface/relationshipmanagementinterface		\
				serviceinterface/scheduleimport					\
				serviceinterface/schedulemanager				\
				serviceinterface/schedulerinterface				\
				serviceinterface/schedulerworkinterface				\
				serviceinterface/scriptflowinterface				\
				serviceinterface/scriptinginterface				\
				serviceinterface/searchinterface				\
				serviceinterface/localmonitor					\
				serviceinterface/slaserviceinterface				\
				serviceinterface/useradmininterface				\
				serviceinterface/qmaticinterface				\
				serviceinterface/workqueueconfiginterface			\
				serviceinterface/xmlinterface           			\
				serviceinterface/logginginterface				\
				servicereconnector/interactionprofilereconnector"

#
# The Core Application directories go into the Application jar.
#
CAPPDIRS="		coreapplication					\
				images		\
				initializableappinterface		\
				integratorjava				\
				integratorintranet			\
				integratorjava/event			\
				lookandfeel/standard/border		\
				startupframe"

#
# The Core Application Loader directory goes into the ApplicationLoader jar.
#
CAPLDIRS="		applicationloader"

#
# These directories also go into the ApplicationLoader jar.
# They are duplicated from other lists, for convenience.
#
CAPLOBJDIRS="	lagancentre/core/applicationloader			\
				lagancentre/core/initializableappinterface"
				
#
# All Core directories, for use when copying.
#
CALLDIRS="$CAPPDIRS $CSERVINTFCDIRS $CSERVDIRS $CBEANINTFCDIRS $CBEANDIRS $CAPLDIRS $CUTILDIRS"

#
# Directories which are not compiled when Frontline.java and all services are compiled.
#
CUNREFDIRS="	applicationloader				\
				bean/browserbean		\
				bean/correspondencemodel	\
				bean/phonenumberselectors	\
				guicomponents/internalviewer	\
				integratorjava			\
				jms/adaptor			\
				servicereconnector/interactionprofilereconnector	\
				util"

UUNREFDIRS="	util/calendarutilities				\
				util/databasestatement		\
				util/objectpool			\
				util/service			\
				util/sms			\
				swing/ltable			\
				swing"

#
# Utilities in the tools directories
#
TOOLDIRS="		tools								                    \
				tools/securitymanager                                   \
				tools/securitymanager/securitymanagerinterface          \
				tools/servicecontrolcentre/application			        \
				tools/servicecontrolcentre/servicecontrolcentremodel	\
				tools/servicecontrolcentre/servicecontrolcentreview"

#
# Installer
#
INSTALLDIRS="		install"								                   
			
#
# The Core directory in a form recognisable by RMIC.
#
RMICORE="com.lagan.lagancentre.core"

#
# The classes which need to be RMICed.  These are relative to RMICORE.
#
CRMIFILES="		service.alarmservice.AlarmService						\
				service.archiveservice.ArchiveService					\
				service.campaignservice.CampaignService					\
				service.casemanservice.CaseManagement					\
				service.correspondenceservice.CorrespondenceService			\
				service.documentrepositoryservice.MeridioDocumentRepositoryService	\
				service.emailservice.EmailService					\
				service.enquiryinteractionservice.EnquiryInteractionService		\
				service.interactionprofileservice.InteractionProfile			\
				service.messagingservice.MessagingService				\
				service.qmaticservice.QMaticService					\
				service.scheduleimportservice.ScheduleImportService				\
				service.schedulerservice.ScheduleHandler				\
				service.schedulerservice.SchedulerService				\
				service.scriptflowservice.ScriptFlowService				\
				service.scriptingservice.ScriptingService				\
				service.useradminservice.UserAdminService				\
				service.casemanservice.WorkFlowManager					\
				service.xmlservice.XMLService					        \
				bean.messagingmodel.MessagingModel					\
				bean.qmaticmodel.QMaticModel						\
				bean.workmodel.WorkModel"

#
# First copy all the sources across.  We specify *.[jg]* to make sure we don't
# get any subdirectories copied.  This will catch .java, .jpg and .gif.
# If another suffix type is required then the wildcard string should be modifed.
#

copy_util()
{
	echo "*****************"
	echo "Copying Utilities"
	echo "*****************"

	for dir in $UALLDIRS
	do
		if [ -d $UTIL_CODE_DIR/$UTIL_BASE_DIR/$dir ]
		then
			if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/$dir ]
			then
				mkdir -p $BUILD_DIR/$UTIL_BASE_DIR/$dir/
				if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/$dir ]
				then
					echo "Failed to make directory $BUILD_DIR/$UTIL_BASE_DIR/$dir"
					exit 2
				fi
			fi
			numSrcs=`ls -1 $UTIL_CODE_DIR/$UTIL_BASE_DIR/$dir/*.[jg]* 2>/dev/null | wc -l`
			if [ $numSrcs -gt 0 ]; then
				cp $UTIL_CODE_DIR/$UTIL_BASE_DIR/$dir/*.[jg]* $BUILD_DIR/$UTIL_BASE_DIR/$dir
			fi
		fi
	done

	for dir in $CSWINGDIRS
	do
		if [ -d $CORE_CODE_DIR/$UTIL_BASE_DIR/$dir ]
		then
			if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/$dir ]
			then
				mkdir -p $BUILD_DIR/$UTIL_BASE_DIR/$dir/
				if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/$dir ]
				then
					echo "Failed to make directory $BUILD_DIR/$UTIL_BASE_DIR/$dir"
					exit 2
				fi
			fi
			numSrcs=`ls -1 $CORE_CODE_DIR/$UTIL_BASE_DIR/$dir/*.[jg]* 2>/dev/null | wc -l`
			if [ $numSrcs -gt 0 ]; then
				cp $CORE_CODE_DIR/$UTIL_BASE_DIR/$dir/*.[jg]* $BUILD_DIR/$UTIL_BASE_DIR/$dir
			fi
		fi
	done
}

copy_core()
{
	echo "*******************"
	echo "Copying Core Source"
	echo "*******************"

	for dir in $CALLDIRS
	do
		if [ -d $CORE_CODE_DIR/$CORE_BASE_DIR/$dir ]
		then
			if [ ! -d $BUILD_DIR/$CORE_BASE_DIR/$dir ]
				then
				mkdir -p $BUILD_DIR/$CORE_BASE_DIR/$dir/
				if [ ! -d $BUILD_DIR/$CORE_BASE_DIR/$dir ]
					then
					echo "Failed to make directory $BUILD_DIR/$CORE_BASE_DIR/$dir"
					exit 2
				fi
			fi
			numSrcs=`ls -1 $CORE_CODE_DIR/$CORE_BASE_DIR/$dir/*.[jg]* 2>/dev/null | wc -l`
			if [ $numSrcs -gt 0 ]; then
				cp $CORE_CODE_DIR/$CORE_BASE_DIR/$dir/*.[jg]* $BUILD_DIR/$CORE_BASE_DIR/$dir
			fi
		fi
	done
}

copy_tools()
{
	echo "*******************"
	echo "Copying Tool Source"
	echo "*******************"

	for dir in $TOOLDIRS
	do
		if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir ]
		then
			mkdir -p $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir/
			if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir ]
			then
				echo "Failed to make directory $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir"
				exit 2
			fi
		fi
		numSrcs=`ls -1 $CORE_CODE_DIR/$UTIL_BASE_DIR/lagancentre/$dir/*.[jg]* 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			cp $CORE_CODE_DIR/$UTIL_BASE_DIR/lagancentre/$dir/*.[jg]* $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir
		fi
	done
}

copy_install()
{
	echo "************************"
	echo "Copying Installer Source"
	echo "************************"

	for dir in $INSTALLDIRS
	do
		if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir ]
		then
			mkdir -p $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir/
			if [ ! -d $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir ]
			then
				echo "Failed to make directory $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir"
				exit 2
			fi
		fi
		numSrcs=`ls -1 $CORE_CODE_DIR/$UTIL_BASE_DIR/lagancentre/$dir/*.[jg]* 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			cp $CORE_CODE_DIR/$UTIL_BASE_DIR/lagancentre/$dir/*.[jg]* $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir
		fi
	done
}

create_resource()
{
	#
	# Change the applicationloader picture to be the same as the one in coreapplication.
	#
	if [ -f $PATCH_DIR/$CORE_BASE_DIR/coreapplication/startup.jpg ]; then
		if [ -f $BUILD_DIR/$CORE_BASE_DIR/applicationloader/default.jpg ]; then
			rm -f $BUILD_DIR/$CORE_BASE_DIR/applicationloader/default.jpg
		fi
		cp $PATCH_DIR/$CORE_BASE_DIR/coreapplication/startup.jpg $BUILD_DIR/$CORE_BASE_DIR/applicationloader/default.jpg
	fi

	#
	# Create the Core resource bundle.
	#
	echo "********************"
	echo "Amending Core Config"
	echo "********************"

	numSrcs=`ls -1 $CORE_CODE_DIR/../config/screentext/*.properties 2>/dev/null | wc -l`
	if [ $numSrcs -gt 0 ]; then
		cat $CORE_CODE_DIR/../config/screentext/*.properties >> $BUILD_DIR/frontlinelocale.properties
	fi
}

compile_util()
{
	#
	# Compile the Utility Sources and the Core Utility Sources.
	#

	echo "*******************"
	echo "Compiling Utilities"
	echo "*******************"

	for dir in $UALLDIRS $CSWINGDIRS
	do
		echo "Compiling $dir"
		cd $BUILD_DIR/$UTIL_BASE_DIR/$dir
		numSrcs=`ls -1 *.java 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			javac *.java
		fi
	done

	for dir in $CUTILDIRS
	do
		echo "Compiling $dir"
		cd $BUILD_DIR/$CORE_BASE_DIR/$dir
		numSrcs=`ls -1 *.java 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			javac *.java
		fi
	done
}

compile_interface()
{
	#
	# Compile the Interface Sources
	#

	echo "********************"
	echo "Compiling Interfaces"
	echo "********************"

	cd $BUILD_DIR/$CORE_BASE_DIR/serviceinterface
	numSrcs=`find . -name *.java -print 2>/dev/null | wc -l`
	if [ $numSrcs -gt 0 ]; then
		javac */*.java
	fi

	cd $BUILD_DIR/$CORE_BASE_DIR/beaninterface
	numSrcs=`find . -name *.java -print 2>/dev/null | wc -l`
	if [ $numSrcs -gt 0 ]; then
		javac */*.java
	fi
}

compile_core()
{
	#
	# Compile all the remaining Core Sources
	#

	echo "**************************"
	echo "Compiling Services & Beans"
	echo "**************************"

	for dir in $CSERVDIRS $CBEANDIRS $CAPLDIRS $CAPPDIRS
	do
		echo "Compiling $dir"
		cd $BUILD_DIR/$CORE_BASE_DIR/$dir
		numSrcs=`ls -1 *.java 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			javac *.java
		fi
	done
}

compile_tools()
{
	#
	# Compile all the tools Sources
	#

	echo "**************************"
	echo "Compiling Tools "
	echo "**************************"

	for dir in $TOOLDIRS
	do
		echo "Compiling $dir"
		cd $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir
		numSrcs=`ls -1 *.java 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			javac *.java
		fi
	done
}

compile_install()
{
	#
	# Compile all the installer Sources
	#

	echo "********************"
	echo "Compiling Installer "
	echo "********************"

	for dir in $INSTALLDIRS
	do
		echo "Compiling $dir"
		cd $BUILD_DIR/$UTIL_BASE_DIR/lagancentre/$dir
		numSrcs=`ls -1 *.java 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			javac *.java
		fi
	done
}

compile_unref_dirs()
{
	echo "**************************"
	echo "Compiling Unreferenced Directories"
	echo "**************************"

	for dir in $CUNREFDIRS
	do
		echo "Compiling $dir"
		cd $BUILD_DIR/$CORE_BASE_DIR/$dir
		numSrcs=`ls -1 *.java 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			javac *.java
		fi
	done

	for dir in $UUNREFDIRS
	do
		echo "Compiling $dir"
		cd $BUILD_DIR/$UTIL_BASE_DIR/$dir
		numSrcs=`ls -1 *.java 2>/dev/null | wc -l`
		if [ $numSrcs -gt 0 ]; then
			javac *.java
		fi
	done
}

obfuscate()
{
	#
	# Obfuscate the .class files.
	#

	echo "***********"
	echo "Obfuscation"
	echo "***********"

	cd $BUILD_DIR/com
	$SHRINK_DIR/jshrink .
}

rmi()
{
	#
	# Run RMIC on all the necessary .class files.
	#

	echo "***********"
	echo "RMI Compile"
	echo "***********"

	cd $BUILD_DIR

	for rmi in $CRMIFILES
	do
		echo "RMIC $rmi"
		rmic $RMICORE.$rmi
	done
}

make_jars()
{
	#
	# Make up the jar files.  Each one is started off with the manifest file,
	# then the built objects are added to it.
	#

	echo "********************"
	echo "Building Utility Jar"
	echo "********************"

	cd $BUILD_DIR
	jar -cfm Util.jar manifest/build.manifest com/lagan/bean com/lagan/swing com/lagan/util com/lagan/lagancentre/core/util com/lagan/lagancentre/core/images

	echo "********************"
	echo "Building Service Jar"
	echo "********************"

	cd $BUILD_DIR
	jar -cfm Service.jar manifest/build.manifest com/lagan/lagancentre/core/service com/lagan/lagancentre/core/jms

	echo "**********************"
	echo "Building Interface Jar"
	echo "**********************"

	cd $BUILD_DIR
	jar -cfm Interface.jar manifest/build.manifest com/lagan/lagancentre/core/serviceinterface com/lagan/lagancentre/core/beaninterface com/lagan/lagancentre/core/servicereconnector 

	for dir in $CSERVDIRS $CBEANDIRS
	do
		find $CORE_BASE_DIR/$dir -name "*_Stub.class" -print | while read class
		do
			echo $class
			jar -uf Interface.jar $class
			rm -f $class
		done
	done

	echo "************************"
	echo "Building Application Jar"
	echo "************************"

	cd $BUILD_DIR
	jar -cfm Application.jar manifest/build.manifest com/lagan/lagancentre/core/bean com/lagan/lagancentre/core/guicomponents
	for dir in $CAPPDIRS
	do
		jar -uf Application.jar $CORE_BASE_DIR/$dir/*
	done

	echo "*******************************"
	echo "Building Application Loader Jar"
	echo "*******************************"

	cd $BUILD_DIR

	cp manifest/build.manifest manifest/build.manifest.app

	ed manifest/build.manifest.app <<-EOF
	a
	Main-Class: com.lagan.lagancentre.core.applicationloader.ApplicationLoader
	Class-Path: ..
	.
	w
	q
	EOF

	jar -cfm ApplicationLoader.jar manifest/build.manifest.app

	for dir in $CAPLOBJDIRS
	do
		jar -uf ApplicationLoader.jar $UTIL_BASE_DIR/$dir/*
	done

	echo "*******************************"
	echo "Building Tools Jar"
	echo "*******************************"

	cd $BUILD_DIR

	jar -cfm Tools.jar manifest/build.manifest com/lagan/lagancentre/tools

	echo "*******************************"
	echo "Building Installer Jar"
	echo "*******************************"

	cd $BUILD_DIR

	jar -cfm Installer.jar manifest/build.manifest com/lagan/lagancentre/install

	if [ "$signjars" = "y" ]; then

		echo "************"
		echo "Signing Jars"
		echo "************"
		
		jarsigner -storepass reptile -keystore $BUILD_ROOT_DIRECTORY/certificate/LaganKeystore Application.jar laganuser
		jarsigner -storepass reptile -keystore $BUILD_ROOT_DIRECTORY/certificate/LaganKeystore Service.jar laganuser
		jarsigner -storepass reptile -keystore $BUILD_ROOT_DIRECTORY/certificate/LaganKeystore Interface.jar laganuser
		jarsigner -storepass reptile -keystore $BUILD_ROOT_DIRECTORY/certificate/LaganKeystore Util.jar laganuser
	else

		echo "************************"
		echo "skipping Signing of Jars"
		echo "************************"
		
	fi
}

remove_java()
{
	echo "****************"
	echo "Clearing sources"
	echo "****************"

	cd $BUILD_DIR
	find . -name *.java -print | xargs rm -f
}

compile_frontline_quick()
{
	echo "**************************"
	echo "Compiling Frontline"
	echo "**************************"

	cd $BUILD_DIR/$CORE_BASE_DIR/coreapplication
	if [ -f Frontline.java ]; then
		javac -J-mx128m Frontline.java
	fi
}

compile_service_quick()
{
	echo "**************************"
	echo "Compiling Services"
	echo "**************************"

	echo "Compiling service/*"
	cd $BUILD_DIR/$CORE_BASE_DIR/service
	javac */*.java
}

obfus=y
signjars=y

for args
do
   case $args in
   -o) echo "Not obfuscating"
		obfus=n
		;;
   -n) echo "Not signing jars"
		signjars=n
		;;
   -?) echo "\nUsage: buildcore [-s|-f] [-o] [-n] [-noutil] [-CTINT] [-CTIAIX] <cc...>"
		echo "        -o : don't obfuscate"
		echo "        -n : do NOT sign jars\n"
		exit 1
		;;
   esac
done

copy_util
copy_core
copy_tools
copy_install
create_resource
compile_util
compile_frontline_quick
compile_service_quick
compile_unref_dirs
compile_interface
compile_tools
compile_install
rmi
if [ "$obfus" = "y" ]
then
	obfuscate
fi
remove_java
make_jars
	
echo "Frontline build finished"

echo "*******************************"
echo "  Creating config directory    "
echo "*******************************"
cd $BUILD_DIR
if [ ! -d $BUILD_DIR/config ]
then
	mkdir config
fi
mv frontlinelocale.properties ./config

cd $CORE_ROOT_DIRECTORY/config/application
numSrcs=`ls -1 *.properties 2>/dev/null | wc -l`
if [ $numSrcs -gt 0 ]; then
	cp *.properties $BUILD_DIR/config/
fi
numSrcs=`ls -1 *.config 2>/dev/null | wc -l`
if [ $numSrcs -gt 0 ]; then
	cp *.config $BUILD_DIR/config/
fi

cd $CORE_ROOT_DIRECTORY/config/service
numSrcs=`ls -1 *.properties 2>/dev/null | wc -l`
if [ $numSrcs -gt 0 ]; then
	cp *.properties  $BUILD_DIR/config/
fi

cd $CORE_ROOT_DIRECTORY/config/agent
numSrcs=`ls -1 *.properties 2>/dev/null | wc -l`
if [ $numSrcs -gt 0 ]; then
	cp *.properties $BUILD_DIR/config
fi

cd $CORE_ROOT_DIRECTORY/config/c3
numSrcs=`ls -1 *.properties 2>/dev/null | wc -l`
if [ $numSrcs -gt 0 ]; then
	cp *.properties $BUILD_DIR/config
fi

echo "*******************************"
echo "  Creating startup directory   "
echo "*******************************"

cd $BUILD_DIR
mkdir -p $BUILD_DIR/startup/nt/client
mkdir -p $BUILD_DIR/startup/nt/server

mkdir -p $BUILD_DIR/startup/aix/client
mkdir -p $BUILD_DIR/startup/aix/server

cp -r $CORE_ROOT_DIRECTORY/startup/nt $BUILD_DIR/startup
cp -r $CORE_ROOT_DIRECTORY/startup/aix $BUILD_DIR/startup

echo "**********************************"
echo "  Creating db2 scripts hierarchy  "
echo "**********************************"

if [ -d $CORE_ROOT_DIRECTORY/code/db2 ]
then
	mkdir -p $BUILD_DIR/db2
	cp -r $CORE_ROOT_DIRECTORY/code/db2 $BUILD_DIR
fi

echo "*************************************"
echo "  Creating oracle scripts hierarchy  "
echo "*************************************"

if [ -d $CORE_ROOT_DIRECTORY/code/sql ]
then
	mkdir -p $BUILD_DIR/sql
	cp -r $CORE_ROOT_DIRECTORY/code/sql $BUILD_DIR
fi

echo "*************************************"
echo "  Creating mss scripts hierarchy  "
echo "*************************************"
if [ -d $CORE_ROOT_DIRECTORY/code/mss ]
then
	mkdir -p $BUILD_DIR/mss
	cp -r $CORE_ROOT_DIRECTORY/code/mss $BUILD_DIR
fi

echo "******************************************"
echo "Copying schema files to BUILD_DIR/schema"
echo "******************************************"

if [ -d $CORE_ROOT_DIRECTORY/config/schema ]
then
	mkdir -p $BUILD_DIR/schema
	cp -r $CORE_ROOT_DIRECTORY/config/schema $BUILD_DIR
fi

echo "*****************************************"
echo "Copying startup icon to BUILD_DIR/startup"
echo "*****************************************"

cd $CORE_CODE_DIR/$CORE_BASE_DIR/coreapplication
cp frontline.ico $BUILD_DIR/startup

echo "*******************************"
echo "  Creating licence directory   "
echo "*******************************"

cp -r $CORE_ROOT_DIRECTORY/licence $BUILD_DIR

echo "*****************************************"
echo "Copying policy file to BUILD_DIR/config"
echo "*****************************************"

cd $CORE_ROOT_DIRECTORY/config
cp policy $BUILD_DIR/config

echo "**************************************************"
echo "Copying core install, scripting and webstart files"
echo "**************************************************"

cp -r $CORE_ROOT_DIRECTORY/install $BUILD_DIR

cp -r $CORE_ROOT_DIRECTORY/scripting $BUILD_DIR

cp -r $CORE_ROOT_DIRECTORY/webstart $BUILD_DIR

cd $curpwd
