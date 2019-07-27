void drawOrche() {
  mouseAngle = acos((mouseX - orcheTimerPosition.x) / getDistance(mouseX, mouseY, orcheTimerPosition.x, orcheTimerPosition.y));
  if (mouseY < orcheTimerPosition.y)
    mouseAngle = PI * 2 - mouseAngle;
  mountEnterFill(normalStroke, uiOpacity);
  textFont(orcheFont);
  textAlign(CENTER, CENTER);
  text(currentOrche.getName(), instrumentPosition.x, instrumentPosition.y);
  fill(normalStroke, Math.abs(arrowTik - 255));
  tw = textWidth(currentPercussion.getName());
  textFont(pluckFont);
  text("<", instrumentPosition.x - tw / 1.3, instrumentPosition.y + 3);
  text(">", instrumentPosition.x + tw / 1.3, instrumentPosition.y + 3);
  if (arrowTik < 255 * 2)
    arrowTik += 5;
  else
    arrowTik = 0;
  noFill();
  mountEnterStroke(normalStroke, uiOpacity);
  ellipse(stonePosition.x, stonePosition.y, stoneR * 2, stoneR * 2);
  pushMatrix();
  translate(stonePosition.x + height * 0.1, stonePosition.y);
  textAlign(CENTER, CENTER);
  textSize(secondaryInstrumentFontSize);
  mountEnterFill(secondaryInstrumentColor, uiOpacity);
  if (currentOrcheIndex + 1 < Database.orcheInstruments.size())
    text(Database.orcheInstruments.get(currentOrcheIndex + 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.orcheInstruments.get(0).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  translate(- height * 0.2, 0);
  if (currentOrcheIndex - 1 >= 0)
    text(Database.orcheInstruments.get(currentOrcheIndex - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.orcheInstruments.get(Database.orcheInstruments.size() - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  popMatrix();
  drawNoteBars();
  drawOrcheTimer();
}

void drawNoteBars() {
  //stroke(normalStroke);
  //fill(normalStroke);
  //rect(noteBarAreaPosition.x, noteBarAreaPosition.y, noteBarAreaWidth, noteBarAreaHeight);
  strokeCap(ROUND);
  for (int i = 0; i < natureSyllables.size(); i ++) {
    noStroke();
    mountEnterFill(natureSyllables.get(i).getColor(), uiOpacity);
    rect( noteBarAreaPosition.x + i * noteBarAreaWidth / 7, noteBarAreaPosition.y + noteBarAreaHeight - (i + 1) * noteBarAreaHeight / 7, 30, (i + 1) * noteBarAreaHeight / 7 + 40);
  }
  noFill();
  mountEnterStroke(normalStroke, uiOpacity);
  strokeWeight(2);
  rect(noteBarAreaPosition.x - 40, noteBarAreaPosition.y + noteBarAreaHeight, 30, 40); 
  drawTheBall();
}

void drawTheBall() {
  mountEnterFill(normalStroke, uiOpacity);
  ellipse(noteBarAreaPosition.x - 40 + 15, noteBarAreaPosition.y + noteBarAreaHeight + 40 - 5 - 2, 10, 10);
}

void drawOrcheTimer() {
  fill(normalStroke);
  noStroke();
  arc(orcheTimerPosition.x, orcheTimerPosition.y, orcheTimerR * 2, orcheTimerR * 2, - PI / 2 + PI * 2 * orcheInterval / maxOrcheInterval, PI * 3 / 2);
  mountEnterStroke(normalStroke, uiOpacity);
  strokeWeight(2);
  strokeJoin(ROUND);
  noFill();
  ellipse(orcheTimerPosition.x, orcheTimerPosition.y, orcheTimerR * 2, orcheTimerR * 2);
  ellipse(orcheTimerPosition.x, orcheTimerPosition.y, orcheTimerR * 2 + 8, orcheTimerR * 2 + 8);
  pushMatrix();
  mountEnterFill(normalStroke, uiOpacity);
  translate(orcheTimerPosition.x, orcheTimerPosition.y);
  line(0, 0, 0, - orcheTimerR);
  noFill();
  rect(- 4, - orcheTimerR - 12, 8, 8);
  rotate(- PI / 2 + PI * 2 * orcheInterval / maxOrcheInterval);
  stroke(normalStroke, 100);
  line(0, 0, orcheTimerR, 0);
  textAlign(CENTER, TOP);
  if (orcheInterval < maxOrcheInterval / 2) {
    fill(whiteColor);
    text(orcheInterval + "s", orcheTimerR / 2, 0);
  } else {
    fill(normalStroke, 100);
    translate(orcheTimerR / 2, 0);
    rotate(PI);
    text(orcheInterval + "s", 0, 0);
  }
  //triangle(0, 0,  - orcheTimerR / 2, - orcheTimerR, orcheTimerR / 2, - orcheTimerR);
  //triangle(0, 0,  - orcheTimerR / 2, orcheTimerR, orcheTimerR / 2, orcheTimerR);
  //line(- orcheTimerR * 2 / 3, - orcheTimerR, orcheTimerR * 2 / 3, - orcheTimerR);
  //line(- orcheTimerR * 2 / 3, orcheTimerR, orcheTimerR * 2 / 3, orcheTimerR);
  popMatrix();
}

boolean inTimer() {
  boolean angleDete = mouseAngle > normaliseAngle(PI * 3 / 2 + PI * 2 * orcheInterval / maxOrcheInterval) && mouseAngle < normaliseAngle(PI * 3 / 2 + PI * 2 * orcheInterval / maxOrcheInterval + PI / 10);
  if (angleDete && getDistance(mouseX, mouseY, orcheTimerPosition.x, orcheTimerPosition.y) <= orcheTimerR)
    return true;
  else
    return false;
}

void drawNoteArc(color c){
  noStroke();
  fill(c);
  arc(orcheTimerPosition.x, orcheTimerPosition.y, orcheTimerR * 2, orcheTimerR * 2, - PI / 2, - PI / 2 + PI * 2 * orcheInterval / maxOrcheInterval);
}
