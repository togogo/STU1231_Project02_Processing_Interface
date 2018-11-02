import processing.serial.*;
import java.util.Arrays;
import java.lang.String;

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

//String[] valList = new String[dataSize];


int counter;//for debugging purposes

//For information...
//ArrayList<String> elephantList = (ArrayList<String>)Arrays.asList(str.split(","));
ArrayList<String> incomingList;

void setup()
{
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[7]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  printArray(Serial.list());

  size(414, 896, P3D);
  ellipseMode(CENTER);

  //println(Serial.list());
}

void draw()
{

  background(255);

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
  ellipse(width/2, height/2, ellipseSize/3 + 200, ellipseSize/3 + 200);
  
  pushMatrix();
  translate(width/2, 200, 0);
  noFill();
  rotateX(radians(serialInArray[1]));
  rotateY(radians(serialInArray[2]));
  rotateZ(radians(serialInArray[3]));
  box(100);
  popMatrix();
}
