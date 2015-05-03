PImage img;
PImage out;
PImage s;
Gabor a_gabor;
Sample samp;
Graph activation;
String filename = "MB.jpg";

// Helper function that loads greyscale values into image
void load_pixel(PImage im, ArrayList<FloatList> res) {
  for (int i=0; i<im.height; i++) {
    for (int j=0; j<im.width; j++) {
      im.pixels[i*im.width + j] = color(res.get(i).get(j));
    }
  }
}


void setup() {
  img = loadImage(filename);
  out = loadImage(filename);
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
  
  size(3*img.width, img.height, P2D);
  
  IntList angles = new IntList();
  angles.append(0);
  angles.append(90);
  angles.append(45);
  angles.append(135);

// do 4 orientations for extraction map
  a_gabor.just_do_it(angles);
  load_pixel(out, a_gabor.res);

  out.updatePixels();
//  out.filter(BLUR, 3);
  out.save("gabor_"+filename);
  
  samp = new Sample(a_gabor.res, out.width, out.height, int(a_gabor.lambda));
  samp.down_sample();
  
//  for (int i=0; i<samp.n_h; i++) {
//    for (int j=0; j<samp.n_w; j++) {
//      print(samp.result.get(i).get(j), " || ");
//    }
//    println();
//  }
  
//  Create activation graph, calculate edge weights and distribute mass
  activation = new Graph(samp.result, samp.n_w, samp.n_h);
  activation.distribute(4);
  
  s = createImage(samp.n_w, samp.n_h, RGB);
  load_pixel(s, activation.result);
  s.updatePixels();
  s.save("sal_org_" + filename);
  s.resize(img.width, img.height);
  s.save("sal_" + filename);
}

void draw() {
  background(100, 170, 230);
  image(img, 0, 0);
  image(out, img.width, 0);
  image(s, 2*img.width, 0);
}
