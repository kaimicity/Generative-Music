class SoundTrack {
  PVector position = roulettePosition;
  int r;
  int index;
  color myColor = unbondSoundtrack;
  boolean bonded;
  Label myLabel;
  Instrument instrument;
  ArrayList<Note> myNotes;
  int mainLength;
  int leastWholeLength = 5000;
  int preLength = leastWholeLength / 5;
  int leastMainLength = leastWholeLength * 4 / 5;
  int leastPrelength = leastWholeLength / 5;
  int maxPreLength = 2000;
  int noteNumber;
  int direction;
  boolean needActivate;
  AudioPlayer orchePlayer;
  boolean diminishing;
  String callbackPath;
  boolean orcheSwitch;
  boolean orcheEnd;

  SoundTrack(int i) {
    this.index = i;
    this.r = rouletteInR + i * interval;
    myNotes = new ArrayList<Note>();
    this.mainLength = 0;
    noteNumber = 0;
    direct();
    needActivate = false;
    diminishing = false;
    orcheSwitch = false;
    orcheEnd = false;
  }

  void direct() {
    double mark = Math.random();
    if ( mark < 0.5) {
      direction = 1;
    } else {
      direction = - 1;
    }
  }

  int getR() {
    return this.r;
  }

  int getIndex() {
    return this.index;
  }

  Label getLabel() {
    return myLabel;
  }
  int getNoteNumber() {
    return this.noteNumber;
  }

  void addNote(Note n) {
    this.myNotes.add(n);
    register(n);
    noteNumber ++;
  }
  boolean isBonded() {
    return this.bonded;
  }

  Instrument getInstrument() {
    return this.instrument;
  }

  void bond(Instrument ins) {
    bonded = true;
    instrument = ins;
    myLabel = new Label(index, ins);
    myNotes = new ArrayList<Note>();
    noteNumber = 0;
    preLength = leastWholeLength / 3;
    mainLength = 0;
    lastValidTime = 0;
    needActivate = false;
    diminishing = false;
    orcheSwitch = false;
    orcheEnd = false;
  }

  void initPlayer() {
    orchePlayer = minim.loadFile("Material/pluck/piano/C.mp3");
  }

  void unbond() {
    this.bonded = false;
    currentTrack.getLabel().setCreating(false);
    myNotes = new ArrayList<Note>();
    noteNumber = 0;
    if (instrument.getType().equals("ORCHE")) {
      orchePlayer.pause();
      orchePlayer = null;
    }
  }

  void setInstrument(Instrument ins) {
    this.instrument = ins;
    myLabel.setInstrument(ins);
  }

  void draw() {
    stroke(unbondSoundtrack);
    strokeWeight(panelStrokeWidth / 2);
    noFill();
    ellipse(position.x, position.y, r * 2, r * 2);
    if (bonded) {
      for (Note n : myNotes) {
        n.draw();
      }
      myLabel.draw();
    }
    if (needActivate && allNotesReady()) {
      float noteSpeed = PI * 2 * 1000 / (preLength + mainLength) / frameRate;
      for (Note n : myNotes) {
        n.setStatus("RUN");
        n.setSpeed(noteSpeed);
        n.setDirection(this.direction);
      }
      myLabel.setSpeed(noteSpeed * ((float)Math.random() * 0.05 + 0.15));
      myLabel.startWalking();
      needActivate = false;
    }
    if (instrument != null && myLabel.isWalking() && instrument.getType().equals("ORCHE")) {
      if (orchePlayer != null && diminishing && orchePlayer.getGain() > -20) {
        orchePlayer.setGain(orchePlayer.getGain() - 1);
        if (orchePlayer.getGain() <= -20) {
          diminishing = false;
          if (!callbackPath.equals("END")) {
            orchePlayer.pause();
            orchePlayer = null;
            orchePlayer = minim.loadFile(callbackPath);
            orchePlayer.rewind();
            if (currentPanel.equals("PERCUSSION"))
              orchePlayer.pause();
            else if (orcheEnd) {
              orchePlayer.play();
              orcheEnd = false;
              ((OrcheNote)myNotes.get(myNotes.size() - 1)).setEnd();
              ((OrcheNote)myNotes.get(0)).setEnd();
            } else {
              orchePlayer.loop();
            }
          } else
            orchePlayer.pause();
        }
      } else if (orchePlayer != null && !diminishing && orchePlayer.getGain() < 0) {
        orchePlayer.setGain(orchePlayer.getGain() + 1);
      }
    }
  }

  void register(Note n) {
    if (lastValidTime > 0)
      mainLength += millis() - lastValidTime;
    lastValidTime = millis();
    n.setTimePoint(mainLength);
    if (this.mainLength > leastMainLength)
      this.preLength = mainLength / 4;
    //if (preLength < maxPreLength) {
      for (Note note : myNotes) {
        if (mainLength > leastMainLength) {
          note.setTarget(PI * 13 / 10 - ((float)note.getTimePoint() / mainLength) * PI * 8 / 5);
        } else {
          note.setTarget(PI * 13 / 10 - (1 - ((float)(mainLength - note.getTimePoint()) / leastMainLength)) * PI * 8 / 5);
        }
      }
    //} else {
    //  preLength = maxPreLength;
    //  float intervalAngle = PI * 2 * (preLength / (preLength + mainLength)) / 2;
    //  for (Note note : myNotes) {
    //      note.setTarget( (PI * 3 / 2 -intervalAngle) - (1 - ((float)(mainLength - note.getTimePoint()) / leastMainLength)) * (PI * 2 - intervalAngle * 2));
    //  }
    //}
  }

  boolean allNotesReady() {
    for (Note n : myNotes) {
      if (!n.isWaiting())
        return false;
    }
    return true;
  }

  void activate() {
    if (allNotesReady()) {
      float noteSpeed;
      if (mainLength > leastMainLength) 
        noteSpeed = PI * 2 * 1000 / (preLength + mainLength) / frameRate;
      else {
        noteSpeed = PI * 2 * 1000 / leastWholeLength / frameRate;
      }
      for (Note n : myNotes) {
        n.setStatus("RUN");
        n.setSpeed(noteSpeed);
        n.setDirection(this.direction);
      }
      myLabel.setSpeed(noteSpeed * ((float)Math.random() * 0.05 + 0.15));
      myLabel.startWalking();
      if (instrument.getType().equals("ORCHE")) {
        ((OrcheNote)myNotes.get(myNotes.size() - 1)).setEnd();
        ((OrcheNote)myNotes.get(0)).setEnd();
      }
    } else
      needActivate = true;
  }

  void allNotesResetAudio() {
    if (this.instrument.getType().equals("PLUCK")) {
      for (Note n : myNotes) {
        ((PluckNote)n).resetAudio();
      }
    }
  }

  void setOrchePlayer(String path) {
    callbackPath = path;
    diminishing = true;
    if (!orcheSwitch) {
      orcheSwitch = true;
      orchePlayer = minim.loadFile(callbackPath);
      diminishing = false;
      orchePlayer.rewind();
      orchePlayer.loop();
    }
  }

  AudioPlayer getOrchePlayer() {
    return this.orchePlayer;
  }

  void diminish() {
    diminishing = true;
    callbackPath = "END";
    orcheSwitch = false;
  }

  void setEnd() {
    this.orcheEnd = true;
  }

  boolean bothEnd() {
    return ((OrcheNote)myNotes.get(myNotes.size() - 1)).getEnd() && ((OrcheNote)myNotes.get(0)).getEnd();
  }
}
