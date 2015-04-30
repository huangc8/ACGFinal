
class Gabor {
  public ArrayList<ArrayList<Color>> pix;
  public ArrayList<ArrayList<Color>> res = new ArrayList<ArrayList<Color>>();          // combined result
  public ArrayList<FloatList> gabor_matrix = new ArrayList<FloatList>(); // gabor kernel
  public ArrayList<GaborCell> pouch = new ArrayList<GaborCell>();        // results from multiple orientations
  public int w;
  public int h;
  public float lambda;            // wavelength
  public float theta;             // orientation
  public float psi;               // phase offset
  public float sigma;             // standard deviation of Gaussian envelope
  public float gamma;             // aspect ratio
  public float minr = 0.0;         // max and min values in the resulting image
  public float ming = 0.0;
  public float minb = 0.0;
  public float maxr = 0.0;
  public float maxg = 0.0;
  public float maxb = 0.0;
  public float maxs = 0.0;
  public float mins = 0.0;
  public int k_size;              // kernel size
  
  public Gabor(ArrayList<ArrayList<Color>> c, int wi, int he) {
    pix = new ArrayList<ArrayList<Color>>(c);
    w = wi;
    h = he;
    
    lambda = 8.0;
    
    theta = radians(0);
    psi = 0;
    sigma = 0.56*lambda;
    gamma = 0.5;
    
    // decide kernel size
    if (gamma <= 1) {
      k_size = 2*ceil(2.5*sigma/gamma) + 1;
    }
    else {
      k_size = ceil(2.5*sigma);
    }
    println("kernel size: ", k_size);
  }
  
  // Clamps result image values to 0-255
  private void clamp(ArrayList<ArrayList<Color>> re) {
    if (re.size() < 1) {return;}
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float orgr = re.get(i).get(j).red;
        float orgg = re.get(i).get(j).green;
        float orgb = re.get(i).get(j).blue;
        float orgs = re.get(i).get(j).sat;
        orgr = map(orgr, minr, maxr, 0, 256);
        orgg = map(orgg, ming, maxg, 0, 256);
        orgb = map(orgb, minb, maxb, 0, 256);
        if (orgs >= 0.0) {
          orgs = map(orgs, mins, maxs, 0, 256);
        }
        
        Color col = new Color(orgr, orgg, orgb);
        col.sat = orgs;
        re.get(i).set(j, col);
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
    minr = 0.0;
    maxr = 0.0;
    ming = 0.0;
    maxg = 0.0;
    minb = 0.0;
    maxb = 0.0;
    ArrayList<ArrayList<Color>> re = new ArrayList<ArrayList<Color>>();
    
    int k_center = (k_size-1)/2;
    for (int r=0; r<h; r++) {
      int k_y = r - k_center;
      ArrayList<Color> tmp = new ArrayList<Color>();
      
      for (int c=0; c<w; c++) {
        int k_x = c - k_center;
        float rs = 0.0;
        float g = 0.0;
        float b = 0.0;
        
        for (int y=0; y<k_size; y++) {
          for (int x=0; x<k_size; x++) {
            if (min(x+k_x, y+k_y) < 0 || x+k_x > w-1 || y+k_y > h-1) {continue;}
            float g_val = gabor_matrix.get(y).get(x);
//            float p = brightness(pix.get(y+k_y).get(x+k_x).rgb);
            Color p = pix.get(y+k_y).get(x+k_x);
            rs += g_val * p.red;
            g += g_val * p.green;
            b += g_val * p.blue;
          }
        }
        
        if (rs > maxr) {maxr = rs;}
        if (rs < minr) {minr = rs;}
        
        if (g > maxg) {maxg = g;}
        if (g < ming) {ming = g;}
        
        if (b > maxb) {maxb = b;}
        if (b < minb) {minb = b;}
        tmp.add(new Color(rs, g, b));
      }
      re.add(tmp);
    }
    clamp(re);
    
    GaborCell gc = new GaborCell(re, w, h, theta);
    pouch.add(gc);
  }
  
//  combine results
  private void combine() {
    minr = 0.0;
    maxr = 0.0;
    ming = 0.0;
    maxg = 0.0;
    minb = 0.0;
    maxb = 0.0;
    maxs = 0.0;
    mins = 0.0;
    res = new ArrayList<ArrayList<Color>>();
    for (int i=0; i<h; i++) {
      ArrayList<Color> tmp = new ArrayList<Color>();
      for (int j=0; j<w; j++) {
        float r = 0.0;
        float g = 0.0;
        float b = 0.0;
        float sa = 0.0;
        for (int n=0; n<pouch.size(); n++) {
          Color p = pouch.get(n).values.get(i).get(j);
          r += p.red;
          g += p.green;
          b += p.blue;
          sa += p.sat;
        }
        
        if (r > maxr) {maxr = r;}
        if (r < minr) {minr = r;}
        
        if (g > maxg) {maxg = g;}
        if (g < ming) {ming = g;}
        
        if (b > maxb) {maxb = b;}
        if (b < minb) {minb = b;}
        
        if (sa > maxs) {maxs = sa;}
        if (sa < mins) {mins = sa;}
        
        Color col = new Color(r, g, b);
        col.sat = sa;
        tmp.add(col);
      }
      res.add(tmp);
    }
    clamp(res);
  }
  
//  calculate multiple results and combine them
  public void just_do_it(IntList angles) {
    pouch = new ArrayList<GaborCell>();
    
    for (int angle : angles) {
      theta = radians(angle);
      psi = radians(0);
      gamma = 0.5;
      gabor_filter_calculation();
      generation();
      
      psi = radians(90);
      gabor_filter_calculation();
      generation();
    }
    
    combine();
  }
  
}
