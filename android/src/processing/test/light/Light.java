package processing.test.light;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Light extends PApplet {



Lamp lamp;

public void setup() {
 
  Rat rats = new Rat();
  lamp = new Lamp();
  orientation(PORTRAIT);
}

public void draw() {
  background(0);
  lamp.run();
}
class Lamp {
  
  float aim = 90;
  int x = displayWidth/2;
  int y = 500;
  
  public void Lamp() {
  }
  
  public void run() {
    display();
  }
  
  public void display() {
    pushMatrix();
    fill(70);
    rect(x-10,0,20,y-174);
    arc(x, y, 300,350, PI,PI*2);
    fill(255,255,0, 60);
    quad(x-150,y,x+150,y,x+200,displayHeight,x-200, displayHeight);
    popMatrix();
  }
  
}
class Rat {
  
  public void Rat() {
    
  }
  
  public void run() {
    
  }
  
  public void build(){
  
  }
  
}

  public int sketchWidth() { return displayWidth; }
  public int sketchHeight() { return displayHeight; }
  public String sketchRenderer() { return OPENGL; }
}
