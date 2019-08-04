
void unbondAll() {
  for (SoundTrack st : tracks) {
    if (st.isBonded())
      st.unbond();
  }
}

boolean allTracksHasNote(){
  for (SoundTrack st : tracks) {
    if (st.getNoteNumber() == 0)
      return false;
  }
  return true;
}
