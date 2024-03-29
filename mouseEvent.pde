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
    if (test != -1 && !unbonding && bondedNumber < 5 && !(test == 2 && !lightSwitch)) {
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
      //if(test == 2){
      //  Note note = new OrcheNote(currentTrack.getIndex(), - 1);
      //  currentTrack.addNote(note);
      //}
        
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
    if (dragging!=0) {
      cursor(ARROW);
      dragging = 0;
    } else if (!enter && !back && inButton1) {
      if (currentOrcheIndex - 1 >= 0)
        currentOrcheIndex --;
      else
        currentOrcheIndex = Database.orcheInstruments.size() - 1;
      currentOrche = Database.orcheInstruments.get(currentOrcheIndex);
      currentTrack.setInstrument(currentOrche);
    } else if (!enter && !back && inButton2) {
      if (currentOrcheIndex + 1 <= Database.orcheInstruments.size() - 1)
        currentOrcheIndex ++;
      else
        currentOrcheIndex = 0;
      currentOrche = Database.orcheInstruments.get(currentOrcheIndex);
      currentTrack.setInstrument(currentOrche);
    } else if (inBackButton) {
      //if (currentTrack.getNoteNumber() > 1) {
      //  Note note = new OrcheNote(currentTrack.getIndex(), - 1);
      //  currentTrack.addNote(note);
      //}
      startBack();
    }
  }
}
