
class Gabor {
  public ArrayList<ArrayList<Color>> pix;
  public ArrayList<FloatList> res = new ArrayList<FloatList>();
  public ArrayList<FloatList> gabor_matrix = new ArrayList<FloatList>();
  public int w;
  public int h;
  public float lambda;            // wavelength
  public float theta;             // orientation
  public float psi;               // phase offset
  public float sigma;             // standard deviation of Gaussian envelope
  public float gamma;             // aspect ratio
  public float min = 0.0;
  public float max = 0.0;
  public int k_w = 30;
  public int k_h = 30;
  
  public Gabor(ArrayList<ArrayList<Color>> c, int wi, int he) {
    pix = new ArrayList<ArrayList<Color>>(c);
    w = wi;
    h = he;
    
    lambda = 10.0;
    theta = radians(45);
    psi = 0.0;
    sigma = 0.56*lambda;
    gamma = 0.5;
    
    if (min(wi, he)/2 < 30) {
      k_w = ceil(min(wi, he)/2);
      if (k_w%2 == 0) {
        k_w += 1;
      }
      k_h = k_w;
    }
  }
  
  // Clamps result image values to 0-255
  public void clamp() {
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float org = res.get(i).get(j);
        float clamped = (org-min)*255/(max-min);
        res.get(i).set(j, clamped);
      }
    }
  }
  
  // calculates the values to populate the gabor kernel(matrix)
  public void gabor_filter_calculation() {
    for (int r=0; r<k_h; r++) {
      FloatList tmp = new FloatList();
      for (int c=0; c<k_w; c++) {
        float x = c;
        float y = r;
        float x_ = x*cos(theta) + y*sin(theta);
        float y_ = -x*sin(theta) + y*cos(theta);
        
        float g = exp(-((pow(x_,2) + (pow(gamma,2)*pow(y_,2)))/(2*pow(sigma, 2)))) * cos(((2*PI*x_)/lambda) + psi);
        
        tmp.append(g);
      }
      gabor_matrix.add(tmp);
    }
  }
  
  // applies the kernel to each pixel on the image
  public void generation() {
    int k_center = (k_w-1)/2;
    for (int r=0; r<h; r++) {
      int k_y = r - k_center;
      FloatList tmp = new FloatList();
      for (int c=0; c<w; c++) {
        int k_x = c - k_center;
        float sum = 0.0;
        for (int y=0; y<k_h; y++) {
          for (int x=0; x<k_w; x++) {
            if (min(x+k_x, y+k_y) < 0 || x+k_x > w-1 || y+k_y > h-1) {continue;}
            float g_val = gabor_matrix.get(y).get(x);
            float p = brightness(pix.get(y+k_y).get(x+k_x).rgb);
            sum += g_val * p;
          }
        }
        if (sum > max) {max = sum;}
        if (sum < min) {min = sum;}
        tmp.append(sum);
      }
      res.add(tmp);
    }
    clamp();
  }
}
