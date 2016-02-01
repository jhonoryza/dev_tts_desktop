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
  inputChange = true;
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
  inputChange = true;
} //_CODE_:inputPitch:683113:

public void inputRate_change(GTextField source, GEvent event) { //_CODE_:inputRate:979273:
  println("inputRate - GTextField >> GEvent." + event + " @ " + millis());
  inputChange = true;
} //_CODE_:inputRate:979273:

public void inputVolume_change(GTextField source, GEvent event) { //_CODE_:inputVolume:633250:
  println("inputVolume - GTextField >> GEvent." + event + " @ " + millis());
  inputChange = true;
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
  labelTts = new GLabel(this, 10, 40, 120, 20);
  labelTts.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelTts.setText("input text to speech:");
  labelTts.setOpaque(false);
  inputSpeech = new GTextField(this, 140, 40, 160, 20, G4P.SCROLLBARS_NONE);
  inputSpeech.setPromptText("input text here");
  inputSpeech.setOpaque(true);
  inputSpeech.addEventHandler(this, "inputSpeech_change");
  buttonPlay = new GButton(this, 310, 40, 90, 40);
  buttonPlay.setText("save to mp3         & play");
  buttonPlay.addEventHandler(this, "buttonPlay_click");
  labelKorNum = new GLabel(this, 10, 120, 120, 20);
  labelKorNum.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  labelKorNum.setText("input jumlah koridor:");
  labelKorNum.setOpaque(false);
  inputKorNum = new GTextField(this, 140, 120, 160, 20, G4P.SCROLLBARS_NONE);
  inputKorNum.setPromptText("input number here");
  inputKorNum.setOpaque(true);
  inputKorNum.addEventHandler(this, "inputKorNum_change");
  buttonCreate = new GButton(this, 310, 120, 90, 20);
  buttonCreate.setText("create");
  buttonCreate.addEventHandler(this, "buttonCreate_click");
  buttonDir = new GButton(this, 310, 90, 90, 20);
  buttonDir.setText("select directory");
  buttonDir.addEventHandler(this, "buttonDir_click");
  labelDirPath = new GLabel(this, 410, 90, 380, 50);
  labelDirPath.setTextAlign(GAlign.LEFT, GAlign.TOP);
  labelDirPath.setText("save mp3 files to: not selected");
  labelDirPath.setOpaque(false);
  labelErrorMsg = new GLabel(this, 360, 10, 280, 20);
  labelErrorMsg.setLocalColorScheme(GCScheme.RED_SCHEME);
  labelErrorMsg.setOpaque(false);
  labelPitch = new GLabel(this, 420, 40, 60, 20);
  labelPitch.setText("pitch");
  labelPitch.setOpaque(false);
  inputPitch = new GTextField(this, 480, 40, 60, 20, G4P.SCROLLBARS_NONE);
  inputPitch.setText("0.5");
  inputPitch.setOpaque(true);
  inputPitch.addEventHandler(this, "inputPitch_change");
  labelRate = new GLabel(this, 540, 40, 50, 20);
  labelRate.setText("rate");
  labelRate.setOpaque(false);
  inputRate = new GTextField(this, 590, 40, 60, 20, G4P.SCROLLBARS_NONE);
  inputRate.setText("0.5");
  inputRate.setOpaque(true);
  inputRate.addEventHandler(this, "inputRate_change");
  labelVolume = new GLabel(this, 650, 40, 60, 20);
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
GButton buttonDir; 
GLabel labelDirPath; 
GLabel labelErrorMsg; 
GLabel labelPitch; 
GTextField inputPitch; 
GLabel labelRate; 
GTextField inputRate; 
GLabel labelVolume; 
GTextField inputVolume; 