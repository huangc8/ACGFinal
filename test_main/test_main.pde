PImage img;
PImage out;
Gabor a_gabor;
ActivationMap act_map;

void port_pixels(PImage im, ArrayList<ArrayList<Color>> data) {
  for (int i=0; i<im.height; i++) {
    for (int j=0; j<im.width; j++) {
//        print(a_gabor.results.get(0).values.get(i).get(j), "||");
//      im.pixels[i*im.width + j] = color(data.get(i).get(j).red, data.get(i).get(j).green, data.get(i).get(j).blue);
        im.pixels[i*im.width + j] = color(data.get(i).get(j).sat);
    }
  }
}

void setup() {
  
  img = loadImage("leaves.png");
  out = loadImage("leaves.png");
  img.loadPixels();
  out.loadPixels();
  
//  grab pixels from image
  ArrayList<ArrayList<Color>> pixies = new ArrayList<ArrayList<Color>>();
  for (int i=0; i<img.height; i++) {
    ArrayList<Color> tmp = new ArrayList<Color>();
    for (int j=0; j<img.width; j++) {
      tmp.add(new Color(red(img.pixels[i*img.width+j]), green(img.pixels[i*img.width+j]), blue(img.pixels[i*img.width+j])));
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
//  act_map = new ActivationMap(a_gabor.res, a_gabor.w, a_gabor.h, min(a_gabor.w, a_gabor.h)/10);
  
  port_pixels(out, a_gabor.res);

  out.updatePixels();
//  out.filter(ERODE);
//  out.filter(BLUR, 3);
  out.save("out.jpg");
}

void draw() {
  background(100, 170, 230);
  image(out, img.width, 0);
  image(img, 0, 0);
}
