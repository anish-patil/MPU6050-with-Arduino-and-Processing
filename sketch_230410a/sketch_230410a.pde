import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial myPort;// Create object from Serial class
String val;
float[] values = new float[6]; // Array to hold raw sensor values
float rotX=0.0,rotY=0.0,rotZ=0.0,gForceX=0.0,gForceY=0.0,gForceZ=0.0; // Sensor variables
float roll=0.0,pitch=0.0, yaw=0.0; // Orientation variables
float accAngleX=0.0,accAngleY=0.0,gyroAngleX=0.0,gyroAngleY=0.0,gyroAngleZ=0.0;
float  previousTime=0.0, currentTime=0.0,elapsedTime=0.0;
void setup() 
{
  size (400, 400, P3D);// Set up serial communication with Arduino at 115200 bps
  String portName = Serial.list()[4]; // Replace with your actual port name
   myPort = new Serial(this, portName, 115200);
   myPort.bufferUntil('\n');
}

void draw()
{
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readStringUntil('\n');  // read it and store it in val
   if (val != null) {
   String[] data= val.split(" ");
   if (data.length >= 6) {
  if (data[0] != null && !data[0].isEmpty()) {
    rotX = float(data[0]);
  }
  if (data[1] != null && !data[1].isEmpty()) {
    rotY = float(data[1]);
  }
   if (data[2] != null && !data[2].isEmpty()) {
    rotZ = float(data[2]);
  }
   if (data[3] != null && !data[3].isEmpty()) {
    gForceX = float(data[3]);
  }
   if (data[4] != null && !data[4].isEmpty()) {
    gForceY = float(data[4]);
  }
   if (data[5] != null && !data[5].isEmpty()) {
    gForceZ = float(data[5]);
  }
     }
   }
  }
  previousTime = currentTime;        // Previous time is stored before the actual time read
  currentTime = millis();            // Current time actual time read
  elapsedTime = (currentTime - previousTime) / 1000; // Divide by 1000 to get seconds
  println(elapsedTime);
  
 accAngleX = (atan(gForceY / sqrt(pow(gForceX, 2) + pow(gForceZ, 2))) * 180/PI);
 accAngleY = (atan(-1 * gForceX / sqrt(pow(gForceY, 2) + pow(gForceZ, 2))) * 180/ PI );
 
 gyroAngleX=gyroAngleX+rotX*elapsedTime;
 gyroAngleY=gyroAngleY+rotY*elapsedTime;
 
 roll=0.96*gyroAngleX+0.04*accAngleX;
 pitch=0.96*gyroAngleY+0.04*accAngleY;  
 yaw=yaw+rotZ*elapsedTime;
  
  translate(width/2, height/2, 0);
  background(233);
  textSize(22);
  text("Roll: " + int(roll) + "     Pitch: " + int(pitch)+"      Yaw:"+int(yaw), -100, 265);
  fill(200);
  // Rotate the object
  rotateX(radians(-roll));
  rotateY(radians(pitch));
  rotateZ(radians(yaw));
  
\
  // 3D 0bject
  
  noFill();
  box(160);
}
