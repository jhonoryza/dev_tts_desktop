import g4p_controls.*;
import java.net.*;
import java.io.*;
import java.awt.Font;
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
CountdownTimer timer;
String pathFile;
int position = 0;
GWindow windowText;
GPanel panel1;
GSlider slider1;
 
public void setup() 
{
  smooth();
  size(800, 150, JAVA2D);
  createGUI();
  customGUI();
}
public void draw() {
  background(240);
  if(windowText != null)
  panel1.moveTo(0, slider1.getValueF());
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
  labelTitle.setFont(fontHeader);
  inputSpeech.setText("selamat datang");
  inputKorNum.setText("1");
}
public void createTextCreatorWindow() {
  if (inputKorNum.getText().matches("[0-9]+")) {
    createPanel();
  } else {
    labelErrorMsg.setText("please input number of koridor");
    timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, 5000).start();
  }
}
synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:723190:
  appc.background(230); 
  //println(data);
  
}
public void createPanel() {
  windowText = GWindow.getWindow(this, "Text Creator", 0, 0, 900, 500, JAVA2D);
  windowText.noLoop();
  windowText.setActionOnClose(G4P.CLOSE_WINDOW);
  windowText.addDrawHandler(this, "win_draw1");
  windowText.loop();

  panel1 = new GPanel(windowText, 0, 0, 880, 500, "Tab all koridor");
  panel1.setText("Tab bar text");
  panel1.setOpaque(false);

  slider1 = new GSlider(windowText, 900, 0, 500, 20, 10.0);
  slider1.setRotation(PI/2, GControlMode.CORNER);
  slider1.setLimits(0.0, 0.0, 500.0);
  slider1.setNumberFormat(G4P.DECIMAL, 2);
  slider1.setOpaque(false);

  int totalKor = int(inputKorNum.getText());
  GLabel[] labelKor = new GLabel[totalKor];
  for (int i=0; i<totalKor; i++) {
    labelKor[i] = new GLabel(windowText, 0, 10+(i*50), 390, 50);
    labelKor[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
    labelKor[i].setText("Koridor " +(i+1));
    labelKor[i].setOpaque(false);
    panel1.addControl(labelKor[i]);
  }
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