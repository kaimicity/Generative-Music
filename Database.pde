static class Database{
  static String[] typesOfInstruments = {"Percussion Instruments", "Keyboard/Pluck Instruments", "Orchestral Instruments"};
  static String[] buttonMark = {"PERCUSSION", "PLUCK", "ORCHE"};
  static ArrayList<PercussionInstrument> percussionInstruments;
  static ArrayList<PluckInstrument> pluckInstruments;
  static HashMap<String, Syllable> syllableDic;
  //static 

  static void init(){
    Stones stone = new Stones();
    JSONArray pi = instruments.getJSONArray("Percussion");
    percussionInstruments = new ArrayList<PercussionInstrument>();
    for(int i = 0; i < pi.size(); i ++){
      JSONObject instrmt = pi.getJSONObject(i);
      percussionInstruments.add(stone.new PercussionInstrument(instrmt.getString("name"),
        instrmt.getString("soundPath1"), instrmt.getString("soundPath2"), instrmt.getString("soundName1"), instrmt.getString("soundName2")));
    }
    JSONArray pl = instruments.getJSONArray("Pluck");
    pluckInstruments = new ArrayList<PluckInstrument>();
    for(int i = 0; i < pl.size(); i ++){
      JSONObject instrmt = pl.getJSONObject(i);
      HashMap<String, String> mps = new HashMap<String, String>();
      JSONArray ps = instrmt.getJSONArray("paths");
      for(int j = 0; j < ps.size(); j++){
        mps.put(ps.getJSONObject(j).getString("name"), ps.getJSONObject(j).getString("path"));
      }
        
      pluckInstruments.add(stone.new PluckInstrument(instrmt.getString("name"), mps));
    }
    syllableDic = new HashMap<String, Syllable>();
    for(int i = 0; i < syllables.size(); i ++){
      JSONObject syllable = syllables.getJSONObject(i);
      syllableDic.put(syllable.getString("name"),stone.new Syllable(syllable.getString("name"), syllable.getFloat("value")));
    }
  }
  
  static Syllable getSyllable(String syllableName){
    return syllableDic.get(syllableName);
  }
}
