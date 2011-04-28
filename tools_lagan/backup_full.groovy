// Groovy backup script
import java.text.SimpleDateFormat;

def String nowDate() { simpleDateFormat.format(new Date()) }
def String nowDateTime() { nowDate() + " " + simpleTimeFormat.format(new Date()) }

SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat simpleTimeFormat = new SimpleDateFormat("HH:mm:ss");


println("yyyy-MM-dd=" + nowDate());

File logfile=new File("/", "backup_$backupDate" + ".log");
println("file=" + logfile.getAbsolutePath());

println "Starting " + nowDateTime();

/***
bk_location=/h/lagan/backup
if [ ! -d $bk_location ]; then
	println cannot find $bk_location
	println cannot find $bk_location >> $logfile
fi

#################################
# backup my SVN repo
#################################
bk_name=/d/maigue_svnrepos.tar.gz
cd /d/svnrepos
println backing up svn
println backing up svn >> $logfile
tar -czvf $bk_name *
println storing on h
ls -l $bk_name >> $logfile
println storing on h >> $logfile
mv $bk_name $bk_location


#################################
# backup my documents
#################################
bk_name=/d/maigue_mydocuments.tar.gz
bk_lst=/d/maigue_mydocuments.lst
cd /d/Personal/My\ Documents
println backing up my documents
println backing up my documents >> $logfile
find . -type f -not \( -name "*~" -or -wholename "* /My\ Music/*" -or -wholename "* /Sports\ Interactive/*" \) -print > $bk_lst
println creating tar file
println creating tar file >> $logfile
tar -czvf $bk_name --files-from $bk_lst
println storing on h
ls -l $bk_name >> $logfile
println storing on h >> $logfile
mv $bk_name $bk_location



#################################
# backup local code
#################################
bk_name=/d/maigue_code.tar.gz
bk_lst=/d/backup.lst
println backing up code
println backing up code >> $logfile

# tidyup where available
println tidyup
println tidyup >> $logfile
cd /d/projects/frontline/5-1-2-dev/sourcedev
ant -f buildsvn.xml clean


cd /d/projects
#tar cvf /d/maigue_code.tar `find . -type f -not \( -name "*.exe" -or -name "*.class" -or -name "*.jar" -or -name "*.zip" -or -wholename "*\.svn*" -or -name "*\.log*" -or -wholename "*sourcebuild*" -or -wholename "*frontlinebuild*" -or -wholename "*frontlinecd*" -or -wholename "*/bin/*" -or -wholename "*/svnroot/external/*" -or -wholename "*/.metadata/*" \) -print`

println generating backup list
println generating backup list >> $logfile
find . -type f -not \( -name "*.exe" -or -name "*.dll" -or -name "*.class" -or -name "*.jar" -or -name "*.zip" -or -wholename "*\.svn*" -or -name "*\.log*" -or -wholename "*sourcebuild*" -or -wholename "*frontlinebuild*" -or -wholename "*frontlinecd*" -or -wholename "* /bin/*" -or -wholename "* /svnroot/external/*" -or -wholename "* /.metadata/*" \) -print > $bk_lst
println creating tar file
println creating tar file >> $logfile
tar -czvf $bk_name --files-from $bk_lst
println storing on h
ls -l $bk_name >> $logfile
println storing on h >> $logfile
mv $bk_name $bk_location


println done `date` >> $logfile
***/