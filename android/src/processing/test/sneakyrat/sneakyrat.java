package processing.test.sneakyrat;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import android.content.Context; 
import android.hardware.Sensor; 
import android.hardware.SensorEvent; 
import android.hardware.SensorEventListener; 
import android.hardware.SensorManager; 
import android.view.WindowManager; 
import android.view.View; 
import android.os.Bundle; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sneakyrat extends PApplet {

              








BufferedReader reader;
PrintWriter output;
String line;
File file;
Lamp lamp;
Rat rat;
SensorManager sensorManager;
SensorListener sensorListener;
Sensor accelerometer;           
float[] accelData;
float sensor;

PFont square;
PImage playbutton;
PImage youlost;
boolean play =  false;
int buttonx;
int buttony;
int best = 0;

public void onCreate(Bundle bundle) 
{
  super.onCreate(bundle);
  // fix so screen doesn't go to sleep when app is active
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

public void setup() {
 
  lamp = new Lamp();
  rat = new Rat();
  orientation(PORTRAIT);
  // Create the font
  square = createFont("square.ttf",120);
  textFont(square,150);
  buttonx = displayWidth/2;
  buttony = displayHeight/2;
  file = getFileStreamPath("best.txt");
  if(file.exists()) {
    reader = createReader("best.txt");
    // Create file reader
    try {
      line = reader.readLine();
      // Set a local variable "best" with that score
      best = Integer.parseInt(line);
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
  } else {
    output = createWriter("best.txt");
    output.println("0");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}

public void draw() {
  background(50);
  // Accelerometer data coming in
  sensor = accelData[0];
  // Check if user presses play button
  if(!play) {
    textAlign(CENTER);
    text("PLAY",buttonx, buttony);
    if(mousePressed && (mouseX > buttonx-200 && mouseX < buttonx + 200) && (mouseY > buttony-100 && mouseY < buttony + 100)) {
      // if he does, set state of playing and set game lost to false
      play = true;
      rat.lost = false;
    }
  }
  // Always display best score
  text("best: "+best,buttonx, buttony+700);
  // Start the rat if pressed play
  if(!rat.lost && play) {
    rat.run(lamp.lamparea[1], lamp.lamparea[0]);
    // Set current level text
    textAlign(CENTER);
    text(rat.level,buttonx, buttony+400);
  } else if(rat.lost) { // If lost set play to false and save level
    play = false;
    text(rat.last,buttonx, buttony+400);
    if(rat.level > best) {
      best = rat.level;
      // If achieved best score write it to file
      output = createWriter("best.txt");
      output.println(best);
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
    }
    // Set level back to one
    rat.level = 0;
    // Set you lost text
    textAlign(CENTER);
    text("you lost!",buttonx,buttony-200);
  }
  // Run the lamp with accelerometer parameters
  lamp.run(sensor);
}

// Accelerometer things I copied from the interwebs

public void onResume() 
{
  super.onResume();
  sensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  sensorListener = new SensorListener();
  accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  sensorManager.registerListener(sensorListener, accelerometer, SensorManager.SENSOR_DELAY_GAME);  
};
 
public void onPause() 
{
  sensorManager.unregisterListener(sensorListener);
  super.onPause();
};
 
 
class SensorListener implements SensorEventListener 
{
  public void onSensorChanged(SensorEvent event) 
  {
    if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) 
    {
      accelData = event.values;
    }
  }
  public void onAccuracyChanged(Sensor sensor, int accuracy) 
  {
       //todo 
  }
}
class Lamp {
  
  float aim = 90;
  int x = displayWidth/2;
  int y = 500;
  float shift = 0;
  float[] lamparea = {0,0};
  
  public void Lamp() {
  }
  
  public void run(float _x) {
    shift = _x * 50;
    lamparea[0] = x+200-shift;
    lamparea[1] = x-200-shift;
    display();
  }
  
  public void display() {
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
class Rat {
  
  PImage img;
  float x = (displayWidth/2)-100;
  float speed = 4;
  int position = 0;
  int direction = 1;
  boolean lost = false;
  int level = 0;
  int last;
  
  public void Rat() {
  }
  
  public void run(float lightone, float lighttwo) {
    move();
    display();
    lost(lightone, lighttwo);
    randomize();
  }
  
  public void display() {
    image(img, x, displayHeight-125);
  }
  
  public void move() {
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
      speed += .5f;
      level += 1;
    }
  }
  
  public void lost(float lightone, float lighttwo) {
    if(x+150 < lightone || x+150 > lighttwo) {
      lost = true;
      direction = 1;
      speed = 4;
      x = displayWidth/2 -100;
      last = rat.level;
    }
  }
  
  public void randomize() {
    
  }
}

  public int sketchWidth() { return displayWidth; }
  public int sketchHeight() { return displayHeight; }
}
