
void unbondAll() {
  for (SoundTrack st : tracks) {
    if (st.isBonded())
      st.unbond();
  }
}
