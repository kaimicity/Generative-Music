class SoundTrack {
  PVector position = roulettePosition;
  int r;
  int index;
  color myColor = unbondSoundtrack;
  boolean bonded;
  Label myLabel;
  Instrument instrument;

  SoundTrack(int i) {
    this.index = i;
    this.r = rouletteInR + i * interval;
  }

  int getR() {
    return this.r;
  }

  int getIndex() {
    return this.index;
  }

  boolean isBonded() {
    return this.bonded;
  }
  
  void bond(Instrument ins){
    this.bonded = true;
    this.instrument = ins;
    myLabel = new Label(index, ins);
  }
  
  void setInstrument(Instrument ins){
    this.instrument = ins;
    myLabel.setInstrument(ins);
  }
  
  void draw() {
    stroke(unbondSoundtrack);
    noFill();
    ellipse(position.x, position.y, r * 2, r * 2);
    if(bonded)
      myLabel.draw();
  }
}
