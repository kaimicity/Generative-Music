class PanelButton {
  PVector position = roulettePosition;
  int r = panelR;
  int picturePosition = panelR * 7 / 12;
  int myHeight = panelR / 2;
  int myWidth = panelR / 2;
  float recWidth = myWidth / 5;
  String name;
  int index;
  float buttonWidth =PI * 2 / 3 ;
  float starting;
  color myColor = color(0, 0, 0);

  PanelButton(int index) {
    this.index = index;
    this.starting = PI / 6 + index * buttonWidth;
    this.name = Database.typesOfInstruments[index];
  }

  int getIndex() {
    return this.index;
  }

  String getName() {
    return this.name;
  }

  float getStarting() {
    return this.starting;
  }

  void setColor(color c){
    myColor = c;
  }
  
  boolean inButton() {
    float dis = getDistance(mouseX, mouseY, position.x, position.y);
    if ( dis < panelR) {
      float xOffset = mouseX - position.x;
      float yOffset = mouseY - position.y;
      float angle = acos(xOffset / dis);
      if ( yOffset < 0)
        angle = 2 * PI - angle;
      if ((angle > starting && angle < starting + buttonWidth) || (angle < PI / 6 && index == 2)) {
        return true;
      } else
        return false;
    }
    return false;
  }

  void draw() {
    pushMatrix();
    rotate(PI / 3);
    switch(index) {
    case 0:
      translate(picturePosition * 0.8, 0);
      noFill();
      ellipse(0, 0, myWidth, myHeight);
      rotate(PI / 6);
      mountEnterFill(myColor, panelOpacity);
      ellipse(myWidth / 4, 0, myWidth / 6, myWidth / 6);
      line(myWidth / 4, 0, myWidth / 4 * 3, 0);
      rotate(- PI / 3);
      ellipse(myWidth / 4, 0, myWidth / 6, myWidth / 6);
      line(myWidth / 4, 0, myWidth / 4 * 3, 0);
      break;
    case 1:
      translate(picturePosition, 0);
      noFill();
      scale(0.75, 1.25);
      for (int i = 0; i < 5; i++) {
        if (i % 2 == 0)
          noFill();
        else
          mountEnterFill(myColor, panelOpacity);
        rect( - myWidth / 2, - myHeight / 2 + i * recWidth, myWidth, recWidth);
      }
      break;
    case 2:
      if (!lightSwitch) {
        name = "Can Only Work in Lighter Place";
        stroke(whiteColor);
      }
      translate(picturePosition, 0);
      scale(1, 0.8);
      line( myWidth / 2, - myHeight * 2 / 3, myWidth / 2, myHeight / 3);
      line( - myWidth / 2, - myHeight * 2 / 3, - myWidth / 2, myHeight / 3);
      line( myWidth / 2, - myHeight * 5 / 12, - myWidth / 2, - myHeight * 5 / 12);
      line( myWidth / 2, - myHeight * 2 / 12, - myWidth / 2, - myHeight * 2 / 12);
      line( myWidth / 2, myHeight * 1 / 12, - myWidth / 2, myHeight * 1 / 12);
      rotate( PI / 3);
      translate(myWidth * 2 / 3, - myHeight / 6);
      line( 0, 0, 0, myWidth);
      line(0, 0, 7, 7);
      curve(0, 0, 7, 7, 7, myWidth - 7, 0, myWidth);
      line(7, myWidth - 7, 0, myWidth);
      break;
    }
    noFill();
    popMatrix();
  }
}
