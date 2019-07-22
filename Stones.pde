 import ddf.minim.*;
import com.phidget22.* ;

static Minim minim ;

PVector backButtonPosition;
PVector freezeButtonPosition;
PVector roulettePosition;
PVector instructionPosition;
PVector instrumentPosition;
PVector knobPosition;
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
float tw;
float knobAngle;
float knobAngleStart;
float timeBarWidth;
float pluckInterval;
float thresholdInterval;
float maxInterval;
float timeTagX;
float rotationValue;
//float 

double indoorLight;

int arrowTik;
int bondedNumber;
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

Button backButton;
Button clearAllButton;
Button freezeButton;
PercussionInstrument currentPercussion;
PluckInstrument currentPluck;
SlideTag ignoreTag;
SlideTag lightTag;
SlideTag heavyTag;
SoundTrack currentTrack;
Tonality natureTonality;
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

  instruments = loadJSONObject("Instruments.json");
  instructions = loadJSONObject("Instruction.json");
  syllables = loadJSONArray("Syllables.json");
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
  } 
  catch (Exception e) {    
    System.out.println(e);
  }
  Database.init();
  makeNatureTonality();
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

  showInstruction = true;
  enter = false;
  back = false;
  unbonding = false;
  eraseFlag = true;
  freezing = false;
  started = false;

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
  currentInstruments = new ArrayList<Instrument>();
  currentInstruments.add(currentPercussion);
  currentInstruments.add(currentPluck);

  ignoreTag = new SlideTag(0, "None", false, percussionIgnore);
  lightTag = new SlideTag(currentPercussion.getLowThreshold(), currentPercussion.getSoundName1(), true, percussionLight);
  heavyTag = new SlideTag(currentPercussion.getHighThreshold(), currentPercussion.getSoundName2(), true, percussionHeavy);
}

void makeNatureTonality(){
  JSONObject nt = tonalities.getJSONObject(0);
  JSONArray syllableList = nt.getJSONArray("syllables");
  ArrayList<Syllable> mySyllables = new ArrayList<Syllable>();
  for(int i = 0; i < syllableList.size(); i++){
    mySyllables.add(Database.getSyllable(syllableList.getString(i)));
  }
  natureTonality = new Tonality(nt.getString("name"), mySyllables); 
  currentTonality = natureTonality;
}
