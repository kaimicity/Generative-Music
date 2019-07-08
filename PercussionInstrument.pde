class PercussionInstrument extends Instrument {


  AudioPlayer sound1;
  AudioPlayer sound2;
  
  String soundName1;
  String soundName2;
  
  int lowThreshold;
  int highThreshold;

  PercussionInstrument(String name, String soundPath1, String soundPath2, String name1, String name2) {
    this.name = name;
    myFont = percussionFont;
    this.sound1 = minim.loadFile(soundPath1);
    this.sound2 = minim.loadFile(soundPath2);
    this.soundName1 = name1;
    this.soundName2 = name2;
  }
  
  void initThreshold(){
    this.lowThreshold = 40; 
    this.highThreshold = 70;
  }
  String getSoundName1(){
    return this.soundName1;
  }
  
  String getSoundName2(){
    return this.soundName2;
  }
  
  int getLowThreshold(){
    return this.lowThreshold;
  }
  
  int getHighThreshold(){
    return this.highThreshold;
  }
  
  void setLowThreshold(int lt){
    this.lowThreshold = lt;
  }
  
  void setHighThreshold(int ht){
    this.highThreshold = ht;
  }
}
