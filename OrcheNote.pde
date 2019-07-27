class OrcheNote extends Note {
  int naturalSyllable;
  boolean isEnd;
  String audioPath;
  OrcheNote(int trackIndex, String slb) {
    this.trackIndex = trackIndex;
    this.position = new PVector(stonePosition.x, stonePosition.y);
    this.r = stoneR;
    this.myangle =  PI * 11 / 6 ;
    this.target = myangle;
    this.standardPosition = new PVector(roulettePosition.x + (rouletteInR + trackIndex * interval) * cos(myangle), roulettePosition.y + (rouletteInR + trackIndex * interval) * sin(myangle));
    status = "BIRTH";
    this.type = "ORCHE";
    if (!slb.equals("END")) {
      isEnd = false;
      naturalSyllable = natureTonality.getSyllableIndex(slb);
    } else
      isEnd = true;
    setColor();
    resetAudio();
  }

  void resetAudio() {
    String mySyllableName = currentTonality.getMySyllables().get(naturalSyllable).getName();
    this.audioPath = ((OrcheInstrument) tracks.get(this.trackIndex).getInstrument()).getPath(mySyllableName);
  }

  void setColor() {
    myColor = natureTonality.getMySyllables().get(naturalSyllable).getColor();
  }
  
  void play(){
    tracks.get(trackIndex).setOrchePlayer(audioPath);
  }
}
