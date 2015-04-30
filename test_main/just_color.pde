// Just helper class for color, since color in processing is an int,
// which cannot be used in an arraylist
class Color {
  public float red;
  public float green;
  public float blue;
  public float sat;
  
  public Color(float r, float g, float b) {
    red = r;
    green = g;
    blue = b;
    sat = -1.0;
  }
  
  public String toString() {
    String s = str(red) + ' ' + str(green) + ' ' + str(blue);
    return s;
  }
}
