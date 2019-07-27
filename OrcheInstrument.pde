class OrcheInstrument extends Instrument {
  HashMap<String, String> myPaths;
  OrcheInstrument(String name, HashMap<String, String> mps){
    this.name = name;
    this.myFont = pluckFont;
    this.myPaths = mps;
    this.type = "ORCHE";
  }
  
  String getPath(String sy){
    return myPaths.get(sy);
  }
}
