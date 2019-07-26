static class Database {
  static String[] typesOfInstruments = {"Percussion Instruments", "Keyboard/Pluck Instruments", "Orchestral Instruments"};
  static String[] buttonMark = {"PERCUSSION", "PLUCK", "ORCHE"};
  static String[] tonalityMark = {"C", "G", "D", "A", "E", "B", "#F", "#C", "F", "#A", "#D", "#G"};
  static ArrayList<PercussionInstrument> percussionInstruments;
  static ArrayList<PluckInstrument> pluckInstruments;
  static ArrayList<OrcheInstrument> orcheInstruments;
  static HashMap<String, Syllable> syllableDic;
  static HashMap<String, Tonality> majors;
  static HashMap<String, Tonality> minors;

  static void init() {
    Stones stone = new Stones();
    initPercussionInstruments(stone);
    initPluckInstruments(stone);
    initOrcheInstruments(stone);
    initSyllables(stone);
    initTonalities(stone);
  }

  static Syllable getSyllable(String syllableName) {
    return syllableDic.get(syllableName);
  }

  static void initPercussionInstruments(Stones stone) {
    JSONArray pi = instruments.getJSONArray("Percussion");
    percussionInstruments = new ArrayList<PercussionInstrument>();
    for (int i = 0; i < pi.size(); i ++) {
      JSONObject instrmt = pi.getJSONObject(i);
      percussionInstruments.add(stone.new PercussionInstrument(instrmt.getString("name"), 
        instrmt.getString("soundPath1"), instrmt.getString("soundPath2"), instrmt.getString("soundName1"), instrmt.getString("soundName2")));
    }
  }

  static void initPluckInstruments(Stones stone) {
    JSONArray pl = instruments.getJSONArray("Pluck");
    pluckInstruments = new ArrayList<PluckInstrument>();
    for (int i = 0; i < pl.size(); i ++) {
      JSONObject instrmt = pl.getJSONObject(i);
      HashMap<String, String> mps = new HashMap<String, String>();
      JSONArray ps = instrmt.getJSONArray("paths");
      for (int j = 0; j < ps.size(); j++) {
        mps.put(ps.getJSONObject(j).getString("name"), ps.getJSONObject(j).getString("path"));
      }
      pluckInstruments.add(stone.new PluckInstrument(instrmt.getString("name"), mps));
    }
  }
  
  static void initOrcheInstruments(Stones stone) {
    JSONArray or = instruments.getJSONArray("Orche");
    orcheInstruments = new ArrayList<OrcheInstrument>();
    for (int i = 0; i < or.size(); i ++) {
      JSONObject instrmt = or.getJSONObject(i);
      HashMap<String, String> mps = new HashMap<String, String>();
      JSONArray ps = instrmt.getJSONArray("paths");
      for (int j = 0; j < ps.size(); j++) {
        mps.put(ps.getJSONObject(j).getString("name"), ps.getJSONObject(j).getString("path"));
      }
      orcheInstruments.add(stone.new OrcheInstrument(instrmt.getString("name"), mps));
    }
  }

  static void initSyllables(Stones stone) {
    syllableDic = new HashMap<String, Syllable>();
    for (int i = 0; i < syllables.size(); i ++) {
      JSONObject syllable = syllables.getJSONObject(i);
      syllableDic.put(syllable.getString("name"), stone.new Syllable(syllable.getString("name"), syllable.getFloat("value")));
    }
  }

  static void initTonalities(Stones stone) {
    majors = new HashMap<String, Tonality>();
    minors = new HashMap<String, Tonality>();
    for (int i = 0; i < tonalities.size(); i++) {
      JSONObject tnlt = tonalities.getJSONObject(i);
      JSONArray syllableList = tnlt.getJSONArray("syllables");
      ArrayList<Syllable> mySyllables = new ArrayList<Syllable>();
      for (int j = 0; j < syllableList.size(); j++) {
        mySyllables.add(Database.getSyllable(syllableList.getString(j)));
      }
      if(tnlt.getString("type").equals("Major")){
        majors.put(tnlt.getString("name"), stone.new Tonality(tnlt.getString("name"), mySyllables));
      } else{
        minors.put(tnlt.getString("name"), stone.new Tonality(tnlt.getString("name"), mySyllables));
      }
      if (i == 0) {
        natureTonality = stone.new Tonality(tnlt.getString("name"), mySyllables);
      }
    }
  }
}
