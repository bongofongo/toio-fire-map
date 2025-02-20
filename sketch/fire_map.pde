import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;

PGraphics offscreen;
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

ExpandingCircle[] circles = new ExpandingCircle[7];

void settings() {
  size(1980, 1080, P3D);
}

void setup_map() {
  fireDataArray = loadData2FireDataArray(dataFile);
  stringArray = loadData2StringArray(dataFile);

  /* Oliver's section filtering the data down. */
  FireData[] toioOut = toioFireData(fireDataArray, 5, 10, 0000, 2399);

  /* Change the default circle look here, but chagne indidual ones elsewhere. */
  for (int i = 0; i < circles.length; i++) {
    float x = 0;
    float y = 0;
    float expansionRate = 1;
    float maxDiameter = 50;
    circles[i] = new ExpandingCircle(x, y, expansionRate, maxDiameter);
  }
  
  /* Creating the Projection */
  img = loadImage("map.jpg");

  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(910, 410, 20);
  offscreen = createGraphics(910, 410, P3D);
  background(0);
 }
 
 void draw_map() {
  offscreen.beginDraw();
  offscreen.background(0);
  offscreen.image(img, mapXStart, mapYStart, mapXEnd, mapYEnd);
  long now = System.currentTimeMillis();

  drawLoadingDock(800, 50, "Loading Dock", 5);
  drawTimeline(50, 850, 390, 24, 800 / 24);

  /* Drawing related to TOIO goes here, Start -Chi*/
  // get target locations for toio
  // latLon2MatLoc
  // set the target locations for toio
  // spin the toio


  //draw the cubes
  //pushMatrix();
  //translate(xOffset, yOffset);

  //for (int i = 0; i < nCubes; i++) {
  //  cubes[i].checkActive(now);

  //  if (cubes[i].isActive) {
  //    pushMatrix();
  //    translate(cubes[i].x, cubes[i].y);
  //    fill(0);
  //    textSize(15);
  //    text(i, 0, -20);
  //    noFill();
  //    rotate(cubes[i].theta * PI/180);
  //    rect(-10, -10, 20, 20);
  //    line(0, 0, 20, 0);
  //    popMatrix();
  //  }
  //}
  //popMatrix();
  /* Drawing related to TOIO goes here, End -Chi*/
  
  offscreen.endDraw();
  
  // surface.render(offscreen);
 }

void drawTimeline(float startX, float endX, float y, int totalHours, float spacing) {
  offscreen.stroke(255);
  offscreen.strokeWeight(2);
  
  offscreen.line(startX, y, endX, y);

  for (int i = 0; i < totalHours; i++) {
    float x = startX + i * spacing;

    offscreen.line(x, y - 10, x, y + 10);

    offscreen.textAlign(CENTER, TOP);
    offscreen.textSize(12);
    offscreen.fill(255, 255, 255);
    offscreen.text(i + ":00", x, y -25);
  }
}
 
 void drawLoadingDock(float x, float y, String text, int numSpots) {
  int rectWidth = 200;
  int rectHeight = 50;
  offscreen.fill(200, 0, 0);
  offscreen.stroke(0);
  offscreen.rect(x - (rectWidth / 2), y - (rectHeight / 2), 200, 50);

  offscreen.fill(255);
  offscreen.textSize(20);
  offscreen.textAlign(CENTER, CENTER);
  offscreen.text(text, x, y);
  
  for (int i = 0; i < numSpots; i++) {
    offscreen.fill (200, 0, 0);
    offscreen.stroke(0);
    float spacing = ((410 - y - 100) / numSpots);
    offscreen.rect(x-15, y + (spacing * i) + 50, 30, 30);
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
