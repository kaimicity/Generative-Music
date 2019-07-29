
void drawInstruction(int opa) {
  stroke(normalStroke);
  noFill();
  strokeJoin(BEVEL);
  strokeWeight(panelStrokeWidth / 3);
  if (showInstruction && scrollCurrentY > 0) {
    scrollCurrentY -= min(instructionHeight / 80, scrollCurrentY);
  } else if (! showInstruction && scrollCurrentY < instructionHeight) {
    scrollCurrentY += min(instructionHeight / 80, instructionHeight - scrollCurrentY);
  }
  rect(instructionPosition.x, instructionPosition.y - scrollCurrentY, instructionWidth, instructionHeight);
  fill(normalStroke, opa);
  textAlign(LEFT, TOP);
  textFont(nameFont);
  textSize(20);
  if (!lightSwitch)
    text(instructions.getString(currentPanel + "-NOLIGHT"), instructionPosition.x + 10, instructionPosition.y - scrollCurrentY + 10, instructionWidth - 20, instructionHeight - 20);
  else
    text(instructions.getString(currentPanel), instructionPosition.x + 10, instructionPosition.y - scrollCurrentY + 10, instructionWidth - 20, instructionHeight - 20);

  fill(whiteColor);
  strokeWeight(panelStrokeWidth / 2);
  rect(scrollPosition.x, scrollPosition.y, scrollWidth, scrollHeight);
  line(scrollPosition.x + scrollWidth, instructionPosition.y, scrollPosition.x + scrollWidth, instructionPosition.y + height / 10);
  if (showInstruction)
    fill(normalStroke);
  else
    noFill();
  ellipse(scrollPosition.x + scrollWidth, instructionPosition.y + height / 10 + 7.5, 15, 15);
  noStroke();
  fill(whiteColor);
  rect(scrollPosition.x, 0, scrollWidth, scrollPosition.y);
}


void drawRoulette() {
  for (SoundTrack st : tracks) {
    st.draw();
  }
}

void drawPanel() {
  for (PanelButton pb : pbs) {
    if (pb.inButton()) {
      test = pb.index;
      break;
    } else
      test = -1 ;
  }
  noFill();
  mountEnterStroke(normalStroke, panelOpacity);
  strokeWeight(panelStrokeWidth / 2);
  ellipse(roulettePosition.x, roulettePosition.y, panelR * 2, panelR * 2);
  pushMatrix();
  translate(roulettePosition.x, roulettePosition.y);
  if (mousePressed && test != -1 && !enter && !back && !(test == 2 && !lightSwitch)) {
    fill(unbondSoundtrack);
    arc(0, 0, panelR * 2, panelR * 2, pbs.get(test).getStarting(), pbs.get(test).getStarting() + PI * 2 / 3);
  }
  if (!lightSwitch) {
    mountEnterFill(normalStroke, panelOpacity);
    arc(0, 0, panelR * 2, panelR * 2, pbs.get(2).getStarting(), pbs.get(2).getStarting() + PI * 2 / 3);
  }
  rotate(PI / 6);
  line(0, 0, panelR, 0);
  pbs.get(0).draw();
  rotate(PI / 3 * 2);
  line(0, 0, panelR, 0);
  pbs.get(1).draw();
  rotate(PI / 3 * 2);
  line(0, 0, panelR, 0);
  pbs.get(2).draw();
  popMatrix();
}

void drawTonality() {
  textAlign(RIGHT, CENTER);
  //textMode(SHAPE);
  textFont(nameFont);
  textSize(45);
  String tona = "MAJOR C";
  if (isMajor) {
    fill(normalStroke);
    tona = "MAJOR " + currentTonality.getName();
  } else {
    fill(normalStroke, 100);
    tona = "MINOR " + currentTonality.getName();
  }
  text(tona, tonalityPosition.x + tonalityWidth, tonalityPosition.y + tonalityHeight / 2);
  if (tonalityLocked) {
    noFill();
    stroke(normalStroke);
    strokeWeight(panelStrokeWidth / 2);
    rect(tonalityPosition.x, tonalityPosition.y, tonalityWidth, tonalityHeight);
  } else {
    fill(normalStroke, 100);
    noStroke();
    rect(tonalityPosition.x + tonalityWidth - textWidth(tona), tonalityPosition.y + tonalityHeight + 5, textWidth(tona), 2);
    fill(normalStroke);
    rect(tonalityPosition.x + tonalityWidth - textWidth(tona), tonalityPosition.y + tonalityHeight + 5, textWidth(tona) * (millis() - tonalityTimeStamp) / 120000, 2);
  }
}

boolean inTag1;
boolean inTag2;
boolean inButton1;
boolean inButton2;
boolean inBackButton;
boolean inFreezeButton;
boolean inTimeTag;
boolean inClin;
boolean inStart;
boolean inTonality;
boolean inTimer;

double lightValue;
boolean eraseFlag;
boolean lightSwitch;
int shakingCounter;
int coverTime;
boolean freezing;
double temprature;
boolean isMajor;
boolean tonalityLocked;
boolean tonalityFlag;
double mouseAngle;

void draw() {
  while (temprature == 0) {  
    try {
      indoorLight = lightSensor.getSensorValue();
      println(indoorLight);
      temprature = tempratureSensor.getSensorValue();
      println(temprature);
      if (indoorLight < 0.2)
        lightSwitch = false;
      else
        lightSwitch = true;
      if (temprature > 1.875)
        isMajor = false;
      else
        isMajor = true;
    } 
    catch(Exception e) {
      //println(e.toString());
      //indoorLight = -1;
    }
    tonalityTimeStamp = millis();
    resetTonality();
  }
  //if (!tonalityFlag) {
  //  tonalityTimeStamp = millis();
  //  resetTonality();
  //  tonalityFlag = true;
  //}
  if (!tonalityLocked && millis() - tonalityTimeStamp >= 120000) {
    resetTonality();
    tonalityTimeStamp = millis();
  }
  background(whiteColor);
  drawRoulette();
  drawTonality();
  inClin = inClinch();
  inBackButton = backButton.isFocused();
  inTonality = inTonality();
  switch(currentPanel) {
  case "NONE":
    if (bondedNumber < 5)
      drawPanel();
    drawInstruction(panelOpacity);
    inFreezeButton = freezeButton.isFocused();
    if (mousePressed && inFreezeButton && !lightSwitch) {
      freezing = true;
    } else {
      freezing = false;
    }
    if (!enter && !back) {
      try {
        lightValue = lightSensor.getSensorValue();
        if (indoorLight - lightValue > 0.03 && !freezing) {
          if (millis() - coverTime > 1000) {
            freezing = true;
            shakingCounter = 0;
          }
          if (eraseFlag) {
            shakingCounter ++;
            eraseFlag = false;
            if (shakingCounter > 1 && bondedNumber > 0)
              unbonding = true;
          }
        } else if (indoorLight - lightValue < 0.03) {
          coverTime = millis();
          eraseFlag = true;
          if (lightSwitch)
            freezing = false;
        }
      } 
      catch(Exception e) {
        //println(e.toString());
      }
    }
    if (!lightSwitch && bondedNumber > 0 && !enter) {
      clearAllButton.draw(panelOpacity);
      freezeButton.draw(panelOpacity);
    }
    if (unbonding) {
      trackOpacity -= 2;
      if (trackOpacity <= 0) {
        trackOpacity = 255;
        unbondAll();
        unbonding = false;
        bondedNumber = 0;
        toBond = 0;
        shakingCounter = 0;
      }
    }
    if (back && panelOpacity < 255) {
      cursor(ARROW);
      panelOpacity += 5;
      if (panelOpacity >= 255) {
        back = false;
      }
    } else if (test != -1 && bondedNumber < 5) {
      textAlign(CENTER, CENTER);
      textFont(nameFont);
      textSize(height / 15);
      fill(normalStroke);
      if (!enter && !back) {
        if (!(test == 2 && !lightSwitch))
          cursor(HAND);
        else
          cursor(ARROW);
        text(pbs.get(test).getName(), roulettePosition.x, height * 14 / 15);
      } else {
        cursor(ARROW);
        fill(normalStroke, panelOpacity);
        text(pbs.get(test).getName(), roulettePosition.x, height * 14 / 15);
        if (enter && panelOpacity > 0) {
          panelOpacity -= 5;
          if (panelOpacity <= 0)
            currentPanel = tempUi;
        }
      }
    } else if ((((inBackButton || inFreezeButton ) && !unbonding && !lightSwitch)) || inClin || inTonality)
      cursor(HAND);
    else
      cursor(ARROW);
    break;
  case "PERCUSSION":
    config();
    drawPercussion();
    inTag1 = lightTag.inTag();
    inTag2 = heavyTag.inTag();
    switch(dragging) {
    case 0:
      if (!enter && !back) {
        if (inTag1 || inTag2)
          cursor(MOVE);
        else if (inButton1 || inButton2 || inClin || (!lightSwitch && inBackButton) || inTonality)
          cursor(HAND);
        else 
        cursor(ARROW);
        if (inTag1 && mousePressed) {
          dragging = 1;
        } else if (inTag2 && mousePressed) {
          dragging = 2;
        }
      }
      break;
    case 1:
      int adjustedLow = (int)((mouseX - (roulettePosition.x - rouletteOutR + slideBarWidth)) * 100 / (rouletteOutR * 2) + 0.5 - 4);
      if (adjustedLow <= currentPercussion.getHighThreshold() && adjustedLow >= 0) {
        currentPercussion.setLowThreshold(adjustedLow);
        lightTag.setX(adjustedLow);
      }
      break;
    case 2:
      int adjustedHigh = (int)((mouseX - (roulettePosition.x - rouletteOutR + slideBarWidth)) * 100 / (rouletteOutR * 2) + 0.5 - 4);
      if (adjustedHigh <= 100 && adjustedHigh >= currentPercussion.getLowThreshold()) {
        currentPercussion.setHighThreshold(adjustedHigh);
        heavyTag.setX(adjustedHigh);
      }
      break;
    }
    break;
  case "PLUCK":
    config();
    drawPluck();
    inTimeTag = inTimeTag();
    inStart = inStart();
    if (dragging == 0) {
      if (!enter && !back) {
        if (inButton1 || inButton2 || inClin || (!started && inStart) || (!lightSwitch && inBackButton) || inTonality)
          cursor(HAND);
        else if (inTimeTag)
          cursor(MOVE);
        else 
        cursor(ARROW);
        if (inTimeTag && mousePressed) {
          dragging = 1;
        }
      }
    } else if (dragging == 1) {
      cursor(MOVE);
      timeTagX = (mouseX - (roulettePosition.x - timeBarWidth / 2) ) / timeBarWidth;
      if (timeTagX < 0)
        timeTagX = 0;
      if (timeTagX > 1)
        timeTagX = 1;
      if (timeTagX <= 0.75) {
        pluckInterval = thresholdInterval * timeTagX / 0.75;
      } else {
        pluckInterval = thresholdInterval + (timeTagX - 0.75) * (maxInterval - thresholdInterval) / 0.25;
      }
      pluckInterval = (float)((int)(pluckInterval * 100)) / 100;
    }
    break;
  case "ORCHE":
    config();
    drawOrche();
    inStart = inStart();
    inTimer = inTimer();
    if (dragging == 0) {
      if (!enter && !back) {
        if (inButton1 || inButton2 || inClin || inBackButton || inTonality)
          cursor(HAND);
        else if (inTimer)
          cursor(MOVE);
        else 
        cursor(ARROW);
        if (inTimer && mousePressed) {
          dragging = 1;
        }
      }
    } else if (dragging == 1) {
      cursor(MOVE);
      orcheInterval = normaliseAngle((float)mouseAngle + PI / 2) / 2 / PI * maxOrcheInterval;
      orcheInterval = (float)((int)(orcheInterval * 100)) / 100;
      if (orcheInterval < minOrcheInterval)
        orcheInterval = minOrcheInterval;
    }
    break;
  }
}
