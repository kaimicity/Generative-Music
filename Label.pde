class Label{
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
  boolean frozen;
  float labelSize;
  color textColor = color(0, 0, 0);
  boolean walking;
  
  Label(int i, Instrument instrument){
    this.index = i;
    this.r = rouletteInR + i * interval;
    this.labelSize = r / (instrument.getName().length() * 2);
    this.labelWidth = rouletteInR / 15;
    direct();
    this.frozen = false;
    this.instrument = instrument;
    this.labelLength = PI / 12 * textWidth(instrument.getName()) / 60;
    this.speed = PI / 480;
    this.labelAngle = - PI / 2 + labelLength / 2;
    walking = false;
  }
  
  void setInstrument(Instrument ins){
    this.instrument = ins;
  }
  
  void direct(){
    double mark = Math.random();
    if( mark < 0.5){
      direction = 1;
    } else{
      direction = - 1;
    }
  }
  
  void draw(){
    pushMatrix();
    translate(center.x, center.y);
    mountEnterFill(labelColor, uiOpacity);
    mountEnterStroke(strokeColor, uiOpacity);
    beginShape();
    vertex((r - labelWidth) * cos(labelAngle), (r - labelWidth) * sin(labelAngle));
    vertex((r + labelWidth) * cos(labelAngle), (r + labelWidth) * sin(labelAngle));
    for(float i = 0; i < labelLength; i+= 0.1){
      vertex((r + labelWidth) * cos(labelAngle - i), (r + labelWidth) * sin(labelAngle - i));  
    }
    vertex((r + labelWidth) * cos(labelAngle-labelLength), (r + labelWidth) * sin(labelAngle-labelLength));
    vertex((r - labelWidth) * cos(labelAngle-labelLength), (r - labelWidth) * sin(labelAngle-labelLength));
    for(float i = 0; i < labelLength; i+= 0.1){
      vertex((r - labelWidth) * cos(labelAngle - labelLength + i), (r - labelWidth) * sin(labelAngle - labelLength + i));  
    }
    endShape(CLOSE);
    translate(r * cos(labelAngle-labelLength / 2), r * sin(labelAngle-labelLength / 2));
    rotate(labelAngle-labelLength / 2 + PI / 2);
    mountEnterFill(textColor, uiOpacity);
    textAlign(CENTER, CENTER);
    textFont(instrument.getMyFont());
    textSize(labelSize);
    text(instrument.getName(), 0, 0);
    popMatrix();
    if(walking)
      walk();
  }
  
  void walk(){
    if(!frozen)
      this.labelAngle += direction * speed;
    if(labelAngle >= 2 * PI)
      labelAngle -= 2 * PI;
  }
}
