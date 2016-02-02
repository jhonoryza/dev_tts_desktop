import g4p_controls.*;
import java.net.*;
import java.io.*;
import java.awt.Font;
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
import ddf.minim.*;
//global variable
AudioPlayer player;
Minim minim;
CountdownTimer timer, timerW2, timerW3;
String pathFile, pathFileText, pathFileMp3;
int position = 0;
public boolean inputChange = true;
public boolean playfile = false;
public void setup() 
{
  smooth();
  size(800, 180, JAVA2D);
  createGUI();
  customGUI();
}
public void draw() {
  background(240);
}
public void customGUI() {
  Font fontHeader = new Font("source code pro", Font.BOLD, 16);
  labelTitle.setFont(fontHeader);
  inputSpeech.setText("selamat datang");
  inputKorNum.setText("2");
  labelDirPath.setText("path: " +pathFile);
}
//Function Handlers
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
public void createTextCreatorWindow(int total) {
  if (inputKorNum.getText().matches("[0-9]+")) {
    createPanel(total);
  } else {
    createTextMessage("please input number of koridor", 5000);
  }
}

GTextArea[] areaHalGo, areaHalBack;
GLabel[] labelKor, labelHalGo, labelHalBack;
GLabel labelMsg, labelErrorMsgText, labelMp3Msg, labelErrorMsgMp3;
GWindow windowText;
GPanel panel1;
GSlider slider1;
int totalKor;
public void createPanel(int total) {
  totalKor = total;
  labelKor = new GLabel[totalKor];
  labelHalGo = new GLabel[totalKor];
  labelHalBack = new GLabel[totalKor];
  areaHalGo = new GTextArea[totalKor];
  areaHalBack = new GTextArea[totalKor];

  windowText = GWindow.getWindow(this, "Text Creator", 20, 20, 1000, 500, JAVA2D);
  windowText.noLoop();
  windowText.setActionOnClose(G4P.CLOSE_WINDOW);
  windowText.addDrawHandler(this, "win_draw1");

  panel1 = new GPanel(windowText, 10, 0, 900, 10+totalKor*140, "Tab all koridor");
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
  GButton buttonSaveTextDir = new GButton(windowText, 0, panel1.getHeight()+20, 90, 40);
  buttonSaveTextDir.setText("choose text directory");
  buttonSaveTextDir.addEventHandler(this, "buttonSaveTextDir_click");
  GButton buttonSaveText = new GButton(windowText, 100, panel1.getHeight()+20, 90, 40);
  buttonSaveText.setText("save config to text file");
  buttonSaveText.addEventHandler(this, "buttonSaveText_click");
  labelMsg = new GLabel(windowText, 0, panel1.getHeight()+60, 500, 40);
  labelMsg.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelMsg.setText("path: " +pathFileText);
  labelMsg.setOpaque(false);
  labelErrorMsgText = new GLabel(windowText, buttonSaveText.getWidth()+buttonSaveText.getX()+20, panel1.getHeight()+20, 400, 40);
  labelErrorMsgText.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelErrorMsgText.setOpaque(false);

  panel1.addControl(buttonSaveText);
  panel1.addControl(buttonSaveTextDir);
  panel1.addControl(labelMsg);
  panel1.addControl(labelErrorMsgText);

  GButton buttonSaveMp3Dir = new GButton(windowText, 0, labelMsg.getHeight()+10+labelMsg.getY(), 90, 40);
  buttonSaveMp3Dir.setText("choose mp3 directory");
  buttonSaveMp3Dir.addEventHandler(this, "buttonSaveMp3Dir_click");
  GButton buttonSaveMp3 = new GButton(windowText, 100, labelMsg.getHeight()+10+labelMsg.getY(), 90, 40);
  buttonSaveMp3.setText("create mp3 file");
  //StyledString gold = new StyledString("create mp3 file");
  //gold.addAttribute(G4P.FOREGROUND,color(255,255,255)); 
  //buttonSaveMp3.setStyledText(gold);
  buttonSaveMp3.addEventHandler(this, "buttonSaveMp3_click");
  labelErrorMsgMp3 = new GLabel(windowText, buttonSaveText.getWidth()+buttonSaveText.getX()+20, labelMsg.getHeight()+10+labelMsg.getY(), 400, 40);
  labelErrorMsgMp3.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelErrorMsgMp3.setOpaque(false);
  labelMp3Msg = new GLabel(windowText, 0, buttonSaveMp3Dir.getHeight()+buttonSaveMp3Dir.getY(), 500, 40);
  labelMp3Msg.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelMp3Msg.setText("path: " +pathFileMp3);
  labelMp3Msg.setOpaque(false);


  panel1.addControl(buttonSaveMp3);
  panel1.addControl(buttonSaveMp3Dir);
  panel1.addControl(labelMp3Msg);
  panel1.addControl(labelErrorMsgMp3);

  windowText.loop();
}
public void loadConfiguration() {
  String nameFile = G4P.selectInput("select configfiles.txt");
  println(nameFile);
  String path = nameFile.replace("configfiles.txt", "");
  path.trim();
  String lines[] = loadStrings(nameFile);
  println("there are " + lines.length + " lines");
  createTextCreatorWindow(lines.length);
  for (int i = 0; i < lines.length; i++) {
    println(lines[i]);
    String[] list = split(lines[i], ',');
    for (int j=0; j<list.length; j++) {
      String[] koridorFiles = loadStrings(path +"\\" +list[j]);
      loadFilesToArea(koridorFiles, j, i);
    }
  }
}
void loadFilesToArea(String[] text, int index, int subindex) {
  if (index == 0) {
    areaHalGo[subindex].setText(text);
  } else {
    areaHalBack[subindex].setText(text);
  }
}
public void playVoice() {
  playfile = true;
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
      if (playfile)
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
  playfile = false;
}
public void selectFolder() {
  String name = G4P.selectFolder("Folder Dialog");
  if (name != null) {
    labelDirPath.setText("path: " +name);
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
public void createMp3Files() {

  for (int i=0; i<totalKor; i++) {
    String text =  areaHalGo[i].getText();
    String[] list = split(text, ' ');
    for (int j=0; j<list.length; j++)
      list[j].trim();
    println(list);
  }

  //String filename = inputSpeech.getText();
  //String textVoice = filename.replace(" ", "%20");
  //String u= "http://code.responsivevoice.org/getvoice.php?t=" +textVoice +"&tl=id&sv=&vn=&pitch=0.45&rate=0.5&vol=1"; 
  //saveToFile(u, filename);
}
//Window Handlers
synchronized public void win_draw1(PApplet appc, GWinData data) {
  appc.background(240);
}
// Button Handlers
public void buttonSaveMp3Dir_click(GButton source, GEvent event) {
  String name = G4P.selectFolder("Folder Mp3 Dialog");
  if (name != null) {
    pathFileMp3 = name;
    labelMp3Msg.setText("path:" +pathFileMp3);
  }
}
public void buttonSaveMp3_click(GButton source, GEvent event) {
  boolean inputKosong = false;
  for (int k=0; k<totalKor; k++) {
    String aa = areaHalGo[k].getText();
    String bb = areaHalBack[k].getText();
    if ( aa.isEmpty() || bb.isEmpty()) {
      inputKosong = true;
    }
  }
  if (pathFileMp3 != null && !inputKosong) {
    createTextMessageW3("mp3 created", 5000);
    createMp3Files();
  } else {
    createTextMessageW3("mp3 not created", 5000);
  }
}
public void buttonSaveText_click(GButton source, GEvent event) { 
  boolean inputKosong = false;
  for (int k=0; k<totalKor; k++) {
    String aa = areaHalGo[k].getText();
    String bb = areaHalBack[k].getText();
    if ( aa.isEmpty() || bb.isEmpty()) {
      inputKosong = true;
    }
  }
  if (pathFileText != null && !inputKosong) {
    println("save as configfiles.txt");
    createTextMessageW2("save as configfiles.txt", 5000);
    String[] listFiles = new String[totalKor];
    String[] filego = new String[totalKor];
    String[] fileback = new String[totalKor];
    for (int i=0; i<totalKor; i++) {
      filego[i] = "k" +i +"go.txt"; 
      fileback[i] = "k" +i +"back.txt";
      listFiles[i] = filego[i] +"," +fileback[i]; 
      saveStrings(pathFileText +"\\" +filego[i], areaHalGo[i].getTextAsArray());
      saveStrings(pathFileText +"\\" +fileback[i], areaHalBack[i].getTextAsArray());
    }
    saveStrings(pathFileText+"\\"+"configfiles.txt", listFiles);
  } else {
    createTextMessageW2("files not saved", 5000);
  }
} 
public void buttonSaveTextDir_click(GButton source, GEvent event) { 
  String name = G4P.selectFolder("Folder Text Dialog");
  if (name != null) {
    pathFileText = name;
    labelMsg.setText("path:" +pathFileText);
  }
} 
//event handler
void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  //println( "[tick] - timeLeft: " + timeLeftUntilFinish + "ms");
}
void onFinishEvent(CountdownTimer t) {
  //println( "[finished]");
  labelErrorMsg.setText("");
  if (labelErrorMsgText != null)
    labelErrorMsgText.setText("");
  if (labelErrorMsgMp3 != null)
    labelErrorMsgMp3.setText("");
}
//message handler
public void createTextMessage(String msg, int wait) {
  labelErrorMsg.setText(msg);
  timer = CountdownTimerService.getNewCountdownTimer(this).configure(1000, wait).start();
}
public void createTextMessageW2(String msg, int wait) {
  labelErrorMsgText.setText(msg);
  timerW2 = CountdownTimerService.getNewCountdownTimer(this).configure(1000, wait).start();
}
public void createTextMessageW3(String msg, int wait) {
  labelErrorMsgMp3.setText(msg);
  timerW3 = CountdownTimerService.getNewCountdownTimer(this).configure(1000, wait).start();
}