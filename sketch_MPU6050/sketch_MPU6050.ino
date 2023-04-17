#include <Wire.h>

long accelX,accelY,accelZ;
float gForce_X,gForce_Y,gForce_Z;

long gyroX,gyroY,gyroZ;
float rotX,rotY,rotZ;


void setup() 
{  
  Serial.begin(115200);
  Wire.begin();
  setupMPU();

}

void loop() {
  recordAccel();
  recordGyro();
  printData();
  delay(500);
}

void setupMPU()
{
    Wire.beginTransmission(0x68);
    Wire.write(0x6B);// selecting the register as default values are 0
    Wire.write(0);//setting SLEEP register to 0 to make the sensor in wake up mode
    Wire.endTransmission();
    Wire.beginTransmission(0x68);
    Wire.write(0x1B);// accessing the gyro config register
    Wire.write(0);//setting gyro config to +-250
    Wire.endTransmission();
    Wire.beginTransmission(0x68);
    Wire.write(0x1C);//accessing the accel config register
    Wire.write(0);//setting accel to +-2g
    Wire.endTransmission();
}

void recordAccel()
{
    Wire.beginTransmission(0x68);
    Wire.write(0x3B);// Starting Accel register for request
    Wire.endTransmission();

  Wire.requestFrom(0x68,6);//Request register from 3B to 40 

  accelX=Wire.read()<<8|Wire.read();//2 bytes for X axis accel
  accelY=Wire.read()<<8|Wire.read();//2 bytes for y axis accel
  accelZ=Wire.read()<<8|Wire.read();//2 byytes for z axis accel

  processAccelData();
}

void processAccelData()
{
    gForce_X=accelX / 16384.0;
    gForce_Y=accelY / 16384.0;
    gForce_Z=accelZ / 16384.0;
}

void recordGyro()
{
     // Divide by 1000 to get seconds
    Wire.beginTransmission(0x68);
    Wire.write(0x43);
    Wire.endTransmission();

    Wire.requestFrom(0x68,6);

    gyroX=Wire.read()<<8|Wire.read();
    gyroY=Wire.read()<<8|Wire.read();
    gyroZ=Wire.read()<<8|Wire.read();

  processGyroData();
}

void processGyroData()
{
    rotX=gyroX / 131.0;
    rotY=gyroY / 131.0;
    rotZ=gyroZ / 131.0;
}

void printData()
{
    Serial.print("Gyro (deg) |" );
    Serial.print(" ");
    Serial.print(rotX);
    Serial.print(" ");
    Serial.print(rotY);
    Serial.print(" ");
    Serial.print(rotZ);
    Serial.print(" Accel (g) |");
    Serial.print(" ");
    Serial.print(gForce_X);
    Serial.print(" ");
    Serial.print(gForce_Y);
    Serial.print(" ");
    Serial.println(gForce_Z);
}
