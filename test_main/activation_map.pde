
class ActivationMap {
  public ArrayList<FloatList> act;
  public ArrayList<FloatList> raw_map;
  public int w;
  public int h;
  public int k_size;
  private float max = 0.0;
  private float min = 0.0;
  
  public ActivationMap(ArrayList<FloatList> raw, int wi, int hi, int k) {
    raw_map = new ArrayList<FloatList>(raw);
    w = wi;
    h = hi;
    k_size = k;
    
    activate();
  }
  
// Clamps result image values to 0-255
  private void clamp(ArrayList<FloatList> re) {
    if (re.size() < 1) {return;}
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float org = re.get(i).get(j);
        float clamped = map(org, min, max, 0, 256);
        re.get(i).set(j, clamped);
      }
    }
  }
  
  private void activate() {
    act = new ArrayList<FloatList>();
    float magic_constant = w/7.0;
    for (int i=0; i<h; i++) {
      FloatList tmp = new FloatList();
      for (int j=0; j<w; j++) {
        float sum = 0.0;
        int start_p = i - (k_size-1)/2;
        int start_q = j - (k_size-1)/2;
        int end_p = i + (k_size-1)/2;
        int end_q = j + (k_size-1)/2;
        if (start_p < 0) {start_p = 0;}
        if (start_q < 0) {start_q = 0;}
        if (end_p >= h) {end_p = h-1;}
        if (end_q >= w) {end_q = w-1;}
        for (int p=start_p; p<=end_p; p++) {
          for (int q=start_q; q<=end_q; q++) {
            float d = abs(raw_map.get(i).get(j) - raw_map.get(p).get(q));
            float f = exp(-((pow(i-p, 2.0)+pow(j-q, 2.0))/(2*pow(magic_constant, 2.0))));
            float w = d*f;
            sum += w;
          }
        }
        
        if (sum > max) {max = sum;}
        if (sum < min) {min = sum;}
        
        tmp.append(sum);
      }
      act.add(tmp);
    }
    clamp(act);
  }
  
}
