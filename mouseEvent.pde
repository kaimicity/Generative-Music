String tempUi;
void mouseReleased() {
  if (inClinch()) {
    showInstruction = !showInstruction;
  }
  if (inTonality()) {
    if (!tonalityLocked) {
      tonalityLocked = true;
    } else {
      tonalityLocked = false;
      tonalityTimeStamp = millis();
    }
  }

  switch(currentPanel) {
  case "NONE":
    if (test != -1 && !unbonding) {
      enter = true;
      tempUi = Database.buttonMark[test];
      currentTrack = tracks.get(toBond);
      currentTrack.bond(currentInstruments.get(test));
      bondedNumber ++;
      started = false;
      for (SoundTrack st : tracks) {
        if (!st.isBonded()) {
          toBond = st.getIndex();
          break;
        }
      }
    } else if (clearAllButton.isFocused() && !enter && ! back && !lightSwitch) {
      unbonding = true;
    }
    break;
  case "PERCUSSION":
    if (dragging!=0) {
      cursor(ARROW);
      dragging = 0;
    } else if (!enter && !back && inButton1) {
      if (currentPercussionIndex - 1 >= 0)
        currentPercussionIndex --;
      else
        currentPercussionIndex = Database.percussionInstruments.size() - 1;
      currentPercussion = Database.percussionInstruments.get(currentPercussionIndex);
      currentTrack.setInstrument(currentPercussion);
      tagsReset();
    } else if (!enter && !back && inButton2) {
      if (currentPercussionIndex + 1 <= Database.percussionInstruments.size() - 1)
        currentPercussionIndex ++;
      else
        currentPercussionIndex = 0;
      currentPercussion = Database.percussionInstruments.get(currentPercussionIndex);
      currentTrack.setInstrument(currentPercussion);
      tagsReset();
    } else if (inBackButton) {
      startBack();
    }
    break;
  case "PLUCK":
    if (dragging!=0) {
      cursor(ARROW);
      dragging = 0;
    } else if (!enter && !back && inButton1) {
      if (currentPluckIndex - 1 >= 0)
        currentPluckIndex --;
      else
        currentPluckIndex = Database.pluckInstruments.size() - 1;
      currentPluck = Database.pluckInstruments.get(currentPluckIndex);
      currentTrack.setInstrument(currentPluck);
    } else if (!enter && !back && inButton2) {
      if (currentPluckIndex + 1 <= Database.pluckInstruments.size() - 1)
        currentPluckIndex ++;
      else
        currentPluckIndex = 0;
      currentPluck = Database.pluckInstruments.get(currentPluckIndex);
      currentTrack.setInstrument(currentPluck);
    } else if (inBackButton) {
      startBack();
    } else if (inStart) {
      pluckStart();
    }
    break;
  case "ORCHE":
    if (!enter && !back && inButton1) {
      if (currentPluckIndex - 1 >= 0)
        currentPluckIndex --;
      else
        currentPluckIndex = Database.pluckInstruments.size() - 1;
      currentPluck = Database.pluckInstruments.get(currentPluckIndex);
      currentTrack.setInstrument(currentPluck);
    } else if (!enter && !back && inButton2) {
      if (currentPluckIndex + 1 <= Database.pluckInstruments.size() - 1)
        currentPluckIndex ++;
      else
        currentPluckIndex = 0;
      currentPluck = Database.pluckInstruments.get(currentPluckIndex);
      currentTrack.setInstrument(currentPluck);
    } else if (inBackButton) {
      startBack();
    }
  }
}
