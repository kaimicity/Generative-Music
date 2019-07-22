class Tonality{
  String name;
  ArrayList<Syllable> mySyllables;
  
  Tonality(String n, ArrayList<Syllable> ms){
    this.name = n;
    this.mySyllables = ms;
  }
  
  String getName(){
    return this.name;
  }
  
  ArrayList<Syllable> getMySyllables(){
    return mySyllables;
  }
  
  int getSyllableIndex(String slb){
    for(int i = 0; i < mySyllables.size(); i++){
      Syllable s = mySyllables.get(i);
      if(slb.equals(s.getName()))
        return i;
    }
    return -1;
  }
}
