// Groovy backup script
import java.text.SimpleDateFormat;
import java.util.zip.ZipOutputStream;
import java.util.zip.ZipEntry;

def String nowDate() { simpleDateFormat.format(new Date()) }
def String nowDateTime() { nowDate() + " " + simpleTimeFormat.format(new Date()) }


//here is the code for the method 
def zipDir(String dir2zip, ZipOutputStream zos) 
{ 
    try 
	{ 
        //create a new File object based on the directory we have to zip File    
		File dir = new File(dir2zip); 
		dir.eachFile {
			if (it.isDirectory())
			{
    	        //if the File object is a directory, call this 
        	    //function again to add its content recursively 
	            zipDir(it.getAbsolutePath(), zos)
			}
			else
			{
		        byte[] readBuffer = new byte[2156]; 
		        int bytesIn = 0; 
		        //if we reached here, the File object f was not a directory 
		        //create a FileInputStream on top of f 
		        FileInputStream fis = new FileInputStream(it); 
		        //create a new zip entry 
		       	ZipEntry anEntry = new ZipEntry(it.getPath()); 
		        //place the zip entry in the ZipOutputStream object 
		        zos.putNextEntry(anEntry); 
		        //now write the content of the file to the ZipOutputStream 
		        while((bytesIn = fis.read(readBuffer)) != -1) 
		        { 
		        	zos.write(readBuffer, 0, bytesIn); 
		        } 
		        //close the Stream 
				fis.close(); 
			}
		}
	} 
	catch(Exception e) 
	{ 
	    //handle exception 
	    println "Exception:" + e.getMessage()
	    println e.printStackTrace()
	} 
}




SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat simpleTimeFormat = new SimpleDateFormat("HH:mm:ss");


String backupDate = nowDate();

String logFileName = "backup_${backupDate}.log"
println "logfileName=${logFileName}"

File logfile = new File("d:\\", logFileName);
println("file=" + logfile.getAbsolutePath());

println "Starting " + nowDateTime();


File bk_location= new File("h:\\", "/lagan/backup");
if (!bk_location.isDirectory())
{
	println "cannot find ${bk_location}"
	return;
}
println "Backup Location:" + bk_location.getAbsolutePath()

/*
 * backup my SVN repo
 */
String bk_name = "d:\\maigue_svnrepos.zip"
File bk_file = new File(bk_name)

String svnrepos = "d:\\svnrepos__"
File svnrepo = new File(svnrepos)

println "backing up svn"

try 
{ 
    //create a ZipOutputStream to zip the data to 
    println "Creating zip output"
    ZipOutputStream zos = new 
           ZipOutputStream(new FileOutputStream(bk_name)); 
    zos.setMethod(ZipOutputStream.DEFLATED);
    zipDir(svnrepos, zos); 
    //close the stream 
    zos.close();
} 
catch(Exception e) 
{ 
    //handle exception 
    println e.getMessage()
} 
// Create Zip file
//gzippedFiles = new java.io.File(svnrepos).listFiles().toList().sort()

//gzippedFiles = new java.io.File(svnrepos).listFiles().toList().findAll { it =~ "pdf" }.sort().reverse()
//files = []
//file = new File(svnrepos)
//file.eachFile { files << it }
//file.eachFile { if (it.name.endsWith(".desc")) files << it }

File zosFile = new File(bk_name)
println "Created zip, size:" + zosFile.length()
println "storing on h"
zosFile.renameTo(new File(bk_location, zosFile.getName()))


