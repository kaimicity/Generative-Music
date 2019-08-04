class PluckNote extends Note{
  
  int naturalSyllable;
  PluckNote(int trackIndex, String slb){
    this.trackIndex = trackIndex;
    this.position = new PVector(stonePosition.x, stonePosition.y);
    this.r = stoneR;
    this.myangle =  PI * 17 / 10 ;
    this.target = myangle;
    this.standardPosition = new PVector(roulettePosition.x + (rouletteInR + trackIndex * interval) * cos(myangle), roulettePosition.y + (rouletteInR + trackIndex * interval) * sin(myangle));
    status = "BIRTH";
    this.type = "PLUCK";
    naturalSyllable = natureTonality.getSyllableIndex(slb);
    setColor();
    resetAudio();
  }
  
  void resetAudio(){
    String mySyllableName = currentTonality.getMySyllables().get(naturalSyllable).getName();
    this.audio = minim.loadFile(((PluckInstrument) tracks.get(this.trackIndex).getInstrument()).getPath(mySyllableName));
  }
  
  void setColor(){
    myColor = natureTonality.getMySyllables().get(naturalSyllable).getColor();  
  }
  
}
