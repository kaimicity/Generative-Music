void drawPercussion() {
  mountEnterFill(normalStroke, uiOpacity);
  textFont(percussionFont);
  textAlign(CENTER, CENTER);
  text(currentPercussion.getName(), instrumentPosition.x, instrumentPosition.y);
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
  if (millis() - lastReadTime >= 500) {
    noFill();
  } else if (lastVolumn >= currentPercussion.getHighThreshold()) {
    fill(percussionHeavy);
    if (!adding) {
      adding = true;
      Note note = new PercussionNote(currentTrack.getIndex(), false);
      currentTrack.addNote(note);
    }
  } else if (lastVolumn >= currentPercussion.getLowThreshold()) {
    fill(percussionLight);
    if (!adding) {
      adding = true;
      Note note = new PercussionNote(currentTrack.getIndex(), true);
      currentTrack.addNote(note);
    }
  }
  ellipse(stonePosition.x, stonePosition.y, stoneR * 2, stoneR * 2);
  pushMatrix();
  translate(stonePosition.x + height * 0.1, stonePosition.y);
  textAlign(CENTER, CENTER);
  textSize(secondaryInstrumentFontSize);
  mountEnterFill(secondaryInstrumentColor, uiOpacity);
  if (currentPercussionIndex + 1 < Database.percussionInstruments.size())
    text(Database.percussionInstruments.get(currentPercussionIndex + 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.percussionInstruments.get(0).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  translate(- height * 0.2, 0);
  if (currentPercussionIndex - 1 >= 0)
    text(Database.percussionInstruments.get(currentPercussionIndex - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  else
    text(Database.percussionInstruments.get(Database.percussionInstruments.size() - 1).getName(), 0, (instrumentPosition.y - stonePosition.y) * 0.7);
  popMatrix();
  drawSlideBar();
}


float lowLine;
float highLine;
int lastReadTime;
int lastValidTime;
double lastReadValue;
float lastVolumn;
void drawSlideBar() {
  try {
    double gsv = soundSensor.getSensorValue();
    if (!enter && ! back && millis() - lastReadTime >= 500 && gsv > 0.035 ) {
      lastReadTime = millis();
      lastReadValue = gsv;
      soundValue = (float)gsv - 0.03;
      if (soundValue > maxSound)
        soundValue = maxSound;
      adding = false;
    } else {
      if (soundValue > 0)
        soundValue -= 0.001;
    }
  } 
  catch( Exception e) {   
    System.out.println(e.toString());
  }
  pushMatrix();
  translate(roulettePosition.x - rouletteOutR, slideBarY);
  float currentVolumn = soundValue * 100 / maxSound;
  lastVolumn = currentVolumn;
  noStroke();
  fill(percussionIgnore);
  if (currentVolumn <= currentPercussion.getLowThreshold()) {
    quad(0, 0, slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth )* currentVolumn / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentVolumn / 100, 0);
  } else if ( currentVolumn <= currentPercussion.getHighThreshold()) {
    quad(0, 0, slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, 
      (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0);
    fill(percussionLight);
    quad( (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0, 
      (rouletteOutR * 2 - slideBarWidth ) * currentVolumn / 100, 0, (rouletteOutR * 2 - slideBarWidth )* currentVolumn / 100 + slideBarWidth, - slideBarWidth);
  } else {
    quad(0, 0, slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, 
      (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0);
    fill(percussionLight);
    quad( (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getLowThreshold() / 100, 0, 
      (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100, 0, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100 + slideBarWidth, - slideBarWidth);
    fill(percussionHeavy);
    quad( (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100, 0, (rouletteOutR * 2 - slideBarWidth ) * currentPercussion.getHighThreshold() / 100 + slideBarWidth, - slideBarWidth, 
      (rouletteOutR * 2 - slideBarWidth )* currentVolumn / 100 + slideBarWidth, - slideBarWidth, (rouletteOutR * 2 - slideBarWidth ) * currentVolumn / 100, 0);
  }
  fill(percussionIgnore);
  textAlign(LEFT, BOTTOM);
  textSize(height / 16);
  text("0", height / 15, 0); 
  strokeWeight(panelStrokeWidth / 2);
  stroke(percussionLight);
  lowLine = (rouletteOutR * 2 - slideBarWidth) * currentPercussion.getLowThreshold() / 100;
  line(lowLine, 0, lowLine + slideBarWidth, - slideBarWidth);
  fill(percussionLight);
  text(currentPercussion.getLowThreshold(), lowLine + height / 15, 0); 
  stroke(percussionHeavy);
  highLine = (rouletteOutR * 2 - slideBarWidth) * currentPercussion.getHighThreshold() / 100;
  line(highLine, 0, highLine + slideBarWidth, - slideBarWidth);
  fill(percussionHeavy);
  text(currentPercussion.getHighThreshold(), highLine + height / 15, 0); 
  fill(normalStroke);
  text("100", rouletteOutR * 2 - slideBarWidth + height / 15, 0);
  stroke(unbondSoundtrack);
  strokeWeight(panelStrokeWidth);
  noFill();
  quad(0, 0, slideBarWidth, - slideBarWidth, rouletteOutR * 2, - slideBarWidth, rouletteOutR * 2 - slideBarWidth, 0);
  popMatrix();
  ignoreTag.draw();
  lightTag.draw();
  heavyTag.draw();
}
