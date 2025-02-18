import oscP5.*;
import netP5.*;

String dataFile = "filtered_file.csv";

/* TOIO Map Coordinates */
static int min_x = 45;
static int max_x = 955;
static int min_y = 45;
static int max_y = 455;


/* Loading Dock Position */
/* Timeline Position */
PImage img;
FireData[] fireDataArray;
String[][] stringArray;

/* Toio setting start -Chi */
//TOIO constants
int nCubes = 8;
int cubesPerHost = 12;
int maxMotorSpeed = 115;
int xOffset;
int yOffset;

//// Instruction for Windows Users  (Feb 2. 2025) ////
// 1. Enable WindowsMode and set nCubes to the exact number of toio you are connecting.
// 2. Run Processing Code FIRST, Then Run the Rust Code. After running the Rust Code, you should place the toio on the toio mat, then Processing should start showing the toio position.
// 3. When you re-run the processing code, make sure to stop the rust code and toios to be disconnected (switch to Bluetooth stand-by mode [blue LED blinking]). If toios are taking time to disconnect, you can optionally turn off the toio and turn back on using the power button.
// Optional: If the toio behavior is werid consider dropping the framerate (e.g. change from 30 to 10)
//
boolean WindowsMode = false; //When you enable this, it will check for connection with toio via Rust first, before starting void loop()

int framerate = 30;

int[] matDimension = {45, 45, 955, 455};

int mapXStart = 0;
int mapXEnd = 655;
int mapYStart = 0;
int mapYEnd = 310;

//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;

//we'll keep the cubes here
Cube[] cubes;
// assign cube to different roles by referencing the cube id
int[] cubeTimeInput = {0};
int[] cubeFires = {1, 2, 3, 4, 5, 6, 7};
/* Toio Setting End -Chi */

void setup() {
  fireDataArray = loadData2FireDataArray(dataFile);
  stringArray = loadData2StringArray(dataFile);
  
  /* Toio Initializing Start -Chi */
  //launch OSC sercer
  oscP5 = new OscP5(this, 3333);
  server = new NetAddress[1];
  server[0] = new NetAddress("127.0.0.1", 3334);

  //create cubes
  cubes = new Cube[nCubes];
  for (int i = 0; i< nCubes; ++i) {
    cubes[i] = new Cube(i);
  }

  // ATTN: Should we keep frameRate limit here? -Chi
  frameRate(framerate);
  if (WindowsMode) {
    check_connection();
  }
  /* Toio Initializing End -Chi */

  /* Oliver's section filtering the data down. */
  FireData[] toioOut = toioFireData(fireDataArray, 5, 10, 0000, 2399);
  

  /* Creating the Projection */
  img = loadImage("map.jpg");
  size(910, 410);
  background(0);
 }
 
 void draw() {
  background(0);
  image(img, mapXStart, mapYStart, mapXEnd, mapYEnd);
   
  drawLoadingDock(800, 50, "Loading Dock", 5);
  drawTimeline(50, 850, 390, 24, 800 / 24);

  /* Drawing related to TOIO goes here, Start -Chi*/
  // get target locations for toio
  latLon2MatLoc
  // set the target locations for toio
  // spin the toio


  //draw the cubes
  pushMatrix();
  translate(xOffset, yOffset);

  for (int i = 0; i < nCubes; i++) {
    cubes[i].checkActive(now);

    if (cubes[i].isActive) {
      pushMatrix();
      translate(cubes[i].x, cubes[i].y);
      fill(0);
      textSize(15);
      text(i, 0, -20);
      noFill();
      rotate(cubes[i].theta * PI/180);
      rect(-10, -10, 20, 20);
      line(0, 0, 20, 0);
      popMatrix();
    }
  }
  popMatrix();
  /* Drawing related to TOIO goes here, End -Chi*/
 }

void drawTimeline(float startX, float endX, float y, int totalHours, float spacing) {
  stroke(255);
  strokeWeight(2);
  
  line(startX, y, endX, y);

  for (int i = 0; i < totalHours; i++) {
    float x = startX + i * spacing;

    line(x, y - 10, x, y + 10);

    textAlign(CENTER, TOP);
    textSize(12);
    fill(255, 255, 255);
    text(i + ":00", x, y -25);
  }
}
 
 void drawLoadingDock(float x, float y, String text, int numSpots) {
  int rectWidth = 200;
  int rectHeight = 50;
  fill(200, 0, 0);
  stroke(0);
  rect(x - (rectWidth / 2), y - (rectHeight / 2), 200, 50);

  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(text, x, y);
  
  for (int i = 0; i < numSpots; i++) {
    fill (200, 0, 0);
    stroke(0);
    float spacing = ((410 - y - 100) / numSpots);
    rect(x-15, y + (spacing * i) + 50, 30, 30);
  }
 }
 
// convert the latitude and longitude to the x and y coordinates on the map
int[] latLon2MatLoc(float lat, float lon) {
  int[] matLoc = new int[2];
  int mapLongtitudeStart = -180;
  int mapLongtitudeEnd = 180;
  int mapLatitudeStart = -90;
  int mapLatitudeEnd = 90;
  matLoc[0] = int(map(lon, mapLongtitudeStart,mapLongtitudeEnd, mapXStart, mapXEnd));
  matLoc[1] = int(map(lat, mapLatitudeStart, mapLatitudeEnd, mapYStart, mapYEnd));
  return matLoc;
}

// read time input from timeline toio [ATTN] io -Chi
int readTimeInput() {
  // read the x coordinate of the toio
  int x = cubes[cubeTimeInput[0]].x;
  int timelineXStart = 50;
  int timelineXEnd = 800;
  int timelineTimeStart = 0;
  int timelineTimeEnd = 24;
  // convert the x coordinate to the time
  int time = int(map(x, timelineXStart, timelineXEnd, timelineTimeStart, timelineTimeEnd));
  return time;
}