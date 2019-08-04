class OrcheNote extends Note {
  int naturalSyllable;
  boolean isEnd;
  String audioPath;
  OrcheNote(int trackIndex, int slb) {
    this.trackIndex = trackIndex;
    this.position = new PVector(stonePosition.x, stonePosition.y);
    this.r = stoneR;
    this.myangle =  PI * 17 / 10 ;
    this.target = myangle;
    this.standardPosition = new PVector(roulettePosition.x + (rouletteInR + trackIndex * interval) * cos(myangle), roulettePosition.y + (rouletteInR + trackIndex * interval) * sin(myangle));
    status = "BIRTH";
    this.type = "ORCHE";
    if (slb != -1) {
      isEnd = false;
      naturalSyllable = slb;
    } else
      isEnd = true;
    setColor();
    resetAudio();
  }

  void resetAudio() {
    //if (!isEnd) {
      String mySyllableName = currentTonality.getMySyllables().get(naturalSyllable).getName();
      this.audioPath = ((OrcheInstrument) tracks.get(this.trackIndex).getInstrument()).getPath(mySyllableName);
    //} else{
    //  this.audioPath = "END";
    //}
    
  }

  void setColor() {
    //if (!isEnd)
      myColor = natureTonality.getMySyllables().get(naturalSyllable).getColor();
    //else 
    //myColor = whiteColor;
  }

  void play() {
    //if (!isEnd)
      tracks.get(trackIndex).setOrchePlayer(audioPath);
      if(isEnd && !tracks.get(trackIndex).bothEnd()){
        tracks.get(trackIndex).setEnd();
      } else{
        isEnd = false;
      }
    //else
    //  tracks.get(trackIndex).diminish();
  }
  
  void setEnd(){
    this.isEnd = true;
  }
  
  boolean getEnd(){
    return isEnd;
  }
  
}
