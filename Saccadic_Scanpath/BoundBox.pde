class BoundBox {
  public int maxX =0;
  public int minX =0;
  public int maxY =0;
  public int minY =0;

  // constructor
  public BoundBox(int x, int y, int dim) {
    maxX = x + dim;
    minX = x - dim;
    maxY = y + dim;
    minY = y - dim;
  }

  // check if inside box
  public boolean inBox(int x, int y) {
    if (x <= maxX && x >= minX && y <= maxY && y >= minY) {
      return true;
    }
    return false;
  }

  // draw the box 
  public void drawBox() {
    strokeWeight(1);
    stroke(255, 0, 0);
    line(minX, maxY, maxX, maxY);
    line(maxX, maxY, maxX, minY);
    line(maxX, minY, minX, minY);
    line(minX, minY, minX, maxY);
  }
}

