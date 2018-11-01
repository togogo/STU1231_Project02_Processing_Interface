import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
int ellipseSize = 0;
int tempSize = 0;

void setup()
{
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[5]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);

  size(414, 896);
  ellipseMode(CENTER);

  //println(Serial.list());
}

void draw()
{

  background(255);
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
  fill(0);
  ellipse(width/2, height/2, ellipseSize/3, ellipseSize/3);
}
