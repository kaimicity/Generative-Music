class PluckInstrument extends Instrument{
  
  HashMap<String, String> myPaths;
  HashMap<String, AudioPlayer> myPlayers;
  PluckInstrument(String name, HashMap<String, String> mps){
    this.name = name;
    this.myFont = pluckFont;
    this.myPaths = mps;
    this.type = "PLUCK";
    myPlayers = new HashMap<String, AudioPlayer>();
    for(String entry: mps.keySet()){
      AudioPlayer ap = minim.loadFile( mps.get(entry));
      myPlayers.put(entry, ap);
    }
  }
  
  AudioPlayer getPlayer(String sy){
    return myPlayers.get(sy);
  }
}
