
class Gabor {
  public ArrayList<ArrayList<Color>> pix;
  public ArrayList<ArrayList<Color>> res;
  public int w;
  public int h;
  public float wavelength;
  public float orientation;
  public float offset;
  public float sigma;
  public float ratio;
  
  public Gabor(ArrayList<ArrayList<Color>> c, int wi, int he) {
    pix = new ArrayList<ArrayList<Color>>(c);
    w = wi;
    h = he;
    
    wavelength = 4.0;
    orientation = 0.0;
    offset = 0.0;
    sigma = 0.56*wavelength;
    ratio = 0.5;
    
    for (int i=0; i<pix.get(0).size(); i++) {
      println(pix.get(0).get(i));
    }
  }
  
//  public void gabor_filter() {
//    
//  }
}
