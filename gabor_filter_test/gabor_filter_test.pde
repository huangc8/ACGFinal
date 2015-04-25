PImage img;
PImage out;
Gabor a_gabor;

void setup() {
  
  img = loadImage("portrait_boy.jpg");
  out = loadImage("portrait_boy.jpg");
  img.loadPixels();
  out.loadPixels();
  
  ArrayList<ArrayList<Color>> pixies = new ArrayList<ArrayList<Color>>();
  for (int i=0; i<img.height; i++) {
    ArrayList<Color> tmp = new ArrayList<Color>();
    for (int j=0; j<img.width; j++) {
      tmp.add(new Color(img.pixels[i*img.width+j]));
    }
    pixies.add(tmp);
  }
  
  a_gabor = new Gabor(pixies, img.width, img.height);
  
  size(img.width, img.height, P2D);
  a_gabor.gabor_filter_calculation();
  a_gabor.generation();
  for (int i=0; i<a_gabor.h; i++) {
    println(i);
    for (int j=0; j<a_gabor.w; j++) {
      print(a_gabor.res.get(i).get(j), "||");
      out.pixels[i*a_gabor.w + j] = color(a_gabor.res.get(i).get(j));
    }
    println();
  }
  out.updatePixels();
  PImage outie = createImage(out.width, out.height, RGB);
  outie = out.get();
  outie.save("out.jpg");
  
}

void draw() {
  background(100, 170, 230);
  image(img, 0, 0);
}
