class Label {
  int index;
  int r;
  PVector center = roulettePosition;
  Instrument instrument;
  int labelWidth ;
  float labelLength;
  color strokeColor = color(0, 0, 0);
  color labelColor = color(255, 255, 255);
  float labelAngle;
  int direction;
  float speed;
  float maxSpeed;
  boolean frozen;
  float labelSize;
  color textColor = color(0, 0, 0);
  boolean walking;
  boolean creating;

  Label(int i, Instrument instrument) {
    this.index = i;
    this.r = rouletteInR + i * interval;
    this.labelSize = r / (instrument.getName().length() * 2);
    this.labelWidth = rouletteInR / 15;
    this.frozen = false;
    this.instrument = instrument;
    this.labelLength = PI / 12 * textWidth(instrument.getName()) / 60;
    this.labelAngle =  PI * 3 / 2 + labelLength / 2;
    creating = true;
    walking = false;
    direct();
  }

  void setInstrument(Instrument ins) {
    this.instrument = ins;
  }

  void setCreating(boolean c) {
    this.creating = c;
  }

  void setSpeed(float newSpeed) {
    this.speed = newSpeed;
    this.maxSpeed = newSpeed;
  }
  void direct() {
    double mark = Math.random();
    if ( mark < 0.5) {
      direction = 1;
    } else {
      direction = - 1;
    }
  }

  float getAngle() {
    return this.labelAngle - labelLength / 2;
  }

  float getLength() {
    return this.labelLength;
  }

  float getSpeed() {
    return this.speed;
  }

  void startWalking() {
    this.walking = true;
  }

  void stopWalking() {
    this.walking = false;
  } 

  void draw() {
    pushMatrix();
    translate(center.x, center.y);
    if (creating && (enter || back)) {
      fill(labelColor, uiOpacity);
      stroke(strokeColor, uiOpacity);
    } else {
      fill(labelColor, trackOpacity);
      stroke(strokeColor, trackOpacity);
    }
    beginShape();
    vertex((r - labelWidth) * cos(labelAngle), (r - labelWidth) * sin(labelAngle));
    vertex((r + labelWidth) * cos(labelAngle), (r + labelWidth) * sin(labelAngle));
    for (float i = 0; i < labelLength; i+= 0.1) {
      vertex((r + labelWidth) * cos(labelAngle - i), (r + labelWidth) * sin(labelAngle - i));
    }
    vertex((r + labelWidth) * cos(labelAngle-labelLength), (r + labelWidth) * sin(labelAngle-labelLength));
    vertex((r - labelWidth) * cos(labelAngle-labelLength), (r - labelWidth) * sin(labelAngle-labelLength));
    for (float i = 0; i < labelLength; i+= 0.1) {
      vertex((r - labelWidth) * cos(labelAngle - labelLength + i), (r - labelWidth) * sin(labelAngle - labelLength + i));
    }
    endShape(CLOSE);
    translate(r * cos(labelAngle-labelLength / 2), r * sin(labelAngle-labelLength / 2));
    rotate(labelAngle-labelLength / 2 + PI / 2);
    if (creating && (enter || back))
      fill(textColor, uiOpacity);
    else
      fill(textColor, trackOpacity);
    textAlign(CENTER, CENTER);
    textFont(instrument.getMyFont());
    textSize(labelSize);
    text(instrument.getName(), 0, 0);
    popMatrix();
    if (walking)
      walk();
  }

  void walk() {
    if (!freezing) {
      if (speed < maxSpeed) {
        speed = min(speed + maxSpeed / 50, maxSpeed);
      }
    } else{
      println(speed);
      if ( speed > 0){
        speed = max( speed - maxSpeed / 50, 0);
      }
    }
    this.labelAngle += direction * speed;
    labelAngle = normaliseAngle(labelAngle);
  }
}
