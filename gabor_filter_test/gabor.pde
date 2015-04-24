
class Gabor {
  public ArrayList<ArrayList<Color>> pix;
  public ArrayList<FloatList> res = new ArrayList<FloatList>();
  public int w;
  public int h;
  public float lambda;            // wavelength
  public float theta;             // orientation
  public float psi;               // phase offset
  public float sigma;             // standard deviation of Gaussian envelope
  public float gamma;             // aspect ratio
  public float min = 0.0;
  public float max = 0.0;
  
  public Gabor(ArrayList<ArrayList<Color>> c, int wi, int he) {
    pix = new ArrayList<ArrayList<Color>>(c);
    w = wi;
    h = he;
    
    lambda = 4.0;
    theta = radians(90);
    psi = 0.0;
    sigma = 0.56*lambda;
    gamma = 0.5;
    
//    for (int i=0; i<h; i++) {
//      for (int j=0; j<w; j++)
//        println(pix.get(i).get(j));
//    }
  }
  
  public void clamp() {
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float org = res.get(i).get(j);
        float clamped = (org-min)*255/(max-min);
        res.get(i).set(j, clamped);
        println(clamped);
      }
    }
  }
  
  public void gabor_filter() {
    for (int r=0; r<h; r++) {
      FloatList tmp = new FloatList();
      println(r, ":");
      for (int c=0; c<w; c++) {
        println("   ", c, ":");
        float gray = brightness(pix.get(r).get(c).rgb);
        float x = c;
        float y = r;
        float x_ = x*cos(theta) + y*sin(theta);
        float y_ = -x*sin(theta) + y*cos(theta);
        
        float g = exp(-((pow(x_,2) + pow(gamma,2)*pow(y_,2))/(2*pow(sigma, 2)))) * cos(2*PI*x_/lambda + psi);
        float re = g*gray;
        
        if (re < min) {min = re;}
        if (re > max) {max = re;}
        
        tmp.append(r);
        //println(g, gray, r);
      }
      res.add(tmp);
    }
    clamp();
  }
}
