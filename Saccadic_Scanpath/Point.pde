class Point{
  public int x;
  public int y;
  public float sv;
  
  public Point(int px, int py, float psv){
    x = px;
    y = py;
    sv = psv;
  }
  
  public String toString(){
    String s = x + ":" + y + " " + sv;
    return s;
  }
}
