void drawOrche(){
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

void drawNoteBars(){
  //stroke(normalStroke);
  //fill(normalStroke);
  //rect(noteBarAreaPosition.x, noteBarAreaPosition.y, noteBarAreaWidth, noteBarAreaHeight);
  strokeCap(ROUND);
  for(int i = 0; i < natureSyllables.size(); i ++){
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

void drawTheBall(){
  mountEnterFill(normalStroke, uiOpacity);
  ellipse(noteBarAreaPosition.x - 40 + 15, noteBarAreaPosition.y + noteBarAreaHeight + 40 - 5 - 2, 10, 10);
}

void drawOrcheTimer(){
  mountEnterStroke(normalStroke, uiOpacity);
  strokeWeight(2);
  noFill();
  ellipse(orcheTimerPosition.x, orcheTimerPosition.y, orcheTimerR * 2, orcheTimerR * 2);
  fill(whiteColor);
  ellipse(orcheTimerPosition.x, orcheTimerPosition.y, orcheTimerR * 4 / 3, orcheTimerR * 4 / 3);
  pushMatrix();
  mountEnterFill(normalStroke, uiOpacity);
  translate(orcheTimerPosition.x, orcheTimerPosition.y);
  line(0, 0, 0, - orcheTimerR);
  popMatrix();
}
