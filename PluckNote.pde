class PluckNote extends Note{
  
  int naturalSyllable;
  PluckNote(int trackIndex, String slb){
    this.trackIndex = trackIndex;
    this.position = new PVector(stonePosition.x, stonePosition.y);
    this.r = stoneR;
    this.myangle =  PI * 11 / 6 ;
    this.target = myangle;
    this.standardPosition = new PVector(roulettePosition.x + (rouletteInR + trackIndex * interval) * cos(myangle), roulettePosition.y + (rouletteInR + trackIndex * interval) * sin(myangle));
    status = "BIRTH";
    this.type = "PLUCK";
    naturalSyllable = natureTonality.getSyllableIndex(slb);
    setColor();
  }
  
  void resetAudio(){
    //this.audio = currentTonality.getMySyllables().get(i);
  }
  
  void setColor(){
    myColor = natureTonality.getMySyllables().get(naturalSyllable).getColor();  
  }
  
  void play(){
  }
}
