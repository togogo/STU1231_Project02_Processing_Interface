import processing.serial.*;
import java.util.Arrays;
import java.lang.String;

PFont myFont;
PImage splashScreen;

float sensitivity = 1.5;//sensitivity of the flex censor

//splash screen function
boolean splashToggle = false;//toggles the splash screen
float splashCounter = 0;
float splashIncrement = 4;

//breathing function related stuff
boolean dummyBreatheMode = true;//toggle the breathe function
boolean breathing = true;//toggles the breathe itself
float radCounters = 0;//radian counter for the breathe function
float breatheMagnitude = 50;//how much magnitude I want for the breathing to happen
float radIncrement = TWO_PI/(360*1.3);//how much increment I want
float tempBreatheVal;//stores the breatheVal for smooth transition

//alert mode
boolean alert;//watches alert mode or not

boolean down;//detects weather the baby is looking down

//background
color alertBG1 = color(146, 7, 131);
color alertBG2 = color(215, 0, 81);
color normalBG1 = color(23, 42, 136);
color normalBG2 = color(96, 27, 130);
color white = color(255);
color black = color(0);
float lerpCount = 0;

color upper;
color lower;


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

  printArray(Serial.list());
  String portName = Serial.list()[6]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);


  //size(1080, 1920, P3D);
  size(540, 960, P3D);
  smooth(3);
  ellipseMode(CENTER);

  myFont = createFont("axis_light_48.vlw", 20);
  textFont(myFont);

  splashScreen = loadImage("splash.jpg");
}

void draw()
{

  upper = lerpColor(normalBG1, alertBG1, lerpCount);
  lower = lerpColor(normalBG2, alertBG2, lerpCount);
  lerpCount();

  splashCount();

  //background(255);
  beginShape();
  fill(upper);
  vertex(0, 0);
  vertex(width, 0);
  fill(lower);

  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);

  //typography stuff
  fill(white);
  text("Target Orientation:", 20, 30);
  
    if(serialInArray[1] >= 160){
    fill(255, 0, 0);
    ellipse(28, 48, 20, 20);
    text("Face down", 40, 55);
    
  }
  
  fill(white);
  text("Target Respiration:", 20, height/2 + 30);
  
  if(breathing == false){
    fill(255, 0, 0);
    ellipse(28, height/2 + 48, 20, 20);
    text("Not detected", 40, height/2 + 55);
  }

  //counter++;
  if (myPort.available() > 0) 
  {  
    // If data is available,
    val = myPort.readStringUntil('\n');// read it and store it in val
    //println(val);
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
  //println(radians(serialInArray[0]));
  ellipseSize = serialInArray[0];

  //ellipseSize = tempSize;

  fill(white);
  stroke(white);


  stroke(255, (255 - splashCounter));
  drawBreathe(width/2, height/2 + height/4, ellipseSize/2, 300);
  drawFigure(width/2, 250, 120);

  //splash screen feature
  pushMatrix();
  translate(0, 0, 300);
  tint(255, splashCounter);
  image(splashScreen, 0, 0, width, height);
  popMatrix();
}

void drawBreathe(int _x, int _y, int _breatheVal, int _baseR) {

  directionalLight(126, 126, 126, 0, 0, -1);
  ambientLight(160, 160, 160);
  
  //noFill();
  fill(white);
  if (dummyBreatheMode == true) {
    //ellipse(_x, _y, breathe() +  _baseR + _breatheVal*sensitivity, breathe() + _baseR + _breatheVal*sensitivity);
    pushMatrix();
    translate(_x, _y);
    noStroke();
    sphere((breathe() + _baseR + _breatheVal*sensitivity)/2);
    popMatrix();
  } else if (dummyBreatheMode == false) {
    ellipse(_x, _y, _breatheVal + _baseR, _breatheVal + _baseR);//not really used anymore
  }
}

void drawFigure(int _x, int _y, int _z) {
  //noStroke();
  
  
  //attempt
  float roll  = serialInArray[3];
  float pitch = serialInArray[2];
  float yaw   = serialInArray[1];
  float c1 = cos(radians(roll) - PI);
  float s1 = sin(radians(roll) - PI);
  float c2 = cos(radians(pitch) - PI); // intrinsic rotation
  float s2 = sin(radians(pitch) - PI);
  float c3 = cos(radians(yaw) - PI);
  float s3 = sin(radians(yaw) - PI);

  /*
  int directionR = (upper >> 24) & 0xFF;
   int directionG = (upper >> 16) & 0xFF;
   int directionB = (upper >> 8) & 0xFF;
   
   int lowerR = (lower >> 24) & 0xFF;
   int lowerG = (lower >> 16) & 0xFF;
   int lowerB = (lower >> 8) & 0xFF;
   
   //directionalLight(directionR, directionG, directionB, 0, 0, -1);
   //ambientLight(lowerR, lowerG, lowerB);
   
   second a
   */
  //directionalLight(126, 126, 126, 0, 0, -1);
  //ambientLight(102, 102, 102);

  pushMatrix();
  translate(_x, _y, _z);
  //noFill();
  noStroke();
  
  //rotateX(c1*s1);//initial attempt
  //rotateY(c2*s2);//initial attempt
  //rotateZ(c3*s3);//initial attempt
  
  //rotateX(c1);//initial attempt
  //rotateY(s2);//initial attempt
  //rotateZ(c3);//initial attempt
  
  rotateX(radians(pitch));//initial attempt
  rotateY(radians(yaw));//initial attempt
  rotateZ(radians(roll));//initial attempt
  
  //println(yaw);
  
  //rotateX(radians(serialInArray[1]));//initial attempt
  //rotateY(radians(serialInArray[2]));//initial attempt
  //rotateZ(radians(serialInArray[3]));//initial attempt
  
  
  //println(serialInArray[1]);
  
  /*
  applyMatrix( c2*c3, s1*s3+c1*c3*s2, c3*s1*s2-c1*s3, 0,
               -s2, c1*c2, c2*s1, 0,
               c2*s3, c1*s2*s3-c3*s1, c1*c3+s1*s2*s3, 0,
               0, 0, 0, 1);
  */
  box(100, 100, 50);//torso
  translate(0, -100, 0);
  box(70, 70, 50);//head
  translate(0, 0, 30);
  box(10, 40, 10);//nose
  translate(0, 0, -30);
  //sphere(70);//head
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

void keyPressed() {
  if (key == 'a') {
    if (alert == true) {
      println("alert mode toggled");
      alert = false;
    } else {
      alert  = true;
      println("alert mode untoggled");
    }
  }

  if (key == 'b') {
    if (breathing == true) {
      println("breathing");
      breathing = false;
    } else {
      breathing  = true;
      println("not breathing");
    }
  }

  if (key == 's') {
    if (splashToggle == true) {
      println("splash screen off");
      splashToggle = false;
    } else {
      splashToggle  = true;
      println("splash screen on");
    }
  }
}


void splashCount() {
  if (splashToggle == true) {
    if (splashCounter <= 255) {
      splashCounter = splashCounter + splashIncrement;
    }
  } else {
    if (splashCounter > 0) {
      splashCounter = splashCounter - splashIncrement;
    }
  }
}


void lerpCount() {
  if (alert == true) {
    if (lerpCount <= 1) {
      lerpCount = lerpCount + radIncrement;
    }
  } else {
    if (lerpCount > 0) {
      lerpCount = lerpCount - radIncrement;
    }
  }
}


float breathe() {
  //radCounters = radCounters + radIncrement;//always increase the radCounter
  float breatheVal = 0;
  if (breathing == true) {
    radCounters = radCounters + radIncrement;//always increase the radCounter
    breatheVal = breatheMagnitude*sin(radCounters);//when breathing
    tempBreatheVal = breatheVal;
  } else if (breathing == false) {
    //breatheVal = (breatheMagnitude/10)*sin(radCounters) + tempBreatheVal;//when not breathing
    breatheVal = tempBreatheVal;
  }
  return breatheVal;
}
