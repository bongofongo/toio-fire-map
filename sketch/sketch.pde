void setup() {
  setup_toio();
  setup_map();
}

void draw() {
  offscreen.beginDraw();

  draw_toio();
  draw_map();

  offscreen.endDraw();
  background(0);
  surface.render(offscreen);
}
