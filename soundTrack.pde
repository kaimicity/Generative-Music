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
  int preLength = leastWholeLength / 3;
  int leastMainLength = leastWholeLength * 2 / 3;
  int noteNumber;
  int direction;
  boolean needActivate;

  SoundTrack(int i) {
    this.index = i;
    this.r = rouletteInR + i * interval;
    myNotes = new ArrayList<Note>();
    this.mainLength = 0;
    noteNumber = 0;
    direct();
    needActivate = false;
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
  }

  void unbond() {
    this.bonded = false;
    currentTrack.getLabel().setCreating(false);
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
  }

  void register(Note n) {
    if (lastValidTime > 0)
      mainLength += millis() - lastValidTime;
    lastValidTime = millis();
    n.setTimePoint(mainLength);
    if (this.mainLength > leastMainLength)
      this.preLength = mainLength / 3;
    for (Note note : myNotes) {
      if (mainLength > leastMainLength) {
        note.setTarget(PI * 7 / 6 - ((float)note.getTimePoint() / mainLength) * PI * 4 / 3);
      } else {
        note.setTarget(PI * 7 / 6 - (1 - ((float)(mainLength - note.getTimePoint()) / leastMainLength)) * PI * 4 / 3);
      }
    }
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
      float noteSpeed = PI * 2 * 1000 / (preLength + mainLength) / frameRate;
      for (Note n : myNotes) {
        n.setStatus("RUN");
        n.setSpeed(noteSpeed);
        n.setDirection(this.direction);
      }
      myLabel.setSpeed(noteSpeed * ((float)Math.random() * 0.05 + 0.15));
      myLabel.startWalking();
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
}
