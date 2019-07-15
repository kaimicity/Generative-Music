import ddf.minim.*;
import com.phidget22.* ;

static Minim minim ;

PVector backButtonPosition;
PVector freezeButtonPosition;
PVector roulettePosition;
PVector instructionPosition;
PVector instrumentPosition;
PVector scrollPosition;
PVector stonePosition;

float backButtonWidth;
float backButtonHeight;
float instructionWidth;
float instructionHeight;
float instrumentOffset;
float maxSound;
float panelOffset;
float panelSpeed;
float scrollCurrentY;
float scrollHeight;
float scrollWidth;
float slideBarWidth;
float slideBarY;
float soundValue;
float stoneR;

double indoorLight;

int arrowTik;
int bondedNumber;
int currentPercussionIndex;
int dragging;
int interval;
int numberOfRing;
int panelOpacity;
int panelR;
int panelStrokeWidth;
int rouletteInR;
int rouletteOutR;
int secondaryInstrumentFontSize;
int switchButtonR;
int test;
int toBond;
int uiOpacity;
int trackOpacity;
int lightRefreshCounter;

color unbondSoundtrack;
color normalStroke;
color percussionIgnore;
color percussionLight;
color percussionHeavy;
color secondaryInstrumentColor;
color whiteColor;

String currentPanel;

ArrayList<SoundTrack> tracks;
ArrayList<PanelButton> pbs;
ArrayList<Instrument> currentInstruments;


PFont nameFont;
static PFont percussionFont;

boolean showInstruction;
boolean enter;
boolean unbonding;
boolean back;

static JSONObject instruments;
JSONObject instructions;

VoltageInput soundSensor;
VoltageInput lightSensor;

Button backButton;
Button clearAllButton;
Button freezeButton;
PercussionInstrument currentPercussion;
SlideTag ignoreTag;
SlideTag lightTag;
SlideTag heavyTag;
SoundTrack currentTrack;

void setup() {
  minim = new Minim(this) ;

  size(1200, 800);
  width = 1000;
  height = 750;
  roulettePosition = new PVector(200 + width * 4 / 7, height * 9 / 20);
  instructionPosition = new PVector(width / 10, height / 10);
  instrumentPosition = new PVector(200 + width * 4 / 7, height * 7 / 20);
  backButtonPosition = new PVector(width / 10, height * 13 / 20);
  freezeButtonPosition = new PVector(width / 10, height * 16 / 20);
  scrollPosition = new PVector(width / 10 - width / 50, height / 10 - height / 100);
  stonePosition = new PVector(200 + width * 4 / 7, height * 10 / 20);

  backButtonWidth = width * 2 / 7;
  backButtonHeight = height / 10;
  instructionWidth = width * 2 / 7;
  instructionHeight = height / 2;
  instrumentOffset = PI / 3;
  maxSound = 0.15;
  panelOffset = 0;
  panelSpeed = 0.01;
  scrollHeight = height / 100;
  scrollWidth = width * 2 / 7 + width / 25;
  slideBarWidth = height / 15;
  slideBarY = height + 25;
  stoneR = height * 1.5 / 20;

  arrowTik = 0;
  numberOfRing = 5;
  rouletteOutR = height * 6 / 15;
  rouletteInR = height / 5;
  interval = (rouletteOutR - rouletteInR) / (numberOfRing - 1);
  lightRefreshCounter = 0;
  panelStrokeWidth = 5;
  secondaryInstrumentFontSize = 15;
  switchButtonR = 20;
  panelR = rouletteInR - interval;

  unbondSoundtrack = color(#C9C9C9);
  normalStroke = color(#000000);
  percussionIgnore = color(180, 180, 180);
  percussionLight = color(120, 120, 120);
  percussionHeavy = color(60, 60, 60);
  secondaryInstrumentColor = color(#696969);
  whiteColor = color(#FFFFFF);

  nameFont = createFont("fonts/TLI.ttf", 20);
  percussionFont = createFont("fonts/Mobile.ttf", 30);

  instruments = loadJSONObject("Instruments.json");
  instructions = loadJSONObject("Instruction.json");

  backButton = new Button(backButtonPosition, backButtonWidth, backButtonHeight, "BACK");
  clearAllButton = new Button(backButtonPosition, backButtonWidth, backButtonHeight, "CLEAR ALL");
  freezeButton = new Button(freezeButtonPosition, backButtonWidth, backButtonHeight, "FREEZE");

  try {
    soundSensor = new VoltageInput();
    soundSensor.setDeviceSerialNumber(274066);     
    soundSensor.setChannel(1);  
    soundSensor.open();
    lightSensor = new VoltageInput();
    lightSensor.setDeviceSerialNumber(274066);     
    lightSensor.setChannel(0);  
    lightSensor.open();
  } 
  catch (PhidgetException e) {    
    System.out.println(e);
  }
  Database.init();
  init();
}

void init() {
  currentPercussionIndex = 0;
  panelOpacity = 255;
  trackOpacity = 255;
  lastReadTime = 0;
  uiOpacity = 0;
  dragging = 0;
  scrollCurrentY = 0;
  soundValue = 0; 
  test = -1;
  toBond = 0;
  shakingCounter = 0;

  showInstruction = true;
  enter = false;
  back = false;
  unbonding = false;
  eraseFlag = true;
  freezing = false;

  currentPanel = "NONE";

  tracks = new ArrayList<SoundTrack>();
  for ( int i = 0; i < 5; i++) {
    SoundTrack st = new SoundTrack(i);
    tracks.add(st);
  }

  pbs = new ArrayList<PanelButton>();
  for ( int i = 0; i < 3; i++) {
    PanelButton pb = new PanelButton(i);
    pbs.add(pb);
  }

  for (PercussionInstrument pi : Database.percussionInstruments)
    pi.initThreshold();

  currentPercussion = Database.percussionInstruments.get(currentPercussionIndex);
  currentInstruments = new ArrayList<Instrument>();
  currentInstruments.add(currentPercussion);

  ignoreTag = new SlideTag(0, "None", false, percussionIgnore);
  lightTag = new SlideTag(currentPercussion.getLowThreshold(), currentPercussion.getSoundName1(), true, percussionLight);
  heavyTag = new SlideTag(currentPercussion.getHighThreshold(), currentPercussion.getSoundName2(), true, percussionHeavy);
}

boolean inTag1;
boolean inTag2;
boolean inButton1;
boolean inButton2;
boolean inBackButton;
boolean inFreezeButton;
boolean inClin;

double lightValue;
boolean eraseFlag;
boolean lightSwitch;
int shakingCounter;
int coverTime;
boolean freezing;
void draw() {
  if (indoorLight == 0) {  
    try {
      indoorLight = lightSensor.getSensorValue();
      println(indoorLight);
      if (indoorLight < 0.2)
        lightSwitch = false;
      else
        lightSwitch = true;
    } 
    catch(Exception e) {
      println(e.toString());
    }
  }
  background(whiteColor);
  drawRoulette();
  inClin = inClinch();
  inBackButton = backButton.isFocused();

  switch(currentPanel) {
  case "NONE":
    drawPanel();
    drawInstruction(panelOpacity);
    inFreezeButton = freezeButton.isFocused();
    if (mousePressed && inFreezeButton && !lightSwitch) {
      freezing = true;
    } else {
      freezing = false;
    }
    if (!enter && !back) {
      try {
        lightValue = lightSensor.getSensorValue();
        if (indoorLight - lightValue > 0.03 && !freezing) {
          if (millis() - coverTime > 1000) {
            freezing = true;
            shakingCounter = 0;
          }
          if (eraseFlag) {
            shakingCounter ++;
            eraseFlag = false;
            if (shakingCounter > 1 && bondedNumber > 0)
              unbonding = true;
          }
        } else if (indoorLight - lightValue < 0.03) {
          coverTime = millis();
          eraseFlag = true;
          freezing = false;
        }
      } 
      catch(Exception e) {
        println(e.toString());
      }
    }
    if (!lightSwitch) {
      clearAllButton.draw(panelOpacity);
      freezeButton.draw(panelOpacity);
    }
    if (unbonding) {
      trackOpacity -= 2;
      if (trackOpacity <= 0) {
        trackOpacity = 255;
        unbondAll();
        unbonding = false;
        bondedNumber = 0;
        toBond = 0;
        shakingCounter = 0;
      }
    }
    if (back && panelOpacity < 255) {
      cursor(ARROW);
      panelOpacity += 5;
      if (panelOpacity >= 255) {
        back = false;
      }
    } else if (test != -1) {
      if (!enter && !back)
        cursor(HAND);
      textAlign(CENTER, CENTER);
      textFont(nameFont);
      textSize(height / 15);
      fill(normalStroke);
      if (!enter)
        text(pbs.get(test).getName(), roulettePosition.x, height * 14 / 15);
      else {
        cursor(ARROW);
        fill(normalStroke, panelOpacity);
        text(pbs.get(test).getName(), roulettePosition.x, height * 14 / 15);
        if (enter && panelOpacity > 0) {
          panelOpacity -= 5;
          if (panelOpacity <= 0)
            currentPanel = Database.buttonMark[test];
        }
      }
    } else if ((inClin || inBackButton || inFreezeButton) && !unbonding && !lightSwitch) 
      cursor(HAND);
    else
      cursor(ARROW);
    break;
  case "PERCUSSION":
    config();
    drawPercussion();
    inTag1 = lightTag.inTag();
    inTag2 = heavyTag.inTag();
    switch(dragging) {
    case 0:
      if (!enter && !back) {
        if (inTag1 || inTag2)
          cursor(MOVE);
        else if (inButton1 || inButton2 || inClin || (!lightSwitch && inBackButton))
          cursor(HAND);
        else 
        cursor(ARROW);
        if (inTag1 && mousePressed) {
          dragging = 1;
        } else if (inTag2 && mousePressed) {
          dragging = 2;
        }
      }
      break;
    case 1:
      int adjustedLow = (int)((mouseX - (roulettePosition.x - rouletteOutR + slideBarWidth)) * 100 / (rouletteOutR * 2) + 0.5 - 4);
      if (adjustedLow <= currentPercussion.getHighThreshold() && adjustedLow >= 0) {
        currentPercussion.setLowThreshold(adjustedLow);
        lightTag.setX(adjustedLow);
      }
      break;
    case 2:
      int adjustedHigh = (int)((mouseX - (roulettePosition.x - rouletteOutR + slideBarWidth)) * 100 / (rouletteOutR * 2) + 0.5 - 4);
      if (adjustedHigh <= 100 && adjustedHigh >= currentPercussion.getLowThreshold()) {
        currentPercussion.setHighThreshold(adjustedHigh);
        heavyTag.setX(adjustedHigh);
      }
      break;
    }
    break;
  case "PLUCK":
    config();
    drawPluk();
    break;
  }
}

void drawRoulette() {
  for (SoundTrack st : tracks) {
    st.draw();
  }
}

void drawPanel() {
  for (PanelButton pb : pbs) {
    if (pb.inButton()) {
      test = pb.index;
      break;
    } else
      test = -1 ;
  }
  noFill();
  mountEnterStroke(normalStroke, panelOpacity);
  strokeWeight(panelStrokeWidth / 2);
  ellipse(roulettePosition.x, roulettePosition.y, panelR * 2, panelR * 2);
  pushMatrix();
  translate(roulettePosition.x, roulettePosition.y);
  if (mousePressed && test != -1 && !enter && !back) {
    fill(unbondSoundtrack);
    arc(0, 0, panelR * 2, panelR * 2, pbs.get(test).getStarting(), pbs.get(test).getStarting() + PI * 2 / 3);
  }
  rotate(PI / 6);
  line(0, 0, panelR, 0);
  pbs.get(0).draw();
  rotate(PI / 3 * 2);
  line(0, 0, panelR, 0);
  pbs.get(1).draw();
  rotate(PI / 3 * 2);
  line(0, 0, panelR, 0);
  pbs.get(2).draw();
  popMatrix();
}

float getDistance(float x1, float y1, float x2, float y2) {
  PVector dis = new PVector(x1 - x2, y1 - y2) ;
  return dis.mag() ;
}

void mouseReleased() {
  if (inClinch()) {
    showInstruction = !showInstruction;
  }

  switch(currentPanel) {
  case "NONE":
    if (test != -1 && !unbonding) {
      enter = true;
      currentTrack = tracks.get(toBond);
      currentTrack.bond(currentInstruments.get(test));
      bondedNumber ++;
      for (SoundTrack st : tracks) {
        if (!st.isBonded()) {
          toBond = st.getIndex();
          break;
        }
      }
    } else if (clearAllButton.isFocused() && !enter && ! back && !lightSwitch) {
      unbonding = true;
    }
    break;
  case "PERCUSSION":
    if (dragging!=0) {
      cursor(ARROW);
      dragging = 0;
    } else if (!enter && !back && inButton1) {
      if (currentPercussionIndex - 1 >= 0)
        currentPercussionIndex --;
      else
        currentPercussionIndex = Database.percussionInstruments.size() - 1;
      currentPercussion = Database.percussionInstruments.get(currentPercussionIndex);
      currentTrack.setInstrument(currentPercussion);
      tagsReset();
    } else if (!enter && !back && inButton2) {
      if (currentPercussionIndex + 1 <= Database.percussionInstruments.size() - 1)
        currentPercussionIndex ++;
      else
        currentPercussionIndex = 0;
      currentPercussion = Database.percussionInstruments.get(currentPercussionIndex);
      currentTrack.setInstrument(currentPercussion);
      tagsReset();
    } else if (inBackButton) {
      startBack();
    }
  }
}

void tagsReset() {
  lightTag.setX(currentPercussion.getLowThreshold());
  lightTag.setContent(currentPercussion.getSoundName1());
  heavyTag.setX(currentPercussion.getHighThreshold());
  heavyTag.setContent(currentPercussion.getSoundName2());
}

void mountEnterStroke(color c, int opa) {
  if (enter || back) {
    stroke(c, opa);
  } else {
    stroke(c);
  }
}
void mountEnterFill(color c, int opa) {
  if (enter|| back) {
    fill(c, opa);
  } else {
    fill(c);
  }
}

void drawPluk(){
  
}

float tw;
boolean adding;
void drawPercussion() {
  mountEnterFill(normalStroke, uiOpacity);
  textFont(percussionFont);
  textAlign(CENTER, CENTER);
  text(currentPercussion.getName(), instrumentPosition.x, instrumentPosition.y);
  fill(normalStroke, Math.abs(arrowTik - 255));
  tw = textWidth(currentPercussion.getName());
  text("<", instrumentPosition.x - tw / 1.3, instrumentPosition.y + 3);
  text(">", instrumentPosition.x + tw / 1.3, instrumentPosition.y + 3);
  if (arrowTik < 255 * 2)
    arrowTik += 5;
  else
    arrowTik = 0;
  noFill();
  mountEnterStroke(normalStroke, uiOpacity);
  if (millis() - lastReadTime >= 100) {
    noFill();
  } else if (lastVolumn >= currentPercussion.getHighThreshold()) {
    fill(percussionHeavy);
    if (!adding) {
      adding = true;
      Note note = new PercussionNote(currentTrack.getIndex(), false);
      currentTrack.addNote(note);
    }
  } else if (lastVolumn >= currentPercussion.getLowThreshold()) {
    fill(percussionLight);
    if (!adding) {
      adding = true;
      Note note = new PercussionNote(currentTrack.getIndex(), true);
      currentTrack.addNote(note);
    }
  }
  ellipse(stonePosition.x, stonePosition.y, stoneR * 2, stoneR * 2);
  pushMatrix();
  translate(stonePosition.x + height * 0.1, stonePosition.y);
  textAlign(CENTER, CENTER);
  textSize(secondaryInstrumentFontSize);
  mountEnterFill(secondaryInstrumentColor, uiOpacity);
  if (currentPercussionIndex + 1 < Database.percussionInstruments.size())
    text(Database.percussionInstruments.get(currentPercussionIndex + 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.percussionInstruments.get(0).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  translate(- height * 0.2, 0);
  if (currentPercussionIndex - 1 >= 0)
    text(Database.percussionInstruments.get(currentPercussionIndex - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.percussionInstruments.get(Database.percussionInstruments.size() - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  popMatrix();
  drawSlideBar();
}

boolean inLeftSwitchButton() {
  if (getDistance(mouseX, mouseY, instrumentPosition.x - tw / 1.3, instrumentPosition.y + 3) < switchButtonR)
    return true;
  else
    return false;
}

boolean inRightSwitchButton() {
  if (getDistance(mouseX, mouseY, instrumentPosition.x + tw / 1.3, instrumentPosition.y + 3) < switchButtonR)
    return true;
  else
    return false;
}

float lowLine;
float highLine;
int lastReadTime;
int lastValidTime;
double lastReadValue;
float lastVolumn;
void drawSlideBar() {
  try {
    double gsv = soundSensor.getSensorValue();
    if (!enter && ! back && millis() - lastReadTime >= 500 && gsv > 0.035 ) {
      lastReadTime = millis();
      lastReadValue = gsv;
      soundValue = (float)gsv - 0.03;
      if (soundValue > maxSound)
        soundValue = maxSound;
      adding = false;
    } else {
      if (soundValue > 0)
        soundValue -= 0.001;
    }
  } 
  catch( Exception e) {   
    System.out.println(e.toString());
  }
  pushMatrix();
  translate(roulettePosition.x - rouletteOutR, slideBarY);
  float currentVolumn = soundValue * 100 / maxSound;
  lastVolumn = currentVolumn;
  noStroke();
  fill(percussionIgnore);
  if (currentVolumn <= currentPercussion.getLowThreshold()) {
    quad(0, 0, slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth )* currentVolumn / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentVolumn / 100, 0);
  } else if ( currentVolumn <= currentPercussion.getHighThreshold()) {
    quad(0, 0, slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, 
      (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0);
    fill(percussionLight);
    quad( (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0, 
      (rouletteOutR * 2 - slideBarWidth ) * currentVolumn / 100, 0, (rouletteOutR * 2 - slideBarWidth )* currentVolumn / 100 + slideBarWidth, - slideBarWidth);
  } else {
    quad(0, 0, slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, 
      (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0);
    fill(percussionLight);
    quad( (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0, 
      (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100, 0, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100 + slideBarWidth, - slideBarWidth);
    fill(percussionHeavy);
    quad( (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100, 0, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100 + slideBarWidth, - slideBarWidth, 
      (rouletteOutR * 2 - slideBarWidth )* currentVolumn / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentVolumn / 100, 0);
  }
  fill(percussionIgnore);
  textAlign(LEFT, BOTTOM);
  textSize(height / 16);
  text("0", height / 15, 0); 
  strokeWeight(panelStrokeWidth / 2);
  stroke(percussionLight);
  lowLine = (rouletteOutR * 2 - slideBarWidth) * currentPercussion.getLowThreshold() / 100;
  line(lowLine, 0, lowLine + slideBarWidth, - slideBarWidth);
  fill(percussionLight);
  text(currentPercussion.getLowThreshold(), lowLine + height / 15, 0); 
  stroke(percussionHeavy);
  highLine = (rouletteOutR * 2 - slideBarWidth) * currentPercussion.getHighThreshold() / 100;
  line(highLine, 0, highLine + slideBarWidth, - slideBarWidth);
  fill(percussionHeavy);
  text(currentPercussion.getHighThreshold(), highLine + height / 15, 0); 
  fill(normalStroke);
  text("100", rouletteOutR * 2 - slideBarWidth + height / 15, 0);
  stroke(unbondSoundtrack);
  strokeWeight(panelStrokeWidth);
  noFill();
  quad(0, 0, slideBarWidth, - slideBarWidth, rouletteOutR * 2, - slideBarWidth, rouletteOutR * 2 - slideBarWidth, 0);
  popMatrix();
  ignoreTag.draw();
  lightTag.draw();
  heavyTag.draw();
}

void drawInstruction(int opa) {
  stroke(normalStroke);
  noFill();
  strokeJoin(BEVEL);
  strokeWeight(panelStrokeWidth / 3);
  if (showInstruction && scrollCurrentY > 0) {
    scrollCurrentY -= min(instructionHeight / 80, scrollCurrentY);
  } else if (! showInstruction && scrollCurrentY < instructionHeight) {
    scrollCurrentY += min(instructionHeight / 80, instructionHeight - scrollCurrentY);
  }
  rect(instructionPosition.x, instructionPosition.y - scrollCurrentY, instructionWidth, instructionHeight);
  fill(normalStroke, opa);
  textAlign(LEFT, TOP);
  textFont(nameFont);
  textSize(20);
  text(instructions.getString(currentPanel), instructionPosition.x + 10, instructionPosition.y - scrollCurrentY + 10, instructionWidth - 20, instructionHeight - 20);
  fill(whiteColor);
  strokeWeight(panelStrokeWidth / 2);
  rect(scrollPosition.x, scrollPosition.y, scrollWidth, scrollHeight);
  line(scrollPosition.x + scrollWidth, instructionPosition.y, scrollPosition.x + scrollWidth, instructionPosition.y + height / 10);
  if (showInstruction)
    fill(normalStroke);
  else
    noFill();
  ellipse(scrollPosition.x + scrollWidth, instructionPosition.y + height / 10 + 7.5, 15, 15);
  noStroke();
  fill(whiteColor);
  rect(scrollPosition.x, 0, scrollWidth, scrollPosition.y);
}

boolean inClinch() {
  if (getDistance(mouseX, mouseY, scrollPosition.x + scrollWidth, instructionPosition.y + height / 10 + 7.5) < 7.5)
    return true;
  else
    return false;
}

void unbondAll() {
  for (SoundTrack st : tracks) {
    if (st.isBonded())
      st.unbond();
  }
}

void startBack() {
  if (currentTrack.getNoteNumber() == 0) {
    currentTrack.getLabel().setCreating(true);
    bondedNumber --;
  }
  back = true;
}

void back() {
  uiOpacity -= 5;
  if (uiOpacity <= 0) {
    currentPanel = "NONE";
    if (currentTrack.getNoteNumber() == 0) {
      currentTrack.unbond();
      toBond = currentTrack.getIndex();
    } else {
      currentTrack.activate();
    }
  }
}

float normaliseAngle(float angle) {
  if (angle < 0)
    angle += PI * 2;
  else if (angle >= PI * 2)
    angle -= PI * 2;
  return angle;
}

void config() {
  if (enter) {
    uiOpacity +=5;
    if (uiOpacity >= 255) {
      enter = false;
      currentTrack.getLabel().setCreating(false);
    }
  } 
  if (back) {
    back();
  }
  drawInstruction(uiOpacity);
  if (!enter && !back) {
    try {
      lightValue = lightSensor.getSensorValue();
      if (indoorLight - lightValue > 0.03 && currentTrack.allNotesReady()) {
        startBack();
      }
    } 
    catch(Exception e) {
      println(e.toString());
    }
  }
  if (!lightSwitch)
    backButton.draw(uiOpacity);
  inButton1 = inLeftSwitchButton();
  inButton2 = inRightSwitchButton();
}
