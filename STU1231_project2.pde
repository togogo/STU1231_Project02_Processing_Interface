import processing.serial.*;
import java.util.Arrays;
import java.lang.String;

PFont myFont;

boolean dummyBreatheMode;//

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

int ellipseSize = 0;
int tempSize = 0;

int dataSize = 4;
int splitSize = 3;

int[] serialInArray = new int[dataSize]; // Where we’ll put what we receive
int serialCount = 0;     // A count of how many bytes we receive
float number;
int flex, x, y, z;//

int counter;//for debugging purposes

ArrayList<String> incomingList;

void setup()
{
  
  String portName = Serial.list()[7]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  printArray(Serial.list());

  //size(1080, 1920, P3D);
  size(540, 960, P3D);
  ellipseMode(CENTER);

myFont = createFont("axis_light_48.vlw", 20);
textFont(myFont);

}

void draw()
{

  background(255);
  
  //typography stuff
  text("Target Orientation:", 20, 30);
  text("Breathe Rhythm:", 20, height/2 + 30);

  //My first attempt for the prototype
  /*
  //print(Serial.list()[]);
   //println(Serial.list());
   if ( myPort.available() > 0) 
   {  // If data is available,
   val = myPort.readStringUntil('\n');         // read it and store it in val
   //println("hi");
   } 
   println(val); //print it out in the console
   //int ellipseSize = Integer.parseInt(val);
   if (val == null) {
   tempSize = ellipseSize;
   } else {
   val = val.replaceAll("\\D+", "");
   ellipseSize = Integer.valueOf(val);
   tempSize = Integer.valueOf(val);
   }
   
   ellipseSize = tempSize;
   */


  //Second Attempt, slightly sophisticated
  /*
  if ( myPort.available() > 0) {  // If data is available,
   val = myPort.readStringUntil('\n');         // read it and store it in val
   println(val);
   
   if (val == null) {
   number = 0;//fill with placeholder 0 to avoid null data coming in
   } else {
   //number = Integer.parseInt(val);
   val = val.replaceAll("\\D+", "");
   number = Integer.valueOf(val);
   }
   
   //if (val != null) {
   
   serialInArray[serialCount] = (int)number;
   
   serialCount++;
   
   if (serialCount > 3 ) {
   flex = serialInArray[0];
   x = serialInArray[1];
   y = serialInArray[2];
   z = serialInArray[3];
   
   
   print("flex: ");
   println(flex);
   print("  x: ");
   println(x);
   print(  "y: ");
   println(y);
   print(  "z: ");
   println(z);
   println("------------");
   
   // Reset serialCount:
   serialCount = 0;
   }
   }
   
   ellipseSize = flex;//need to make this optimized again...
   */

  //third attempt
  //counter++;
  if ( myPort.available() > 0) 
  {  
    // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val

    //incomingList = (ArrayList<String>)Arrays.asList(val.split(","));
    //List<String> elephantList = Arrays.asList(val.split(","));
    //incomingList = Arrays.asList(val.split(","));
  } 
  //println(val); //print it out in the console
  //int ellipseSize = Integer.parseInt(val);
  if (val == null) {
    tempSize = ellipseSize;
  } else {

    //println(val);
    String[] tempList = split(val, ',');
    //String[] arrOfStr = val.split(",", dataSize);
    //String[] arrOfStr = val.split(",", splitSize);
    //println(tempList.length);

    //val = val.replaceAll("\\D+", "");
    //ellipseSize = Integer.valueOf(val);
    //tempSize = Integer.valueOf(val);
    //println(val);

    if (tempList.length == dataSize) {
      for (int i = 0; i < dataSize; i++) {
        tempList[i] = tempList[i].replaceAll("\\D+", "");
        //println(tempList[0]);
        serialInArray[i] = Integer.valueOf(tempList[i]);
      }
    }
  }
  //ellipseSize = Integer.valueOf(valList[0]);
  //println(radians(serialInArray[2]));
  ellipseSize = serialInArray[0];

  //ellipseSize = tempSize;

  fill(0);
  

  drawBreathe(width/2, height/2 + height/4, ellipseSize/2, 300);
  drawFigure(width/2, 250, 0);
}

void drawBreathe(int _x, int _y, int _breatheVal, int _baseR){
  ellipse(_x, _y, _breatheVal/3 + _baseR, _breatheVal/3 + _baseR);
}

void drawFigure(int _x, int _y, int _z) {
  pushMatrix();
  translate(_x, _y, _z);
  noFill();
  rotateX(radians(serialInArray[1]));
  rotateY(radians(serialInArray[2]));
  rotateZ(radians(serialInArray[3]));
  box(100, 100, 50);
  translate(0, -100, 0);
  box(70, 70, 50);
  translate(-80, 100, 0);
  box(30, 100, 30);
  translate(160, 0, 0);
  box(30, 100, 30);
  translate(-50, 110, 0);
  box(30, 100, 30);
  translate(-60, 0, 0);
  box(30, 100, 30);
  popMatrix();
}

float breathe(){
  float breatheVal = 0;
  return breatheVal;
}
