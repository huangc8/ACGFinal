PImage img;
Gabor a_gabor;

void setup() {
  size(960, 720, P2D);
  img = loadImage("korla.jpg");
  img.loadPixels();
  ArrayList<ArrayList<Color>> pixies = new ArrayList<ArrayList<Color>>();
  for (int i=0; i<img.height; i++) {
    ArrayList<Color> tmp = new ArrayList<Color>();
    for (int j=0; j<img.width; j++) {
      tmp.add(new Color(img.pixels[i*img.width+j]));
    }
    pixies.add(tmp);
  }
  
  a_gabor = new Gabor(pixies, img.width, img.height);
}

void draw() {
  background(100, 170, 230);
  image(img, 0, 0);
}
