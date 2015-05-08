PImage eye_tex;
PImage back;
PShape eye;
ESphere eyeball;
SaccData fixations;

void setup() {
  size(512, 512, P3D);
  background(128, 140, 145);
  
  //  parse vertex data
  String[] allData = loadStrings("eyeball_vert.txt");
  String[] allNorm = loadStrings("eyeball_norm.txt");
  String[] allTex = loadStrings("eyeball_tex.txt");
  String[] indices = loadStrings("eyeball_index.txt");
  ArrayList<PVector> verts = new ArrayList<PVector>();
  ArrayList<PVector> txtrs = new ArrayList<PVector>();
  ArrayList<PVector> norms = new ArrayList<PVector>();
  HashMap<PVector, PVector> vertToTex = new HashMap<PVector, PVector>();
  eye_tex = loadImage("eyeball_texture.png");
  back = loadImage("face.png");
  back.resize(512, 512);

  for (int i=0; i<allTex.length; i++) {
    String[] aTex = trim(split(allTex[i], ' '));
    PVector t = new PVector(float(aTex[0]), float(aTex[1]));
    txtrs.add(t);
     
    if (i<allNorm.length) {
      String[] aNorm = trim(split(allNorm[i], ' '));
      PVector n = new PVector(float(aNorm[0]), float(aNorm[1]), float(aNorm[2]));
      norms.add(n);
    }

    if (i<allData.length) {
      String[] aVert = trim(split(allData[i], ' '));
      PVector v = new PVector(float(aVert[0]), float(aVert[1]), float(aVert[2]));
      verts.add(v);
    }
      
  }
  
  
  noStroke();
  fill(150, 180, 180, 85);
  eye = createShape();
  eye.beginShape(TRIANGLES);
  eye.textureMode(NORMAL);
  eye.texture(eye_tex);
  
  println("got here");
  
  for (int i=0; i<indices.length; i++) {
    String[] index = trim(split(indices[i], ' '));
    ArrayList<Pair> temp = new ArrayList<Pair>();
    
    for (int j=0; j<index.length; j++) {
      String[] guy = trim(split(index[j], '/'));
      Pair m = new Pair(int(guy[0])-1, int(guy[1])-1, int(guy[2])-1);
      temp.add(m);
    }
    
    PVector n1 = norms.get(temp.get(0).z);
    PVector t1 = txtrs.get(temp.get(0).y);
    PVector v1 = verts.get(temp.get(0).x);
    eye.normal(n1.x, n1.y, n1.z);
    eye.vertex(v1.x, v1.y, v1.z, t1.x, t1.y);
    
    PVector n2 = norms.get(temp.get(1).z);
    PVector t2 = txtrs.get(temp.get(1).y);
    PVector v2 = verts.get(temp.get(1).x);
    eye.normal(n2.x, n2.y, n2.z);
    eye.vertex(v2.x, v2.y, v2.z, t2.x, t2.y);
    
    PVector n3 = norms.get(temp.get(2).z);
    PVector t3 = txtrs.get(temp.get(2).y);
    PVector v3 = verts.get(temp.get(2).x);
    eye.normal(n3.x, n3.y, n3.z);
    eye.vertex(v3.x, v3.y, v3.z, t3.x, t3.y);
    
  }
  
  eye.endShape(CLOSE);
  fixations = new SaccData("data.txt");
  eyeball = new ESphere(eye, fixations);
  
  frameRate(60);
}

void draw() {
  background(back);
  pushMatrix();
  translate(width / 2, height / 2);
  beginShape();
  texture(back);
  vertex(-256, -256, 15, 0,   0);
  vertex( 256, -256, 15, 512, 0);
  vertex( 256,  256, 15, 512, 512);
  vertex(-256,  256, 15, 0,   512);
  endShape();
  popMatrix();

//  lights();
  eyeball.display();
}


// yeah don't touch these
//public class PFrame extends JFrame {
//  public PFrame(int width, int height) {
//    setBounds(100, 100, width, height);
//    s = new SecondApplet();
//    add(s);
//    s.init();
//    show();
//  }
//}
//public class SecondApplet extends PApplet {
//  public void setup() {
//    background(50);
//    size(100, 100, P3D);
//  }
//
//  public void draw() {
//    background(50);
//  }
//}
