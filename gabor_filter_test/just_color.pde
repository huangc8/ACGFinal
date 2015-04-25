// Just helper class for color, since color in processing is an int,
// which cannot be used in an arraylist
class Color {
  public color rgb;
  
  public Color(color c) {
    rgb = c;
  }
  
  public String toString() {
    String s = str(red(rgb)) + ' ' + str(green(rgb)) + ' ' + str(blue(rgb));
    return s;
  }
}
