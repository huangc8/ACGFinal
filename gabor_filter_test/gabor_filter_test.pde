PImage img;
PImage out;
PImage s;
Gabor a_gabor;
Sample samp;
Graph activation;

void load_pixel(PImage im, ArrayList<FloatList> res) {
    for (int i=0; i<im.height; i++) {
//      println(i);
    for (int j=0; j<im.width; j++) {
//        print(a_gabor.results.get(0).values.get(i).get(j), "||");
      im.pixels[i*im.width + j] = color(res.get(i).get(j));
    }
//      println();
  }
}


void setup() {
  
  img = loadImage("contour.png");
  out = loadImage("contour.png");
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

  a_gabor.just_do_it(angles);
  load_pixel(out, a_gabor.res);

  out.updatePixels();
//  out.filter(BLUR, 3);
  out.save("out.jpg");
  
  samp = new Sample(a_gabor.res, out.width, out.height, int(a_gabor.lambda));
  samp.down_sample();
  
//  for (int i=0; i<samp.n_h; i++) {
//    for (int j=0; j<samp.n_w; j++) {
//      print(samp.result.get(i).get(j), " || ");
//    }
//    println();
//  }
  
  println("smaller dimension: ", samp.n_w, " x ", samp.n_h);
  println("actual dimension: ", samp.result.get(0).size(), " x ", samp.result.size());
  
  activation = new Graph(samp.result, samp.n_w, samp.n_h);
  println("BEFORE: ==========================");
  
  for (int a=0; a<activation.nodes.size(); a++) {
    println(activation.nodes.get(a));
  }
  
  activation.distribute(4);
  println("AFTER: ==========================");
  for (int a=0; a<activation.nodes.size(); a++) {
    println(activation.nodes.get(a));
  }
  
  
  s = createImage(samp.n_w, samp.n_h, RGB);
  load_pixel(s, activation.result);
  s.updatePixels();
  s.save("small.jpg");
  s.resize(img.width, img.height);
}

void draw() {
  background(100, 170, 230);
  image(img, 0, 0);
  image(out, img.width, 0);
  image(s, 2*img.width, 0);
}
