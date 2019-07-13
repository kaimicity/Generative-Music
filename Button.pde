class Button{
  PVector position;
  float width;
  float height;
  boolean clickable;
  color backColor;
  color textColor;
  String name;
  
  Button(PVector p, float w, float h, String n){
     this.position = p;
    this.width = w;
    this.height = h;
    this. name = n;
  }
  
  boolean isClickable(){
    return clickable;
  }
  
  void lock(){
    this.clickable = false;
  }
  
  void unlock(){
    this.clickable = true;
  }
  
  boolean isFocused(){
    if(mouseX > position.x && mouseX < position.x + this.width && mouseY > position.y && mouseY < position.y + this.height){
      return true;
    } else 
      return false;
  }
  
  void draw(int opa){
    stroke(normalStroke, opa);
    strokeWeight(panelStrokeWidth);
    if(!enter && !back && isFocused() && mousePressed){
      backColor = normalStroke;
      textColor = whiteColor;
    } else{
      backColor = whiteColor;
      textColor = normalStroke;
    }
    fill(backColor, opa);
    rect(position.x, position.y, this.width, this.height);
    textAlign(CENTER, CENTER);
    textSize(this.height * 2 / 3);
    fill(textColor, opa);
    text(name, position.x + width / 2, position.y + height / 2);
  }
  
  
}
