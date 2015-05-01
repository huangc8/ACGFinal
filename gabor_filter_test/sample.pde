
class Sample {
  public ArrayList<FloatList> pix;
  public ArrayList<FloatList> result = new ArrayList<FloatList>();
  public int w;
  public int h;
  public int cut;      //lambda
  public int n_w;
  public int n_h;
  public int sample_size;
  
  public Sample(ArrayList<FloatList> p, int wi, int he, int c) {
    pix = new ArrayList<FloatList>(p);
    w = wi;
    h = he;
    cut = c + 1;
    sample_size = 9;
  }
  
  public void get_size() {
    if (result.size() > 0) {
      n_w = result.get(0).size();
      n_h = result.size();
    }
  }
  
  public void down_sample() {
    int i=0;
    
    result = new ArrayList<FloatList>();

    while (i<h) { 
//      println("i: ", i);
      int end_i = 0;
      if (i>=cut && i<h-cut) {
        end_i = i + sample_size;
        if (h-end_i <= 0) {
          end_i = h-1;
        }
        else if (h-end_i < sample_size/2) {
          end_i = h-1;
        }
      }
      else {
        i += 1;
        continue;
      }
      FloatList tmp = new FloatList();
//      println("initialized row ", i);
      
      int j = 0;
      while (j<w) {
//        println("j: ", j);
        int end_j = 0;
        if (j<cut || j>=w-cut-1) {
          j += 1;
          continue;
        }
        else {
          end_j = j + sample_size;
          if (w-end_j <= 0) {end_j = w-1;}
          else if (w-end_j < sample_size/2) {
            end_j = w-1;
          }
        }
        
        float sum = 0.0;
        int count = 0;
        for (int y=i; y<=end_i; y++) {
          for (int x=j; x<=end_j; x++) {
            count += 1;
            sum += pix.get(y).get(x);
          }
        }
        
//        println("start: (", i, ", ", j, ")");
//        println("end: (", end_i, ", ", end_j, ")");
        
        tmp.append(sum/count);
        j = end_j + 1;
      }
      result.add(tmp);
      i = end_i + 1;
    }
    
    get_size();
  }
}
