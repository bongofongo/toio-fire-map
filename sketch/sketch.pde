boolean debug = false; // Set to false to disable debug prints
void setup() {
  if (debug) println("A");
  setup_toio();
  if (debug) println("B");
  setup_map();
  if (debug) println("C");
  if (debug) delay(1000); // Give some time for setup to complete
}

void draw() {

  if (debug) println("0");
  offscreen.beginDraw();

  if (debug) println("1");
  draw_toio();

  if (debug) println("2");
  draw_map();

  if (debug) println("3");
  offscreen.endDraw();
  background(0);

  if (debug) println("4");
  surface.render(offscreen);
}
