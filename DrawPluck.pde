
boolean started;
float maxStartR;
float startR;
int lastPluckTime;
float currentPluckAngle;
Syllable currentSyllable;
void drawPluck() {
  try {
    rotationValue = (float)rotationSensor.getSensorValue();
  } 
  catch(Exception e) {
    //println(e);
  }
  currentPluckAngle = PI + (PI - knobAngle) / 2 + knobAngle * rotationValue;
  mountEnterFill(normalStroke, uiOpacity);
  textFont(pluckFont);
  textAlign(CENTER, CENTER);
  text(currentPluck.getName(), instrumentPosition.x, instrumentPosition.y);
  fill(normalStroke, Math.abs(arrowTik - 255));
  tw = textWidth(currentPercussion.getName());
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
  if (currentPluckIndex + 1 < Database.pluckInstruments.size())
    text(Database.pluckInstruments.get(currentPluckIndex + 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.pluckInstruments.get(0).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  translate(- height * 0.2, 0);
  if (currentPluckIndex - 1 >= 0)
    text(Database.pluckInstruments.get(currentPluckIndex - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.pluckInstruments.get(Database.pluckInstruments.size() - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  popMatrix();
  drawKnob();
  drawTimeBar();
  drawStart();
  if (millis() - lastPluckTime >= pluckInterval * 1000 && started)
    generatePluckNote();
}

void drawKnob() {
  mountEnterFill(0, uiOpacity);
  ellipse(knobPosition.x, knobPosition.y, 800, 800);
  for (int i = 0; i < natureSyllables.size(); i++) {
    mountEnterFill(natureSyllables.get(i).getColor(), uiOpacity);
    if ((currentPluckAngle > knobAngleStart + i * knobAngle / 8) && currentPluckAngle < knobAngleStart + (i + 1) * knobAngle / 8) {
      strokeWeight(panelStrokeWidth * 2 / 3);
      mountEnterStroke(whiteColor, uiOpacity);
      currentSyllable = natureSyllables.get(i);
    } else 
    noStroke();
    arc(knobPosition.x, knobPosition.y, 800, 800, knobAngleStart + i * knobAngle / 8, knobAngleStart + (i + 1) * knobAngle / 8, PIE);
  } 
  if (currentPluckAngle < knobAngleStart || currentPluckAngle > knobAngleStart + 7 * knobAngle / 8)
    currentSyllable = null;
  fill(255);
  noStroke();
  ellipse(knobPosition.x, knobPosition.y, 894.8, 700);
  pushMatrix();
  translate(knobPosition.x, knobPosition.y);
  rotate(currentPluckAngle);
  fill(whiteColor);
  noStroke();
  ellipse(390, 0, 10, 10);
  popMatrix();
}

void drawTimeBar() {
  strokeWeight(panelStrokeWidth / 2);
  noFill();
  mountEnterStroke(secondaryInstrumentColor, uiOpacity);
  //rect(roulettePosition.x - timeBarWidth / 2, height + 15 -  timeBarHeight / 2, timeBarWidth * 3 / 4, timeBarHeight);
  line(roulettePosition.x - timeBarWidth / 2, height + 15 -  timeBarHeight / 2, roulettePosition.x - timeBarWidth / 2, height + 15 +  timeBarHeight / 2);
  line(roulettePosition.x - timeBarWidth / 2, height + 15 -  timeBarHeight / 2, roulettePosition.x + timeBarWidth / 4, height + 15 -  timeBarHeight / 2);
  line(roulettePosition.x - timeBarWidth / 2, height + 15 +  timeBarHeight / 2, roulettePosition.x + timeBarWidth / 4, height + 15 +  timeBarHeight / 2);
  mountEnterStroke(normalStroke, uiOpacity);
  line(roulettePosition.x + timeBarWidth / 4, height + 15 -  timeBarHeight / 2, roulettePosition.x + timeBarWidth / 2, height + 15 -  timeBarHeight / 2);
  line(roulettePosition.x + timeBarWidth / 4, height + 15 +  timeBarHeight / 2, roulettePosition.x + timeBarWidth / 2, height + 15 +  timeBarHeight / 2);
  line(roulettePosition.x + timeBarWidth / 2, height + 15 -  timeBarHeight / 2, roulettePosition.x + timeBarWidth / 2, height + 15 +  timeBarHeight / 2);
  if (started) {
    fill(normalStroke);
    noStroke();
    int fillWidth = millis() - lastPluckTime;
    if ( fillWidth < thresholdInterval * 1000)
      rect(roulettePosition.x - timeBarWidth / 2, height + 15 -  timeBarHeight / 2, fillWidth * timeBarWidth * 0.75  / (thresholdInterval * 1000), timeBarHeight);
    else
      rect(roulettePosition.x - timeBarWidth / 2, height + 15 -  timeBarHeight / 2, timeBarWidth * 0.75 + (fillWidth - thresholdInterval * 1000 ) * timeBarWidth * 0.25  / ((maxInterval - thresholdInterval) * 1000), timeBarHeight);
  }
  mountEnterFill(normalStroke, uiOpacity);
  ellipse(roulettePosition.x - timeBarWidth / 2 + timeBarWidth * timeTagX, height + 15, timeBarHeight / 2, timeBarHeight / 2);
  line(roulettePosition.x - timeBarWidth / 2 + timeBarWidth * timeTagX, height + 15 - timeBarHeight / 2, roulettePosition.x - timeBarWidth / 2 + timeBarWidth * timeTagX, height + 15 + timeBarHeight / 2);
  fill(normalStroke, 50);
  noStroke();
  ellipse(roulettePosition.x - timeBarWidth / 2 + timeBarWidth * 0.75, height + 15, timeBarHeight / 2, timeBarHeight / 2);
  textSize(15);
  textAlign(RIGHT, CENTER);
  text("0s", roulettePosition.x - timeBarWidth / 2 - 3, height + 12);
  textAlign(LEFT, CENTER);
  text(thresholdInterval + "s", roulettePosition.x - timeBarWidth / 2 + timeBarWidth * 0.75 + timeBarHeight / 2, height + 12);
  text(maxInterval + "s", roulettePosition.x + timeBarWidth / 2 + 3, height + 12);
  mountEnterFill(normalStroke, uiOpacity);
  textSize(30);
  textAlign(CENTER, BOTTOM);
  text(pluckInterval + "s", roulettePosition.x, height + 12 -  timeBarHeight / 2);
}


void drawStart() {
  if (started && startR > 0) {
    startR = max(startR - stoneR / 30, 0);
  } else if (!started)
    startR = stoneR;
  noStroke();
  mountEnterFill(normalStroke, uiOpacity);
  ellipse(stonePosition.x, stonePosition.y, startR * 2, startR * 2);
  fill(whiteColor);
  textAlign(CENTER, CENTER);
  text("START", stonePosition.x, stonePosition.y - 2);
}

boolean inTimeTag() {
  if (getDistance(mouseX, mouseY, roulettePosition.x - timeBarWidth / 2 + timeBarWidth * timeTagX, height + 15) <= timeBarHeight / 2) {
    return true;
  }
  return false;
}

boolean inStart() {
  if (getDistance(mouseX, mouseY, stonePosition.x, stonePosition.y) <= stoneR && !started)
    return true;
  else
    return false;
}

void pluckStart() {
  lastPluckTime = millis();
  started = true;
}

void generatePluckNote() {
  lastPluckTime = millis();
  if (currentSyllable != null) {
    Note note = new PluckNote(currentTrack.getIndex(), currentSyllable.getName());
    currentTrack.addNote(note);
  }
}
