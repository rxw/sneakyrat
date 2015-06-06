class Rat {
  
  PImage img;
  float x = (displayWidth/2)-100;
  float speed = 4;
  int position = 0;
  int direction = 1;
  boolean lost = false;
  int level = 0;
  int last;
  
  void Rat() {
  }
  
  void run(float lightone, float lighttwo) {
    move();
    display();
    lost(lightone, lighttwo);
    randomize();
  }
  
  void display() {
    image(img, x, displayHeight-125);
  }
  
  void move() {
    if(direction == -1) {
      if(position > 5) {
      img = loadImage("RatIn2.png");
        if(position == 10) {
          position = 0;
        }
      } else {
        img = loadImage("RatIn1.png");
      } 
    } else {
      if(position > 5) {
      img = loadImage("Rat2.png");
        if(position == 10) {
          position = 0;
        }
      } else {
        img = loadImage("Rat1.png");
      }
    }
    position++;
    x += speed * direction;
    if(x+200 > displayWidth || x < 0) {
      direction = -direction;
      speed += .5;
      level += 1;
    }
  }
  
  void lost(float lightone, float lighttwo) {
    if(x+150 < lightone || x+150 > lighttwo) {
      lost = true;
      direction = 1;
      speed = 4;
      x = displayWidth/2 -100;
      last = rat.level;
    }
  }
  
  void randomize() {
    
  }
}
