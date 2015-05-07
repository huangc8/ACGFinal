class SaccData {
  ArrayList<PVector> locs;        // list of fixation locations
  FloatList times;                // list of fixation duration in seconds
  int w;
  int h;
  int next;                       // next fixation location
  PVector org_loc;

  public SaccData(String file) {
    String[] allData = loadStrings(file);
    locs = new ArrayList<PVector>();
    times = new FloatList();
    
    for (int i=0; i<allData.length; i++) {
      if (i==0) {
        String[] dimensions = trim(split(allData[i], ' '));
        w = int(dimensions[0]);
        h = int(dimensions[1]);
        next = 0;
        org_loc = new PVector(w/2, h/2);
      }
      else {
        String[] fix = trim(split(allData[i], ' '));
        Float t = float(fix[0]);
        times.append(t);
        locs.add(new PVector(float(fix[1]), float(fix[2])));
      }
    }
    
    for (int j=0; j<times.size(); j++) {
      println(times.get(j), ": ", locs.get(j));
    }   
  }
  
  public PVector get_next_loc() {
    return locs.get(next);
  }
  
  public int update() {
    next = next + 1;
    
    if (next >= locs.size()) {
      return -1;
    }
    return 0;
  }
  
  public int get_fixation() {
    if (next < times.size()) {
      return ceil(times.get(next)*0.001*60);
    }
    else {return -1;}
  }
}
