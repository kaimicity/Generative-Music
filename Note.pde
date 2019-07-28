abstract class Note {
  AudioPlayer audio;
  float speed;
  int trackIndex;
  PVector position;
  float resetSpeed = PI / 50;
  float myangle;
  float target;
  float r;
  int timePoint;
  float standardR = rouletteInR / 15;
  PVector standardPosition;
  color myColor;
  String status;
  String type;
  int direction;

  void setTarget(float tar) {
    this.target = normaliseAngle(tar);
  }

  void setTimePoint(int tp) {
    this.timePoint = tp;
  }

  void setSpeed(float newSpeed) {
    this.speed = newSpeed;
  }

  void setStatus(String newStatus) {
    this.status = newStatus;
  }

  void setDirection(int dire) {
    this.direction = dire;
  }

  int getTimePoint() {
    return timePoint;
  }

  boolean isWaiting() {
    if (status.equals("WAITING"))
      return true;
    else
      return false;
  }

  void play() {
    if(currentPanel.equals("PERCUSSION")){
      audio.setGain( - 20);
    } else{
      audio.setGain(0);
    }
    audio.rewind();
    audio.play();
  }
  
  
  void draw() {
    //if(this.type.equals("ORCHE") && ((OrcheNote)this).isEnd){
    //  noFill();
    //}else{
    fill(myColor, trackOpacity);
    noStroke();
    switch(status) {
    case "BIRTH":
      eject();
      ellipse(position.x, position.y, r * 2, r * 2);
      break;
    case "WAITING":
      pushMatrix();
      translate(roulettePosition.x, roulettePosition.y);
      crowd();
      rotate(myangle);
      ellipse(position.x, position.y, r * 2, r * 2);
      popMatrix();
      break;
    case "RUN":
      run();
      if(collided()){
        play();
        tracks.get(trackIndex).getLabel().direct();      }
      pushMatrix();
      translate(roulettePosition.x, roulettePosition.y);
      rotate(myangle);
      ellipse(position.x, position.y, r * 2, r * 2);
      popMatrix();
      break;
    }
  }

  void eject() {
    position.x += (standardPosition.x - stonePosition.x) / 40;
    if (position.x > standardPosition.x)
      position.x = standardPosition.x;
    position.y -= (position.y - stonePosition.y + 50) / 50;
    if (position.y > standardPosition.y)
      position.y = standardPosition.y;
    r -= (stoneR - r + 30) / 30;
    if (r < standardR)
      r = standardR;
    if (position.x == standardPosition.x && position.y == standardPosition.y && r == standardR) {
      position.x = rouletteInR + trackIndex * interval;
      position.y = 0;
      status = "WAITING";
    }
  }

  void crowd() {
    if (myangle < target)
      myangle += resetSpeed;
    if (myangle > target)
      myangle = target;
  }

  void run() {
    this.myangle += direction * speed;
    myangle = normaliseAngle(myangle);
  }
  
  boolean collided(){
    float lowBorder = normaliseAngle(tracks.get(trackIndex).getLabel().getAngle() - tracks.get(trackIndex).getLabel().getLength() / 2);
    float highBorder = normaliseAngle(tracks.get(trackIndex).getLabel().getAngle() + tracks.get(trackIndex).getLabel().getLength() / 2);
    //if((myangle >= min(lowBorder, highBorder) && myangle <= max(lowBorder, highBorder)) || (myangle >= max(lowBorder, highBorder) && myangle <= min(lowBorder, highBorder))){
      if((direction == 1 && abs(myangle - lowBorder) <= (speed + tracks.get(trackIndex).getLabel().getSpeed()) / 2) || (direction == -1 && abs(myangle - highBorder) <= (speed + tracks.get(trackIndex).getLabel().getSpeed()) / 2)){
    //println(highBorder / PI + " " + lowBorder / PI + " " + myangle / PI);
      //this.status = "TEST";
      //tracks.get(trackIndex).getLabel().stopWalking();
      return true;
    }
    return false;  
  }
}
