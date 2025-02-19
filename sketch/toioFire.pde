/* Toio setting start -Chi */
import oscP5.*;
import netP5.*;
//TOIO constants
int nCubes = 4;
int cubesPerHost = 12;
int maxMotorSpeed = 115;
int xOffset = 0;
int yOffset = 0;

//// Instruction for Windows Users  (Feb 2. 2025) ////
// 1. Enable WindowsMode and set nCubes to the exact number of toio you are connecting.
// 2. Run Processing Code FIRST, Then Run the Rust Code. After running the Rust Code, you should place the toio on the toio mat, then Processing should start showing the toio position.
// 3. When you re-run the processing code, make sure to stop the rust code and toios to be disconnected (switch to Bluetooth stand-by mode [blue LED blinking]). If toios are taking time to disconnect, you can optionally turn off the toio and turn back on using the power button.
// Optional: If the toio behavior is werid consider dropping the framerate (e.g. change from 30 to 10)
//
boolean WindowsMode = false; //When you enable this, it will check for connection with toio via Rust first, before starting void loop()

int framerate = 30;

int[] matDimension = {45, 45, 955, 455};
//// this shoule be in map file, TODO, -Chi
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
int[] cubeFires = {1, 2, 3};
ToioFire[] toioFires = new ToioFire[cubeFires.length];
/* Toio Setting End -Chi */


void setup_toio() {
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
    // assign toio to fire toio
  for (int i = 0; i < cubeFires.length; i++) {
    toioFires[i] = new ToioFire(cubes[cubeFires[i]], eventSet1[i]);
  }
  /* Toio Initializing End -Chi */

  
 }
 
 void draw_toio() {

  /* Drawing related to TOIO goes here, Start -Chi*/
  // get target locations for toio
  // latLon2MatLoc
  // set the target locations for toio
  // draw the cubes

  background(255);
  stroke(0);
  long now = System.currentTimeMillis();

  //draw the "mat"
  fill(255);
  rect(matDimension[0], matDimension[1], matDimension[2] - matDimension[0], matDimension[3] - matDimension[1]);

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
  toioUpdate(toioFires);
 }


// each Event includes a target position and a brightness value
class Event {
  int x;
  int y;
  int brightness;
  Event(int x, int y, int brightness) {
    this.x = x;
    this.y = y;
    this.brightness = brightness;
  }
}

// two sample Event sets for testing
Event[] eventSet1 = {
  new Event(350, 360, 100),
  new Event(180, 73, 40),
  new Event(120, 120, 70),
  new Event(90, 180, 100),
  new Event(90, 120, 60)
};
Event[] eventSet2 = {
  new Event(100, 250, 80),
  new Event(200, 100, 60),
  new Event(300, 150, 100),
  new Event(400, 200, 20),
  new Event(500, 250, 10)
};


class ToioFire {
  Cube cube;
  Event event;
  ToioFire(Cube cube_, Event event_) {
    this.cube = cube_;
    this.event = event_;
  }
}

// the function that checks toio position, if at position, then spin, else move to position
void toioUpdate(ToioFire[] toioFires) {
  // set the margin of error for the toio to reach the target
  int margin = 15;
  for (int i = 0; i < toioFires.length; i++) {
    ToioFire toioFire = toioFires[i];
    Cube cube = toioFire.cube;
    Event event = toioFire.event;
    if (abs(cube.x - event.x) < margin && abs(cube.y - event.y) < margin) {
      cube.spin(event.brightness); // TODO: map brightness to speed
    } else {
      // set the target theta as the angle between the current position and the target position
      int targetTheta = int(atan2(event.y - cube.y, event.x - cube.x));
      cube.target(event.x, event.y, targetTheta);
    }
  }
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

// change the ToioFire with a new fire data eventset
void changeToioFire(ToioFire[] toioFires, Event[] eventSet) {
    // if event set is less than the number of toio, set the rest to a basic event
    // if (eventSet.length < toioFires.length) {
    //   Event[] newEventSet = new Event[toioFires.length];
    //   for (int i = 0; i < eventSet.length; i++) {
    //     newEventSet[i] = eventSet[i];
    //   }
    //   for (int i = eventSet.length; i < toioFires.length; i++) {
    //     newEventSet[i] = new Event(0, 0, 0);
    //   }
    //   eventSet = newEventSet;
    // }
    
  for (int i = 0; i < toioFires.length; i++) {
    ToioFire toioFire = toioFires[i];
    Event event = eventSet[i];
    toioFire.event = event;
  }
}
