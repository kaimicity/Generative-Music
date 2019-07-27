import ddf.minim.*;
import com.phidget22.* ;
import processing.pdf.*;

static Minim minim ;

PVector backButtonPosition;
PVector freezeButtonPosition;
PVector roulettePosition;
PVector instructionPosition;
PVector instrumentPosition;
PVector knobPosition;
PVector scrollPosition;
PVector stonePosition;
PVector tonalityPosition;
PVector noteBarAreaPosition;
PVector orcheTimerPosition;

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
float tw;
float knobAngle;
float knobAngleStart;
float timeBarWidth;
float pluckInterval;
float thresholdInterval;
float maxInterval;
float timeTagX;
float rotationValue;
float tonalityWidth;
float tonalityHeight;
float noteBarAreaWidth;
float noteBarAreaHeight;
float orcheTimerR;
float orcheInterval;
float maxOrcheInterval;

double indoorLight;

int arrowTik;
int bondedNumber;
int currentOrcheIndex;
int currentPercussionIndex;
int currentPluckIndex;
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
int timeBarHeight;
int tonalityTimeStamp;
boolean adding;

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
ArrayList<Syllable> natureSyllables;


PFont nameFont;
static PFont percussionFont;
static PFont pluckFont;
static PFont orcheFont;

boolean showInstruction;
boolean enter;
boolean unbonding;
boolean back;

static JSONObject instruments;
JSONObject instructions;
static JSONArray syllables;
static JSONArray tonalities;

VoltageInput soundSensor;
VoltageInput lightSensor;
VoltageRatioInput rotationSensor;
VoltageInput tempratureSensor;

Button backButton;
Button clearAllButton;
Button freezeButton;
PercussionInstrument currentPercussion;
PluckInstrument currentPluck;
OrcheInstrument currentOrche;
SlideTag ignoreTag;
SlideTag lightTag;
SlideTag heavyTag;
SoundTrack currentTrack;
static Tonality natureTonality;
Tonality currentTonality;

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
  knobPosition = new PVector(200 + width * 4 / 7, height + 300);
  tonalityPosition = new PVector( 200 + width * 5.55 / 7, height / 21);
  noteBarAreaPosition = new PVector(900 , height * 10 / 20);
  orcheTimerPosition = new PVector(650, height - 35);
  

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
  startR = stoneR;
  tonalityWidth = width * 2.5 / 14;
  tonalityHeight = height * 1 / 14;
  noteBarAreaWidth = 270;
  noteBarAreaHeight = height  * 10 / 20;
  orcheTimerR = 75;

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
  knobAngle = acos(0.75) * 2;
  knobAngleStart = PI + (PI - knobAngle) / 2 + knobAngle / 16;
  timeBarWidth = 4 * rouletteOutR / 3;
  timeBarHeight = 30;

  unbondSoundtrack = color(#C9C9C9);
  normalStroke = color(#000000);
  percussionIgnore = color(180, 180, 180);
  percussionLight = color(120, 120, 120);
  percussionHeavy = color(60, 60, 60);
  secondaryInstrumentColor = color(#696969);
  whiteColor = color(#FFFFFF);

  nameFont = createFont("fonts/TLI.ttf", 20);
  percussionFont = createFont("fonts/Mobile.ttf", 30);
  pluckFont = createFont("fonts/SFA.ttf", 30);
  orcheFont = createFont("fonts/Hollywood.ttf", 30);

  instruments = loadJSONObject("Instruments.json");
  instructions = loadJSONObject("Instruction.json");
  syllables = loadJSONArray("Syllables2.json");
  tonalities = loadJSONArray("Tonality.json");

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
    rotationSensor = new VoltageRatioInput();
    rotationSensor.setDeviceSerialNumber(274066); 
    rotationSensor.setChannel(6);
    rotationSensor.open();
    tempratureSensor = new VoltageInput();
    tempratureSensor.setDeviceSerialNumber(274066);
    tempratureSensor.setChannel(7);
    tempratureSensor.open();
  } 
  catch (Exception e) {    
    //System.out.println(e);
  }
  Database.init();
  natureSyllables = natureTonality.getMySyllables();
  init();
}

void init() {
  currentPercussionIndex = 0;
  currentPluckIndex = 0;
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
  pluckInterval = 0.5;
  thresholdInterval = 1.0;
  maxInterval = 2.0;
  timeTagX = 0.375;
  indoorLight = 0;
  orcheInterval = 0.3;
  maxOrcheInterval = 2.0;

  showInstruction = true;
  enter = false;
  back = false;
  unbonding = false;
  eraseFlag = true;
  freezing = false;
  started = false;
  tonalityLocked = false;

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
  currentPluck = Database.pluckInstruments.get(currentPluckIndex);
  currentOrche = Database.orcheInstruments.get(currentOrcheIndex);
  currentInstruments = new ArrayList<Instrument>();
  currentInstruments.add(currentPercussion);
  currentInstruments.add(currentPluck);
  currentInstruments.add(currentOrche);
  currentTonality = natureTonality;

  ignoreTag = new SlideTag(0, "None", false, percussionIgnore);
  lightTag = new SlideTag(currentPercussion.getLowThreshold(), currentPercussion.getSoundName1(), true, percussionLight);
  heavyTag = new SlideTag(currentPercussion.getHighThreshold(), currentPercussion.getSoundName2(), true, percussionHeavy);
  
  
}
