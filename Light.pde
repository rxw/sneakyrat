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
  // Create the font
  square = createFont("square.ttf",120);
  textFont(square,150);
  buttonx = displayWidth/2;
  buttony = displayHeight/2;
  // Create file reader
  reader = createReader("best.txt");
  try {
    line = reader.readLine();
    // Set a local variable "best" with that score
    best = Integer.parseInt(line);
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
    output = createWriter("best.txt");
    output.println("0");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}

void draw() {
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
  // Set current level text
  textAlign(CENTER);
  text(rat.level,buttonx, buttony+400);
  text("best: "+best,buttonx, buttony+700);
  // Start the rat if pressed play
  if(!rat.lost && play) {
    rat.run(lamp.lamparea[1], lamp.lamparea[0]);
  } else if(rat.lost) { // If lost set play to false and save level
    play = false;
    if(rat.level > best) {
      // If achieved best score write it to file
      output = createWriter("best.txt");
      output.println(rat.level);
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      best = rat.level;
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
