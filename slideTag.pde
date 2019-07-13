class SlideTag {
  PVector position;
  String content;
  boolean draggable;
  float myHeight = height / 15;
  float myWidth;
  color myColor;

  SlideTag(int x, String content, boolean draggable, color mc) {
    this.content = content;
    this.draggable = draggable;
    this.position = new PVector( (rouletteOutR * 2  - slideBarWidth) * x / 100 + slideBarWidth, - slideBarWidth - myHeight);
    myWidth = rouletteOutR * 2;
    this.myColor = mc;
  }

  void setContent(String newCon) {
    this.content = newCon;
  }

  void setX(int x) {
    this.position.x = (rouletteOutR * 2  - slideBarWidth) * x / 100 + slideBarWidth;
  }
  void draw() {
    pushMatrix();
    translate(roulettePosition.x - rouletteOutR, slideBarY);
    fill(whiteColor);
    noStroke();
    quad(position.x + myHeight, position.y, position.x, position.y + myHeight, position.x + myWidth, position.y + myHeight, position.x + myWidth + myHeight, position.y);
    stroke(myColor);
    fill(myColor);
    strokeWeight(panelStrokeWidth / 2);
    strokeCap(SQUARE);
    line(position.x + myHeight, position.y, position.x  + myHeight / 5, position.y + myHeight * 4 / 5);
    line(rouletteOutR * 2, position.y + myHeight * 4 / 5, position.x  + myHeight / 5, position.y + myHeight * 4 / 5);
    textAlign(LEFT, BOTTOM);
    textSize(myHeight  / 2);
    text(content, position.x + myHeight, position.y + myHeight * 4 / 5);
    if (draggable) {
      translate(position.x + myHeight * 7 / 6, position.y - myHeight / 6);
      fill(whiteColor);
      rect( - myHeight / 3, 0, myHeight / 3, myHeight / 3);
    }
    popMatrix();
  }

  boolean inTag() {
    float relativeX = mouseX - (roulettePosition.x - rouletteOutR) - (position.x + myHeight * 7 / 6);
    float relativeY = mouseY - slideBarY - (position.y - myHeight / 6);
    if (relativeX < 0 && relativeX > - myHeight / 3 && relativeY < myHeight / 3 && relativeY > 0) {
      return true;
    }
    return false;
  }
}
