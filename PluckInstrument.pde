class PluckInstrument extends Instrument{
  
  HashMap<String, String> myPaths;
  PluckInstrument(String name, HashMap<String, String> mps){
    this.name = name;
    this.myFont = pluckFont;
    this.myPaths = mps;
  }
}
