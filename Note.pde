class Note{
  AudioPlayer audio;
  float speed;
  PVector position;
  float resetSpeed = PI / 50;
  float myAngel;
  float target;
  float r;
  float standardR = rouletteInR / 15;
  PVector standardPosition;
  color myColor;
  String status;
  
  
  Note(color mc, AudioPlayer ap, int trackIndex){
    this.myColor = mc;
    this.audio = ap;
    this.position = stonePosition;
    this.r = stoneR;
    this.myAngel = PI / 6;
    this.target = PI / 6;
    this.standardPosition = new PVector(roulettePosition.x + (rouletteInR + trackIndex * interval) * cos(PI / 6), roulettePosition.y + (rouletteInR + trackIndex * interval) * sin(PI / 6));
    status = "BIRTH";
  }
  
  void play(){
    audio.rewind();
    audio.play();
  }
  
  void setAudioPlayer(AudioPlayer ap){
    this.audio = ap;
  }
  
  void draw(){
    switch(status){
      case "BIRTH":
        
    }
  }
  
  void eject(){
    position.x += (standardPosition.x - stonePosition.x) / 50;
    if(position.x > standardPosition.x)
      position.x = standardPosition.x;
    position.y += (position.y - stonePosition.y + 30) / 30;
    if(position.y > standardPosition.y)
      position.y = standardPosition.y;
    r -= (stoneR - r + 30) / 30;
    if(r < standardR)
      r = standardR;
  }
}
