
void startBack() {
  if (currentTrack.getNoteNumber() == 0) {
    currentTrack.getLabel().setCreating(true);
    bondedNumber --;
  } 
  back = true;
}

void back() {
  uiOpacity -= 5;
  if (uiOpacity <= 0) {
    currentPanel = "NONE";
    if (currentTrack.getNoteNumber() == 0) {
      currentTrack.unbond();
      toBond = currentTrack.getIndex();
    } else {
      currentTrack.activate();
    }
  }
}


void config() {
  if (enter) {
    uiOpacity +=5;
    if (uiOpacity >= 255) {
      enter = false;
      currentTrack.getLabel().setCreating(false);
    }
  } 
  if (back) {
    back();
  }
  drawInstruction(uiOpacity);
  if (!enter && !back && !currentPanel.equals("ORCHE")) {
    try {
      lightValue = lightSensor.getSensorValue();
      if (indoorLight - lightValue > 0.03 && currentTrack.allNotesReady()) {
        startBack();
      }
    } 
    catch(Exception e) {
      //println(e.toString());
    }
  }
  if (!lightSwitch || currentPanel.equals("ORCHE"))
    backButton.draw(uiOpacity);
  inButton1 = inLeftSwitchButton();
  inButton2 = inRightSwitchButton();
}
