class PercussionNote extends Note {
  boolean light;

  PercussionNote(int trackIndex, boolean l) {
    this.trackIndex = trackIndex;
    this.position = new PVector(stonePosition.x, stonePosition.y);
    this.r = stoneR;
    this.myangle =  PI * 17 / 10 ;
    this.target = myangle;
    this.standardPosition = new PVector(roulettePosition.x + (rouletteInR + trackIndex * interval) * cos(myangle), roulettePosition.y + (rouletteInR + trackIndex * interval) * sin(myangle));
    status = "BIRTH";
    this.type = "PERCUSSION";
    this.light = l;
    if (light) {
      this.myColor = percussionLight;
      audio = minim.loadFile(((PercussionInstrument) tracks.get(this.trackIndex).getInstrument()).getSoundPath1());
    } else {
      this.myColor = percussionHeavy;
      audio = minim.loadFile(((PercussionInstrument) tracks.get(this.trackIndex).getInstrument()).getSoundPath2());
    }
  }

  boolean isLight() {
    return this.light;
  }

  
}
