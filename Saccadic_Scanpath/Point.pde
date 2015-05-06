class Point {
  public int x;
  public int y;
  public float sv;

  public Point(int px, int py, float psv) {
    x = px;
    y = py;
    sv = psv;
  }

  public Point clone() {
    Point pc = new Point(x, y, sv);
    return pc;
  }

  public String toString() {
    String s = x + ":" + y + " " + sv;
    return s;
  }
}

