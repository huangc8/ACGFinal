
class Graph {
  public ArrayList<FloatList> source;
  public ArrayList<FloatList> result;
  public ArrayList<ArrayList<Node>> nodes;
  public float max;
  public float min;
  public int w;
  public int h;
  public int n_size = 5;
  public float magic_constant;
  
  public Graph(ArrayList<FloatList> src, int wi, int he) {
    source = new ArrayList<FloatList>(src);
    w = wi;
    h = he;
    magic_constant = w/7.0;
    nodes = new ArrayList<ArrayList<Node>>();
    println("source size: ", source.size());
    
    add_nodes();
  }
  
//  create a node for every pixel value
  private void add_nodes() {
    println("starting to add nodes...");
    for (int i=0; i<h; i++) {
      ArrayList<Node> tmp = new ArrayList<Node>();
      for (int j=0; j<w; j++) {
        float v = source.get(i).get(j);
        Node n = new Node(v, i, j);
        println("added n at (", i, ", ", j, ")");
        tmp.add(n);
      }
      nodes.add(tmp);
    }
    println("done adding nodes");
  }

// Calculate edge weights for each pair of adjacent nodes in their neighborhood
  private void add_edges() {  
    for (int i=0; i<h; i++) {
      int start_i = i - 2;
      int end_i = i + 2;
      
      if (start_i < 0) {start_i = 0;}
      if (end_i >= h) {end_i = h-1;}
      
      for (int j=0; j<w; j++) {
        Node a = nodes.get(i).get(j);
        int start_j = j - 2;
        int end_j = j + 2;

        if (start_j < 0) {start_j = 0;}
        if (end_j >= w) {end_j = w-1;}
        
        for (int p=start_i; p<=end_i; p++) {
          for (int q=start_j; q<=end_j; q++) {
            if (p == i && q == j) {continue;}
            else {
              Node b = nodes.get(p).get(q);
              if (b.neighbors.containsKey(a)) {
                a.neighbors.put(b, b.neighbors.get(a));
              }
              else {
                float d = abs(a.value - b.value);
                float f = exp(-((pow(i-p, 2.0)+pow(j-q, 2.0))/(2*pow(magic_constant, 2.0))));
                float w = d*f;
                a.neighbors.put(b, new Float(w));
                b.neighbors.put(a, new Float(w));
              }
            }
          }
        }
        
      }
    }
  }
  
  private void clamp() {
    result = new ArrayList<FloatList>();
    for (int i=0; i<h; i++) {
      FloatList tmp = new FloatList();
      for (int j=0; j<w; j++) {
        float m = nodes.get(i).get(j).value;
        m = map(m, min, max, 0, 256);
        tmp.append(m);
      }
      result.add(tmp);
    }
  }
  
  public void reset() {
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        nodes.get(i).get(j).reset();
      }
    }
  }
  
//  Distribute weights
  public void distribute(int iterations) {
    if (iterations <= 0) {
      min = 10.0;
      max = 0.0;
      for (int i=0; i<h; i++) {
        for (int j=0; j<w; j++) {
          Node n = nodes.get(i).get(j);
          n.value *= (n.undistributed + n.received);
          if (n.value > max) {max = n.value;}
          if (n.value < min) {min = n.value;}
        }
      }
      clamp();
      return;
    }
    
    reset();
    add_edges();
    
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        Node n = nodes.get(i).get(j);
        n.undistributed += n.received;
      }
    }
    
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        float total = 0.0;
        Node n = nodes.get(i).get(j);
        for (Node m : n.neighbors.keySet()) {
          total += n.neighbors.get(m);
        }
        
        for (Node m : n.neighbors.keySet()) {
          m.received += n.undistributed*(n.neighbors.get(m)/total);
        }
        n.undistributed = 0.0;
      }
    }
    distribute(iterations-1);
  }
  
}
