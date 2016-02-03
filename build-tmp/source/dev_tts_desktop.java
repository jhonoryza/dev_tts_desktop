import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import g4p_controls.*; 
import java.net.*; 
import java.io.*; 
import java.awt.Font; 
import com.dhchoi.CountdownTimer; 
import com.dhchoi.CountdownTimerService; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class dev_tts_desktop extends PApplet {








AudioPlayer player;
Minim minim;
CountdownTimer timer;
String pathFile;
int position = 0;
GWindow windowText;
GPanel panel1;
GSlider slider1;

public void setup() 
{
  
  
  createGUI();
  customGUI();
}
public void draw() {
  background(240);
}
public void handleSliderEvents(GValueControl slider, GEvent event) { 
  panel1.moveTo(0, -slider.getValueI());
}
public void mouseWheel(MouseEvent event) {
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
  inputKorNum.setText("2");
}
public void createTextCreatorWindow() {
  if (inputKorNum.getText().matches("[0-9]+")) {
    createPanel();
  } else {
    createTextMessage("please input number of koridor", 5000);
  }
}
synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:723190:
  appc.background(230); 
  //println(data);
}
public void createPanel() {
  int totalKor = PApplet.parseInt(inputKorNum.getText());
  GLabel[] labelKor = new GLabel[totalKor];
  GLabel[] labelHalGo = new GLabel[totalKor];
  GLabel[] labelHalBack = new GLabel[totalKor];
  GTextArea[] areaHalGo = new GTextArea[totalKor];
  GTextArea[] areaHalBack = new GTextArea[totalKor];

  windowText = GWindow.getWindow(this, "Text Creator", 0, 0, 500, 500, JAVA2D);
  windowText.noLoop();
  windowText.setActionOnClose(G4P.CLOSE_WINDOW);
  windowText.addDrawHandler(this, "win_draw1");
  windowText.loop();

  panel1 = new GPanel(windowText, 0, 0, 480, totalKor*500, "Tab all koridor");
  panel1.setText("Tab bar text");
  panel1.setOpaque(false);

  slider1 = new GSlider(windowText, 500, 0, 500, 20, 10.0f);
  slider1.setRotation(PI/2, GControlMode.CORNER);
  slider1.setLimits(0.0f, 0.0f, totalKor*500);
  slider1.setNumberFormat(G4P.DECIMAL, 2);
  slider1.setOpaque(false);

  for (int i=0; i<totalKor; i++) {
    labelKor[i] = new GLabel(windowText, 0, 10+(i*500), 200, 50);
    labelKor[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
    labelKor[i].setText("Koridor " +(i+1));
    labelKor[i].setOpaque(false);

    labelHalGo[i] = new GLabel(windowText, 0, labelKor[i].getY()+20, 200, 50);
    labelHalGo[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
    labelHalGo[i].setText("input halte (berangkat)");
    labelHalGo[i].setOpaque(false);

    areaHalGo[i] = new GTextArea(windowText, 0, labelHalGo[i].getY()+20, 400, 200, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
    areaHalGo[i].setOpaque(false);

    labelHalBack[i] = new GLabel(windowText, 0, areaHalGo[i].getY()+20+areaHalGo[i].getHeight(), 200, 50);
    labelHalBack[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
    labelHalBack[i].setText("input halte (pulang)");
    labelHalBack[i].setOpaque(false);

    areaHalBack[i] = new GTextArea(windowText, 0, labelHalBack[i].getY()+20, 400, 200, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
    areaHalBack[i].setOpaque(false);

    panel1.addControl(labelKor[i]);
    panel1.addControl(labelHalGo[i]);
    panel1.addControl(labelHalBack[i]);
    panel1.addControl(areaHalGo[i]);
    panel1.addControl(areaHalBack[i]);
  }
}
public void playVoice() {
  String filename = inputSpeech.getText();
  String textVoice = filename.replace(" ", "%20");
  String u= "http://code.responsivevoice.org/getvoice.php?t=" +textVoice +"&tl=id&sv=&vn=&pitch=0.45&rate=0.5&vol=1";
  if (pathFile != null)
    saveToFile(u, filename);
  else {
    createTextMessage("please select a directory to put mp3 files", 5000);
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
public void folderSelected(File selection) {
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
      createTextMessage(" File " +filename +".mp3 created ", 5000);
    } 
    catch (IOException e) {
      e.printStackTrace();
      createTextMessage("network connection error", 30000);
    }
  } 
  catch (MalformedURLException e) {
    e.printStackTrace();
  }
}
public void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  println( "[tick] - timeLeft: " + timeLeftUntilFinish + "ms");
}

public void onFinishEvent(CountdownTimer t) {
  println( "[finished]");
  labelErrorMsg.setText("");
}
public void createTextMessage(String msg, int wait) {
  labelErrorMsg.setText(msg);
  timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, wait).start();
}
/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void inputSpeech_change(GTextField source, GEvent event) { //_CODE_:inputSpeech:624486:
  println("inputSpeech - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:inputSpeech:624486:

public void buttonPlay_click(GButton source, GEvent event) { //_CODE_:buttonPlay:757449:
  println("buttonPlay - GButton >> GEvent." + event + " @ " + millis());
  playVoice();
} //_CODE_:buttonPlay:757449:

public void inputKorNum_change(GTextField source, GEvent event) { //_CODE_:inputKorNum:981815:
  println("inputKorNum - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:inputKorNum:981815:

public void buttonCreate_click(GButton source, GEvent event) { //_CODE_:buttonCreate:884548:
  println("buttonCreate - GButton >> GEvent." + event + " @ " + millis());
  createTextCreatorWindow();
} //_CODE_:buttonCreate:884548:

public void buttonDir_click(GButton source, GEvent event) { //_CODE_:buttonDir:751435:
  println("buttonDir - GButton >> GEvent." + event + " @ " + millis());
  selectFolder();
} //_CODE_:buttonDir:751435:

public void inputPitch_change(GTextField source, GEvent event) { //_CODE_:inputPitch:683113:
  println("inputPitch - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:inputPitch:683113:

public void inputRate_change(GTextField source, GEvent event) { //_CODE_:inputRate:979273:
  println("inputRate - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:inputRate:979273:

public void inputVolume_change(GTextField source, GEvent event) { //_CODE_:inputVolume:633250:
  println("inputVolume - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:inputVolume:633250:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.ORANGE_SCHEME);
  G4P.setCursor(HAND);
  surface.setTitle("Sketch Window");
  labelTitle = new GLabel(this, 10, 10, 100, 20);
  labelTitle.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelTitle.setText("config apps");
  labelTitle.setOpaque(false);
  labelTts = new GLabel(this, 10, 40, 80, 20);
  labelTts.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelTts.setText("input text");
  labelTts.setOpaque(false);
  inputSpeech = new GTextField(this, 130, 40, 160, 20, G4P.SCROLLBARS_NONE);
  inputSpeech.setPromptText("input text here");
  inputSpeech.setOpaque(true);
  inputSpeech.addEventHandler(this, "inputSpeech_change");
  buttonPlay = new GButton(this, 310, 40, 90, 20);
  buttonPlay.setText("play");
  buttonPlay.addEventHandler(this, "buttonPlay_click");
  labelKorNum = new GLabel(this, 10, 100, 110, 20);
  labelKorNum.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelKorNum.setText("input jumlah koridor");
  labelKorNum.setOpaque(false);
  inputKorNum = new GTextField(this, 130, 100, 160, 20, G4P.SCROLLBARS_NONE);
  inputKorNum.setPromptText("input number here");
  inputKorNum.setOpaque(true);
  inputKorNum.addEventHandler(this, "inputKorNum_change");
  buttonCreate = new GButton(this, 310, 100, 90, 20);
  buttonCreate.setText("create");
  buttonCreate.addEventHandler(this, "buttonCreate_click");
  labelDir = new GLabel(this, 10, 70, 110, 20);
  labelDir.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelDir.setText("save file mp3 to");
  labelDir.setOpaque(false);
  buttonDir = new GButton(this, 310, 70, 90, 20);
  buttonDir.setText("select directory");
  buttonDir.addEventHandler(this, "buttonDir_click");
  labelDirPath = new GLabel(this, 410, 70, 390, 50);
  labelDirPath.setTextAlign(GAlign.LEFT, GAlign.TOP);
  labelDirPath.setText("not selected");
  labelDirPath.setOpaque(false);
  labelErrorMsg = new GLabel(this, 360, 10, 280, 20);
  labelErrorMsg.setLocalColorScheme(GCScheme.RED_SCHEME);
  labelErrorMsg.setOpaque(false);
  labelPitch = new GLabel(this, 410, 40, 80, 20);
  labelPitch.setText("pitch");
  labelPitch.setOpaque(false);
  inputPitch = new GTextField(this, 480, 40, 60, 20, G4P.SCROLLBARS_NONE);
  inputPitch.setText("0.5");
  inputPitch.setOpaque(true);
  inputPitch.addEventHandler(this, "inputPitch_change");
  labelRate = new GLabel(this, 530, 40, 80, 20);
  labelRate.setText("rate");
  labelRate.setOpaque(false);
  inputRate = new GTextField(this, 590, 40, 60, 20, G4P.SCROLLBARS_NONE);
  inputRate.setText("0.5");
  inputRate.setOpaque(true);
  inputRate.addEventHandler(this, "inputRate_change");
  labelVolume = new GLabel(this, 640, 40, 80, 20);
  labelVolume.setText("volume");
  labelVolume.setOpaque(false);
  inputVolume = new GTextField(this, 710, 40, 60, 20, G4P.SCROLLBARS_NONE);
  inputVolume.setText("1");
  inputVolume.setOpaque(true);
  inputVolume.addEventHandler(this, "inputVolume_change");
}

// Variable declarations 
// autogenerated do not edit
GLabel labelTitle; 
GLabel labelTts; 
GTextField inputSpeech; 
GButton buttonPlay; 
GLabel labelKorNum; 
GTextField inputKorNum; 
GButton buttonCreate; 
GLabel labelDir; 
GButton buttonDir; 
GLabel labelDirPath; 
GLabel labelErrorMsg; 
GLabel labelPitch; 
GTextField inputPitch; 
GLabel labelRate; 
GTextField inputRate; 
GLabel labelVolume; 
GTextField inputVolume; 
  public void settings() {  size(800, 150, JAVA2D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "dev_tts_desktop" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
