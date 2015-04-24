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
