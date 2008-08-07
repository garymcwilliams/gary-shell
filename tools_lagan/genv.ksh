#===============================================================
#
# Envrionment script for Building Frontline Sources
#
# Source:		L:/RCS/lagancentre/build/frontline/buildscripts/env.ksh
# Version:		1.18
# Author(s):	Andrew Irvine
#         
# Script to set up environment for building Frontline sources.
#         
#===============================================================

echo "**************************"
echo "Frontline Build Parameters"
echo "**************************"

#
# Change the following variables for your machine:
# (NOTE: you can override most of these by using the MY_... version of the
#   variable, to save having to modify the script)
# (1) where all the special 3rd-party jars are, like Sax and db2java.
# (2) where you want things to be built out to.
# (3) where you want the cd structure to be built.
# (4) where Java 1.3 is.
# (5) where your Windows system directory is.
# (6) where you've installed Jshrink.
# (7) the root directory of the soucrce files for the release
# (8) running using MKS Toolkit or CygWin
# (9) where Java Web service toolkit JAX-RPC deploy tools are
# (10) where JRE 1.4 or above is (for web service tool)

export EXTRA_LIBS=${MY_EXTRA_LIBS:-"D:/frontlinebuild/lib"}
export BUILD_DIR=${MY_BUILD_DIR:-"D:/frontlinebuild"}
export CD_DIR=${MY_CD_DIR:-"D:/frontlinecd"}
export JDK_DIR=${MY_JDK_DIR:-"D:/jdk1.3"}
export WIN_PATH=${MY_WIN_PATH:-"C:/winnt/system32"}
export SHRINK_DIR=L:/Projects/lagancentre/Jshrink
export ROOT_DIR=${MY_ROOT_DIR:-"D:"}
export SHELL_TYPE=${LAGAN_SHELL_TYPE:-"MKs"}
export WSDP_DIR=${MY_WSDP_DIR:-"L:/Projects/lagancentre/wsdp-1_0_01"}
export JRE4_DIR=${MY_JRE4_DIR:-"D:/j2sdk1.4.0/jre"}

#
# There should be no need to change any of these.
#
export CORE_BASE_DIR=com/lagan/lagancentre/core
export CORE_UTIL_BASE_DIR=com/lagan/lagancentre/util
export UTIL_BASE_DIR=com/lagan

export CORE_CODE_DIR=$ROOT_DIR/projects/lagancentre/code
export UTIL_CODE_DIR=$ROOT_DIR/projects/laganutil/code
export CORE_ROOT_DIRECTORY=$ROOT_DIR/projects/lagancentre

extrajars="
calpahtml.jar
mail.jar
Sax.jar
Xp.jar
Xt.jar
activation.jar
db2java.zip
classes12.zip
ice_all.jar
calpa_all.jar
smpp.jar
JGo.jar
JGoLayout.jar
JimiProClasses.zip
dom.jar
jaxp-api.jar
xercesImpl.jar
xalan.jar
xsltc.jar
QWinJavaRemoteAPI.jar
juh.jar
jurt.jar
ridl.jar
unoil.jar
j2ee.jar
msbase.jar
msutil.jar
mssqlserver.jar
saaj-api.jar
saaj-ri.jar
commons-logging.jar
dom4j.jar
soap.jar
standard.jar
jstl.jar
exolabcore-0.3.5.jar
openjms-0.7.5.jar
c-rt.tld
c.tld
fmt-rt.tld
fmt.tld
sql-rt.tld
sql.tld
x-rt.tld
x.tld
"

if [ ${SHELL_TYPE} = "CYGWIN_BASH" ]
then
	# ensure paths used for WINDOWS javac are in WINDOWS format
	BUILD_DIR=`cygpath --mixed $BUILD_DIR`
	EXTRA_LIBS=`cygpath --mixed $EXTRA_LIBS`
fi

extralist=""
for j in $extrajars
do
  extralist="${extralist};${EXTRA_LIBS}/${j}"
done


export CLASSPATH="$BUILD_DIR;$extralist"

if [ ${SHELL_TYPE} = "CYGWIN_BASH" ]
then
  #cygwin: need : instead of ;
  export PATH="$JDK_DIR/bin:/bin:$WIN_PATH"
  echo "Using CYGWIN shell"
else
  export PATH="$JDK_DIR/bin;$ROOTDIR/mksnt;$WIN_PATH"
fi

export PORTAL_BASE_DIR=com/lagan/lagancentre/core/thinclient
export PORTAL_DEPLOY_DIR=deploy_portal
export CWP_DEPLOY_DIR=deploy_cwp
export PORTAL_CLASSPATH="$CLASSPATH;$EXTRA_LIBS/j2ee.jar;$BUILD_DIR/Application.jar;$BUILD_DIR/Interface.jar;$BUILD_DIR/Service.jar;$BUILD_DIR/Util.jar"

export JSP_REPORTS_BASE_DIR=jsp/reports
export JSP_REPORTS_BEAN_DIR=com/lagan/lagancentre/core/bean
export JSP_REPORTS_DEPLOY_DIR=deploy_reports

export CRYSTAL_REPORTS_BASE_DIR=Reports/crystal

echo "CORE_CODE_DIR:  $CORE_CODE_DIR"
echo "UTIL_CODE_DIR:  $UTIL_CODE_DIR"
echo "BUILD_DIR:  $BUILD_DIR"
echo "PORTAL_BASE_DIR:  $PORTAL_BASE_DIR"
echo "PORTAL_DEPLOY_DIR:  $PORTAL_DEPLOY_DIR"
echo "CWP_DEPLOY_DIR:  $CWP_DEPLOY_DIR"
echo "PORTAL_CLASSPATH:  $PORTAL_CLASSPATH"
echo "JSP_REPORTS_BASE_DIR:  $JSP_REPORTS_BASE_DIR"
echo "JSP_REPORTS_BEAN_DIR:  $JSP_REPORTS_BEAN_DIR"
echo "JSP_REPORTS_DEPLOY_DIR:  $JSP_REPORTS_DEPLOY_DIR"
echo "CRYSTAL_REPORTS_BASE_DIR:  $CRYSTAL_REPORTS_BASE_DIR"
echo "CLASSPATH:  $CLASSPATH"
echo "PATH:  $PATH"
