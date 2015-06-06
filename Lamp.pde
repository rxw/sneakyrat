class Lamp {
  
  float aim = 90;
  int x = displayWidth/2;
  int y = 500;
  float shift = 0;
  float[] lamparea = {0,0};
  
  void Lamp() {
  }
  
  void run(float _x) {
    shift = _x * 50;
    lamparea[0] = x+200-shift;
    lamparea[1] = x-200-shift;
    display();
  }
  
  void display() {
    pushMatrix();
    noStroke();
    fill(255);
    rect(x-10,0,20,y-174);
    arc(x, y, 300,350, PI,PI*2);
    fill(255,255,0, 60);
    quad(x-150,y,x+150,y,lamparea[0],displayHeight,lamparea[1], displayHeight);
    popMatrix();
  }
  
}
