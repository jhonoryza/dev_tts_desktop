import java.net.*;
import java.io.*;

public void setup() 
{
 String textVoice = "selamat datang di kota bandung provinsi jawa barat";
 textVoice = textVoice.replace(" ","%20");
 String u= "http://code.responsivevoice.org/getvoice.php?t=" +textVoice +"&tl=id&sv=&vn=&pitch=0.45&rate=0.5&vol=1";
// saveToFile(u);
}
public void saveToFile(String u){
 try {
     URL url = new URL(u);
     try {
       URLConnection connection = url.openConnection();
       // pose as webbrowser
       connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 1.2.30703)");
       connection.connect();
       InputStream is = connection.getInputStream();
       // create a file named after the text
       File f = new File("/tmp/mee.mp3");
       OutputStream out = new FileOutputStream(f);
       byte buf[] = new byte[1024];
       int len;
       while ((len = is.read(buf)) > 0) {
         out.write(buf, 0, len);
         print(buf);
       }
       out.close();
       is.close();
       println("File created for: mee.mp3"); // report back via the console
     } catch (IOException e) {
       e.printStackTrace();
     }
  } catch (MalformedURLException e) {
   e.printStackTrace();
  } 
}