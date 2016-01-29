import g4p_controls.*;
import java.net.*;
import java.io.*;
import java.awt.Font;
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
CountdownTimer timer;
String pathFile;
int position = 0;
public void setup() 
{
  smooth();
  size(900, 500, JAVA2D);
  createGUI();
  customGUI();
}
public void draw() {
  background(240);
  //translate(0, position);
  panel2.moveTo(0,slider2.getValueF()); 
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e >0) {
    position += 3;
  } else if (e <0) {
    position -= 3;
  }
  println(e);
}
public void customGUI() {
  Font fontHeader = new Font("droid", Font.PLAIN, 16);
  //Font fontLabel = new Font("droid", Font.PLAIN, 16);
  labelTitle.setFont(fontHeader);
  //labelTts.setFont(fontLabel);
}
public void playVoice() {
  String filename = inputSpeech.getText();
  String textVoice = filename.replace(" ", "%20");
  String u= "http://code.responsivevoice.org/getvoice.php?t=" +textVoice +"&tl=id&sv=&vn=&pitch=0.45&rate=0.5&vol=1";
  if (pathFile != null)
    saveToFile(u, filename);
  else {
    labelErrorMsg.setText("please select a directory to put mp3 files");
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 5000).start();
  }
}
public void selectFolder() {
  String name = G4P.selectFolder("Folder Dialog");
  if (name != null) {
    labelDirPath.setText(name);
    pathFile = name;
  }
  //selectFolder("Select a folder to process:", "folderSelected");
}
void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    labelDirPath.setText(selection.getAbsolutePath());
    println("User selected " + selection.getAbsolutePath());
  }
}
public void saveToFile(String u, String filename) {
  try {
    URL url = new URL(u);
    try {
      URLConnection connection = url.openConnection();
      // pose as webbrowser
      connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 1.2.30703)");
      connection.connect();
      InputStream is = connection.getInputStream();
      // create a file named after the text
      File f = new File(pathFile +"/" +filename +".mp3");
      OutputStream out = new FileOutputStream(f);
      byte buf[] = new byte[1024];
      int len;
      while ((len = is.read(buf)) > 0) {
        out.write(buf, 0, len);
        print(buf);
      }
      out.close();
      is.close();
      println(" File " +filename +".mp3 created "); // report back via the console
    } 
    catch (IOException e) {
      e.printStackTrace();
      labelErrorMsg.setText("network connection error");
      timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 30000).start();
    }
  } 
  catch (MalformedURLException e) {
    e.printStackTrace();
  }
}
void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  println( "[tick] - timeLeft: " + timeLeftUntilFinish + "ms");
}

void onFinishEvent(CountdownTimer t) {
  println( "[finished]");
  labelErrorMsg.setText("");
}