import java.util.Map;

// Helper class that handles a single gabor filter result image,
// and normalizes it to the background
class GaborCell {
  public ArrayList<FloatList> values;
  public float background;
  public float orientation;
  public int w;
  public int h;
  
  public GaborCell(ArrayList<FloatList> v, int wi, int hi, float o) {
    values = new ArrayList<FloatList>(v);
    w = wi;
    h = hi;
    orientation = o;
    calculate_background();
    blacken();
  }
  
//  After experimenting with getting the most frequent pixel, the
//  average yields pretty good results
  private void calculate_background() {
    float sum = 0.0;
    int total = w*h;
    
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        sum += values.get(i).get(j);
      }
    }
    
    background = sum/total;
  }
  
//  set the background to black and all variations to lighter values
  public void blacken() {
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float delta = abs(background - values.get(i).get(j));
        values.get(i).set(j, delta);
      }
    }
  }
}

