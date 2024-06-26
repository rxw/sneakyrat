import android.content.Context;              
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.view.WindowManager;
import android.view.View;
import android.os.Bundle;

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
boolean play =  false;
int buttonx;
int buttony;
int best = 0;

void onCreate(Bundle bundle) 
{
  super.onCreate(bundle);
  // fix so screen doesn't go to sleep when app is active
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void setup() {
  size(displayWidth, displayHeight);
  lamp = new Lamp();
  rat = new Rat();
  orientation(PORTRAIT);
  // Create play button
  playbutton = loadImage("play.png");
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
  textAlign(CENTER);
}

void draw() {
  background(50);
  // Accelerometer data coming in
  sensor = accelData[0];
  // Always display best score
  text("best: "+best,buttonx, buttony+700);
  // Start the rat if pressed play
  if(!rat.lost && play) {
    rat.run(lamp.lamparea[1], lamp.lamparea[0]);
    // Set current level text
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
  // Check if user presses play button
  if(!play) {
    imageMode(CENTER);
    image(playbutton,buttonx, buttony);
    if(mousePressed && (mouseX > buttonx-200 && mouseX < buttonx + 200) && (mouseY > buttony-100 && mouseY < buttony + 100)) {
      // if he does, set state of playing and set game lost to false
      play = true;
      rat.lost = false;
    }
  }
}

// Accelerometer things I copied from the interwebs

void onResume() 
{
  super.onResume();
  sensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  sensorListener = new SensorListener();
  accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  sensorManager.registerListener(sensorListener, accelerometer, SensorManager.SENSOR_DELAY_GAME);  
};
 
void onPause() 
{
  sensorManager.unregisterListener(sensorListener);
  super.onPause();
};
 
 
class SensorListener implements SensorEventListener 
{
  void onSensorChanged(SensorEvent event) 
  {
    if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) 
    {
      accelData = event.values;
    }
  }
  void onAccuracyChanged(Sensor sensor, int accuracy) 
  {
       //todo 
  }
}
