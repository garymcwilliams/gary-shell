import groovy.xml.MarkupBuilder
import java.io.StringWriter
import java.io.File
import org.blinkenlights.jid3.MediaFile;
import org.blinkenlights.jid3.MP3File;
import org.blinkenlights.jid3.ID3Exception;
import org.blinkenlights.jid3.v1.ID3V1Tag;
import org.blinkenlights.jid3.v2.ID3V2Tag;
import org.blinkenlights.jid3.v2.TRCKTextInformationID3V2Frame;



public class Song
{
	private static final String UNKNOWN = "<unknown>"
		
	@Property String artist
	@Property String album
	@Property String title
	@Property int trackNumber
	
	public Song(File aFile)
	{
		println "file:" + aFile.getAbsolutePath()
		MediaFile mediaFile
		mediaFile = new MP3File(aFile)
		
		boolean gotV2 = false
		boolean gotV1 = false
		mediaFile.tags.each {
            if (it instanceof ID3V2Tag)
            {
            	gotV2 = true
            }
            if (it instanceof ID3V1Tag)
            {
            	gotV1 = true
            }
        }
		
		if (gotV2)
		{
			ID3V2Tag tag = mediaFile.getID3V2Tag()
			artist = checkUnknown(tag.artist)
			album = checkUnknown(tag.album)
			title = checkUnknown(tag.title)
			TRCKTextInformationID3V2Frame trck = tag.getTRCKTextInformationFrame()
			if ( trck != null)
			{
				trackNumber = tag.trackNumber
			}
			else
			{
				trackNumber = 0
			}
		}
		else if (gotV1)
		{
			ID3V1Tag tag = mediaFile.getID3V1Tag()
			artist = checkUnknown(tag.artist)
			album = checkUnknown(tag.album)
			title = checkUnknown(tag.title)
			trackNumber = tag.trackNumber
		}
	}
	
	private String checkUnknown(String aValue)
	{
		if (aValue == null || aValue == "")
		{
			return UNKNOWN
		}
		return aValue
	}
}

writer = new StringWriter()	 	
builder = new MarkupBuilder(writer)

def songs = []

["//glenree/music", "//loughmuck/My Folder/music", "//anascaul/music"].each {
	File ff = new File(it)
	listAlbums(ff)
}


def listAlbums(File it)
{
//	musicFiles = it.listFiles().toList().findAll { it =~ "mp3" }.each {
//		mySong = new Song(it)
//		println "HI"
//		songs << mySong
//	}
	it.eachFile {
		if (it.isDirectory()) {
			println "dir:" + it
			musicFiles = it.listFiles().toList().findAll { it =~ "mp3" }.each {
				println "file:" + it
				try {
					println "creating Song"
					mySong = new Song(it)
					songs << mySong
				} catch (Exception e) {
					println "Unable to process " + it.name + ":-" + e.message
				}
			}
			listAlbums(it)
		}
	}
}

// no need of course to close the writer, 
// since it's gracefully taken care of by the method
new File("d:\\tracks.txt").withWriterAppend("UTF-8") { filewriter |
	songs.each {
		filewriter.writeLine it.artist + " - " + it.album + " - " + it.title
	}
}
Set albums = new TreeSet()
songs.each {
	albums.add(it.artist + "/" + it.album)
}

new File("d:\\albums.txt").withWriterAppend("UTF-8") { filewriter |
	albums.each {
		filewriter.writeLine it
	}
}

/* **
   new File("dboutput.xml").withPrintWriter{ pwriter |
      pwriter.println writer.toString()
   }
** */
