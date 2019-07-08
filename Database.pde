static class Database{
  static String[] typesOfInstruments = {"Percussion Instruments", "Keyboard/Pluck Instruments", "Orchestral Instruments"};
  static String[] buttonMark = {"PERCUSSION", "PLUCK", "ORCHE"};
  static ArrayList<PercussionInstrument> percussionInstruments;

  static void init(){
    JSONArray pi = instruments.getJSONArray("Percussion");
    percussionInstruments = new ArrayList<PercussionInstrument>();
    for(int i = 0; i < pi.size(); i ++){
      JSONObject instrmt = pi.getJSONObject(i);
      percussionInstruments.add(new Stones().new PercussionInstrument(instrmt.getString("name"),
        instrmt.getString("soundPath1"), instrmt.getString("soundPath2"), instrmt.getString("soundName1"), instrmt.getString("soundName2")));
    }
  }
}
