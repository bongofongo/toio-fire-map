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

void setup() {
  fireDataArray = loadData2FireDataArray(dataFile);
  stringArray = loadData2StringArray(dataFile);
  
  /* Oliver's section filtering the data down. */
  FireData[] toioOut = toioFireData(fireDataArray, 5, 10, 0000, 2399);
  

  /* Creating the Projection */
  img = loadImage("map.jpg");
  size(910, 410);
  background(0);
 }
 
 void draw() {
  background(0);
  image(img, 0, 0, 655, 310);
   
  drawLoadingDock(800, 50, "Loading Dock", 5);
  drawTimeline(50, 850, 390, 24, 800 / 24);
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
 
