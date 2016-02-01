import g4p_controls.*;
import java.net.*;
import java.io.*;
import java.awt.Font;
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
import ddf.minim.*;
AudioPlayer player;
Minim minim;
CountdownTimer timer;
String pathFile, pathFileText;
int position = 0;
GWindow windowText;
GPanel panel1;
GSlider slider1;
public boolean inputChange = true;
public void setup() 
{
  smooth();
  size(800, 150, JAVA2D);
  createGUI();
  customGUI();
}
public void draw() {
  background(240);
}
public void handleSliderEvents(GValueControl slider, GEvent event) { 
  panel1.moveTo(panel1.getX(), -slider.getValueI());
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
  appc.background(240); 
  //println(data);
}
GTextArea[] areaHalGo;
GTextArea[] areaHalBack;
public void createPanel() {
  int totalKor = int(inputKorNum.getText());
  GLabel[] labelKor = new GLabel[totalKor];
  GLabel[] labelHalGo = new GLabel[totalKor];
  GLabel[] labelHalBack = new GLabel[totalKor];
  areaHalGo = new GTextArea[totalKor];
  areaHalBack = new GTextArea[totalKor];


  windowText = GWindow.getWindow(this, "Text Creator", 20, 20, 1000, 500, JAVA2D);
  windowText.noLoop();
  windowText.setActionOnClose(G4P.CLOSE_WINDOW);
  windowText.addDrawHandler(this, "win_draw1");

  panel1 = new GPanel(windowText, 10, 0, 480, totalKor*140, "Tab all koridor");
  panel1.setText("Tab bar text");
  panel1.setOpaque(false);

  slider1 = new GSlider(windowText, 990, 20, 460, 20, 10.0);
  slider1.setRotation(PI/2, GControlMode.CORNER);
  slider1.setLimits(0.0, 0.0, totalKor*140);
  slider1.setNumberFormat(G4P.DECIMAL, 2);
  slider1.setOpaque(false);

  for (int i=0; i<totalKor; i++) {
    labelKor[i] = new GLabel(windowText, 0, 10+(i*140), 200, 50);
    labelKor[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
    labelKor[i].setText("Koridor " +(i+1));
    labelKor[i].setOpaque(false);

    labelHalGo[i] = new GLabel(windowText, 0, labelKor[i].getY()+20, 200, 50);
    labelHalGo[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
    labelHalGo[i].setText("input halte (berangkat)");
    labelHalGo[i].setOpaque(false);

    areaHalGo[i] = new GTextArea(windowText, 0, labelHalGo[i].getY()+20, 450, 100, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
    areaHalGo[i].setOpaque(false);

    labelHalBack[i] = new GLabel(windowText, areaHalGo[i].getX()+20+areaHalGo[i].getWidth(), labelHalGo[i].getY(), 200, 50);
    labelHalBack[i].setTextAlign(GAlign.LEFT, GAlign.TOP);
    labelHalBack[i].setText("input halte (pulang)");
    labelHalBack[i].setOpaque(false);

    areaHalBack[i] = new GTextArea(windowText, areaHalGo[i].getX()+20+areaHalGo[i].getWidth(), labelHalBack[i].getY()+20, 450, 100, G4P.SCROLLBARS_VERTICAL_ONLY | G4P.SCROLLBARS_AUTOHIDE);
    areaHalBack[i].setOpaque(false);

    panel1.addControl(labelKor[i]);
    panel1.addControl(labelHalGo[i]);
    panel1.addControl(labelHalBack[i]);
    panel1.addControl(areaHalGo[i]);
    panel1.addControl(areaHalBack[i]);
  }
  GButton buttonSaveTextDir = new GButton(windowText, 700, panel1.getHeight()+100, 90, 40);
  buttonSaveTextDir.setText("choose directory");
  buttonSaveTextDir.addEventHandler(this, "buttonSaveTextDir_click");
  GButton buttonSaveText = new GButton(windowText, 800, panel1.getHeight()+100, 90, 40);
  buttonSaveText.setText("save to text file");
  buttonSaveText.addEventHandler(this, "buttonSaveText_click");

  panel1.addControl(buttonSaveText);
  panel1.addControl(buttonSaveTextDir);
  windowText.loop();
}
public void buttonSaveText_click(GButton source, GEvent event) { 
  println("save");
  String[] aa = new String[areaHalGo.length];
  aa = areaHalGo[0].getTextAsArray();
  PrintWriter output;
  String temp = pathFileText+"\\"+"ko.txt";
  output = createWriter(temp);
  output.println(aa);
  println(aa);
  output.flush(); 
  output.close(); 
} 
public void buttonSaveTextDir_click(GButton source, GEvent event) { 
  println("dir");
  String name = G4P.selectFolder("Folder Dialog");
  if (name != null) {
    pathFileText = name;
  }
} 
public void playVoice() {
  String filename = inputSpeech.getText();
  String textVoice = filename.replace(" ", "%20");
  String u= "http://code.responsivevoice.org/getvoice.php?t=" +textVoice +"&tl=id&sv=&vn=&pitch=0.45&rate=0.5&vol=1";
  if (pathFile != null) {
    if (inputChange) {
      saveToFile(u, filename);
    } else if (!inputChange) {
      byte b[] = loadBytes(pathFile +"/" +filename +".mp3"); 
      if (b != null) {
        println("success");
        playFile(filename, pathFile);
      } else if (b == null) {
        println("failed");
        saveToFile(u, filename);
      }
    }
  } else {
    createTextMessage("please select a directory to put mp3 files", 5000);
  }
} 
public void selectFolder() {
  String name = G4P.selectFolder("Folder Dialog");
  if (name != null) {
    labelDirPath.setText("save mp3 files to: " +name);
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
      inputChange = false;
      println(" File " +filename +".mp3 created "); // report back via the console
      createTextMessage(" File " +filename +".mp3 created ", 5000);
      playFile(filename, pathFile);
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
void playFile(String filename, String pathFile) {
  if (player != null) {
    player.close();
  } // comment this line to layer sounds
  minim = new Minim(this);
  player = minim.loadFile(pathFile +"/" +filename + ".mp3");
  player.play();
}
void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  //println( "[tick] - timeLeft: " + timeLeftUntilFinish + "ms");
}

void onFinishEvent(CountdownTimer t) {
  //println( "[finished]");
  labelErrorMsg.setText("");
}
public void createTextMessage(String msg, int wait) {
  labelErrorMsg.setText(msg);
  timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, wait).start();
}