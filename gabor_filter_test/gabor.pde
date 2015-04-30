
class Gabor {
  public ArrayList<ArrayList<Color>> pix;
  public ArrayList<FloatList> res = new ArrayList<FloatList>();          // combined result
  public ArrayList<FloatList> gabor_matrix = new ArrayList<FloatList>(); // gabor kernel
  public ArrayList<GaborCell> pouch = new ArrayList<GaborCell>();        // results from multiple orientations
  public int w;
  public int h;
  public float lambda;            // wavelength
  public float theta;             // orientation
  public float psi;               // phase offset
  public float sigma;             // standard deviation of Gaussian envelope
  public float gamma;             // aspect ratio
  public float min = 0.0;         // max and min values in the resulting image
  public float max = 0.0;
  public int k_size;              // kernel size
  
  public Gabor(ArrayList<ArrayList<Color>> c, int wi, int he) {
    pix = new ArrayList<ArrayList<Color>>(c);
    w = wi;
    h = he;
    
    lambda = 10.0;
    
    theta = radians(0);
    psi = 0.5;
    sigma = 0.56*lambda;
    gamma = 0.5;
    
    // decide kernel size
    if (gamma <= 1) {
      k_size = 2*ceil(2.5*sigma/gamma) + 1;
    }
    else {
      k_size = ceil(2.5*sigma);
    }
  }
  
  // Clamps result image values to 0-255
  private void clamp(ArrayList<FloatList> re) {
    if (re.size() < 1) {return;}
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float org = re.get(i).get(j);
        float clamped = map(org, min, max, 0, 255);
        re.get(i).set(j, clamped);
      }
    }
  }
  
//  make sure the sum of each entry from the gabor matrix is 0
  private void normalize_kernel(float pos, float neg) {
    if (gabor_matrix.size() < 1) {return;}
    float mean = abs(pos + neg)/2;
    if (mean > 0) {
      pos /= mean;
      neg /= mean;
   }
    for (int i=0; i<k_size; i++) {
        for (int j=0; j<k_size; j++) {
          float t = gabor_matrix.get(i).get(j);
          if (t < 0) {
            gabor_matrix.get(i).set(j, t/pos);
          }
          else {
            gabor_matrix.get(i).set(j, t/neg);
          }
        }
     }
    
    
  }
  
//  calculates the values to populate the gabor kernel(matrix)
  private void gabor_filter_calculation() {
    gabor_matrix = new ArrayList<FloatList>();
    float pos = 0.0;
    float neg = 0.0;
    
    for (int r=-(k_size-1)/2; r<(k_size-1)/2+1; r++) {
      FloatList tmp = new FloatList();
      for (int c=-(k_size-1)/2; c<(k_size-1)/2+1; c++) {
        float x = c;
        float y = r;
        float x_ = x*cos(theta) + y*sin(theta);
        float y_ = -x*sin(theta) + y*cos(theta);
        
        float g = exp(-((pow(x_,2) + (pow(gamma,2)*pow(y_,2)))/(2*pow(sigma, 2)))) * cos(((2*PI*x_)/lambda) + psi);
        
        tmp.append(g);
        if (g >= 0) {pos += g;}
        else {neg += g;}
      }
      gabor_matrix.add(tmp);
    }
    normalize_kernel(pos, abs(neg));
  }
  
//  applies the kernel to each pixel on the image, and store the result
  private void generation() {
    min = 0.0;
    max = 0.0;
    ArrayList<FloatList> re = new ArrayList<FloatList>();
    
    int k_center = (k_size-1)/2;
    for (int r=0; r<h; r++) {
      int k_y = r - k_center;
      FloatList tmp = new FloatList();
      
      for (int c=0; c<w; c++) {
        int k_x = c - k_center;
        float sum = 0.0;
        
        for (int y=0; y<k_size; y++) {
          for (int x=0; x<k_size; x++) {
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
      re.add(tmp);
    }
    clamp(re);
    
    GaborCell gc = new GaborCell(re, w, h, theta);
    pouch.add(gc);
  }
  
//  combine results
  private void combine() {
    res = new ArrayList<FloatList>();
    for (int i=0; i<h; i++) {
      FloatList tmp = new FloatList();
      for (int j=0; j<w; j++) {
        float acc = 0.0;
        for (int n=0; n<pouch.size(); n++) {
          acc += pouch.get(n).values.get(i).get(j);
        }
        if (acc > max) {max = acc;}
        if (acc < min) {min = acc;}
        tmp.append(acc);
      }
      res.add(tmp);
    }
  }
  
//  calculate multiple results and combine them
  public void just_do_it(IntList angles) {
    pouch = new ArrayList<GaborCell>();
    
    for (int angle : angles) {
      theta = radians(angle);
      gamma = 0.5;
      gabor_filter_calculation();
      generation();
      
      gamma = 0.25;
      gabor_filter_calculation();
      generation();
    }
    
    combine();
  }
  
}
