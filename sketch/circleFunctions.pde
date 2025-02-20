// PGraphics offscreen;
class ExpandingCircle {
  float x, y;
  float currentDiameter;
  float expansionRate;
  float maxDiameter;
  boolean removing;
  boolean finished;

  ExpandingCircle(float x, float y, float expansionRate, float maxDiameter) {
    this.x = x;
    this.y = y;
    this.expansionRate = expansionRate;
    this.maxDiameter = maxDiameter;
    this.currentDiameter = 0;  // Start with a circle of size 0
    this.removing = false;
    this.finished = false;
  }

  void update() {
    if (!removing) {
      if (currentDiameter < maxDiameter) {
        currentDiameter += expansionRate;
        if (currentDiameter > maxDiameter) {
          currentDiameter = maxDiameter;
        }
      }
    } else {
      if (currentDiameter > 0) {
        currentDiameter -= expansionRate;
        if (currentDiameter < 0) {
          currentDiameter = 0;
        }
      } else {
        finished = true;
      }
    }
  }

  void display() {
    offscreen.noStroke();
    offscreen.fill(255, 0, 0);
    offscreen.ellipse(x, y, currentDiameter, currentDiameter);
  }

  void remove() {
    removing = true;
  }
  void show() {
    removing = false;
  }
}
