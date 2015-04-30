PImage img;
PImage out;
Gabor a_gabor;

void setup() {
  
  img = loadImage("MB.jpg");
  out = loadImage("MB.jpg");
  img.loadPixels();
  out.loadPixels();
  
//  grab pixels from image
  ArrayList<ArrayList<Color>> pixies = new ArrayList<ArrayList<Color>>();
  for (int i=0; i<img.height; i++) {
    ArrayList<Color> tmp = new ArrayList<Color>();
    for (int j=0; j<img.width; j++) {
      tmp.add(new Color(img.pixels[i*img.width+j]));
    }
    pixies.add(tmp);
  }
  
  a_gabor = new Gabor(pixies, img.width, img.height);
  
  size(2*img.width, img.height, P2D);
  
  IntList angles = new IntList();
  angles.append(0);
  angles.append(90);
  angles.append(45);
  angles.append(135);

  a_gabor.just_do_it(angles);
  for (int i=0; i<a_gabor.h; i++) {
//      println(i);
    for (int j=0; j<a_gabor.w; j++) {
//        print(a_gabor.results.get(0).values.get(i).get(j), "||");
      out.pixels[i*a_gabor.w + j] = color(a_gabor.res.get(i).get(j));
    }
//      println();
  }
  out.updatePixels();
  PImage outie = createImage(out.width, out.height, RGB);
  outie = out.get();
  outie.save("out.jpg");
  
}

void draw() {
  background(100, 170, 230);
  image(img, 0, 0);
  image(out, img.width, 0);
}
