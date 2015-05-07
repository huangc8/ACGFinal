class BoundBox {
  public int maxX =0;
  public int minX =0;
  public int maxY =0;
  public int minY =0;
  private int MX = 0;
  private int MY = 0;
  private int mX = 0;
  private int mY = 0;

  // constructor
  public BoundBox(int x, int y, int dim, float dt) {
    maxX = x + dim;
    minX = x - dim;
    maxY = y + dim;
    minY = y - dim;

    int dtmp = int(dim * dt/100);
    MX = maxX + dtmp;
    mX = minX - dtmp;
    MY = maxY + dtmp;
    mY = minY - dtmp;
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
    line(mX, MY, MX, MY);
    line(MX, MY, MX, mY);
    line(MX, mY, mX, mY);
    line(mX, mY, mX, MY);
  }

  // draw a blue box
  public void drawBoxBlue() {
    strokeWeight(1);
    stroke(0, 0, 255);
    line(mX, MY, MX, MY);
    line(MX, MY, MX, mY);
    line(MX, mY, mX, mY);
    line(mX, mY, mX, MY);
  }
}

