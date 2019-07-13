class PercussionInstrument extends Instrument {


  
  String soundName1;
  String soundName2;
  
  String soundPath1;
  String soundPath2;
  
  int lowThreshold;
  int highThreshold;
  int c;

  PercussionInstrument(String name, String soundPath1, String soundPath2, String name1, String name2) {
    this.name = name;
    myFont = percussionFont;
    this.soundPath1 = soundPath1;
    this.soundPath2 = soundPath2;
    this.soundName1 = name1;
    this.soundName2 = name2;
    c = 0;
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
  
  String getSoundPath1(){
    return this.soundPath1;
  }
  
  String getSoundPath2(){
    return this.soundPath2;
  }
  
  void setLowThreshold(int lt){
    this.lowThreshold = lt;
  }
  
  void setHighThreshold(int ht){
    this.highThreshold = ht;
  }
  
}
