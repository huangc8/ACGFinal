import java.util.*;

class Node {
  public float value;
  public HashMap<Node, Float> neighbors;
  public int nrow;
  public int ncol;
  public float undistributed = 24.0;
  public float received = 0.0;
  
  public Node(float val, int r, int c) {
    value = val;
    nrow = r;
    ncol = c;
    neighbors = new HashMap<Node, Float>();
  }
  
  public void reset() {
    undistributed = 24.0;
    received = 0.0;
    neighbors = new HashMap<Node, Float>();
  }
  
  public String toString() {
    String s = "value: " + str(value) + "\nlocation: (" + str(nrow) + ", " + str(ncol) + ")\n";
    s += "neighbors:\n";
    for (Node n : neighbors.keySet()) {
      s += "   (" + str(n.nrow) + ", " + str(n.ncol) + ") : " + str(neighbors.get(n)) + "\n";
    }
    
    return s;
  }
}
