class Syllable{
  String name;
  color myColor;
  final color knobFrom = #40E0D0;
  final color knobTo = #EE2C2C;
  
  Syllable(String n, float mc){
    this.name = n;
    this.myColor = lerpColor(knobFrom, knobTo, mc);
  }
  
  String getName(){
    return this.name;
  }
  
  color getColor(){
    return this.myColor;
  }
}
