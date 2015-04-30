import java.util.Map;

// Helper class that handles a single gabor filter result image,
// and normalizes it to the background
class GaborCell {
  public ArrayList<ArrayList<Color>> values;
  public Color background;
  public float orientation;
  public int w;
  public int h;
  
  public GaborCell(ArrayList<ArrayList<Color>> v, int wi, int hi, float o) {
    values = new ArrayList<ArrayList<Color>>(v);
    w = wi;
    h = hi;
    orientation = o;
    calculate_background();
    blacken();
  }
  
//  After experimenting with getting the most frequent pixel, the
//  average yields pretty good results
  private void calculate_background() {
    float r = 0.0;
    float g = 0.0;
    float b = 0.0;
    int total = w*h;
    
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        Color c = values.get(i).get(j);
        r += c.red;
        g += c.green;
        b += c.blue;
      }
    }
    
    background = new Color(r/total, g/total, b/total);
  }
  
//  set the background to black and all variations to lighter values
  public void blacken() {
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float dr = abs(background.red - values.get(i).get(j).red);
        float dg = abs(background.green - values.get(i).get(j).green);
        float db = abs(background.blue - values.get(i).get(j).blue);
        Color col = new Color(dr, dg, db);
        col.sat = dr + dg + db;
        values.get(i).set(j, col);
      }
    }
  }
}

