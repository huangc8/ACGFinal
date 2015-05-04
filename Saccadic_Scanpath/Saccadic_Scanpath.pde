PImage img;
Point [] points;
Point [] marks;
BoundBox [] boxes;
int markIndex = 0;
int boxIndex = 0;
int dimension = 10;

void setup() {
  // load image and pixels
  img = loadImage("sal_MB.jpg");
  size(img.width, img.height);
  img.loadPixels();

  // create array
  points = new Point[img.pixels.length];
  marks = new Point[img.pixels.length];
  boxes = new BoundBox[img.pixels.length];

  // log all points & sort them
  int index = 0;
  for (int i=0; i<img.width; i++) {
    for (int j=0; j<img.height; j++) {
      addPoint(i, j, index);
      index++;
    }
  }
  sortPoints();
}// end of set up

void draw() {
  image(img, 0, 0);
  int p = -1;
  for (int i = 0; i < markIndex; i++) {
    drawCross(marks[i].x, marks[i].y);
    if(p >= 0){
      drawLine(marks[i].x, marks[i].y, marks[p].x, marks[p].y);
    }
    p = i;
  }
  for (int i = 0; i < boxIndex; i++) {
    boxes[i].drawBox();
  }
}

// find next fixation point
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {

      int index = 0;
      while (true) {
        // chose between top 5
        float r = random(100);  
        if (r > 50) {            // 1st
          index = 0;
        } else if (r > 25) {     // 2nd
          index = 1;
        } else if (r > 12.5) {   // 3rd
          index = 2;
        } else if (r > 6.25) {   // 4th
          index = 3;
        } else {                 // 5th
          index = 4;
        }

        Point pt = points[index];

        if(pt.x > img.width || pt.x < 0 
        || pt.y > img.height || pt.y < 0){
          points[index].sv = 0;
          sortPoints();
          continue;
        }

        boolean found = false;
        for (int i = 0; i < boxIndex; i++) {
          if (boxes[i].inBox(pt.x, pt.y)) {
            found = true;
            break;
          }
        }

        // check if inside the box
        if (found) {
          points[index].sv = 0;
          sortPoints();
        } else {
          break;
        }
      }

      markPoint(points[index]);
      sortPoints();
    }
  }
}

// mark a point on the image
void markPoint(Point p) {
  // add to mark
  marks[markIndex] = p;
  markIndex++; 

  // remove from top
  p.sv = 0;
  boxes[boxIndex] = new BoundBox(p.x, p.y, dimension);
  boxIndex++;
}

// add a point to points
void addPoint(int i, int j, int index) {
  // add the point
  points[index] = new Point(j, i, brightness(img.pixels[i*img.width + j]));
}

// bubble sort the points array
void sortPoints() {
  boolean swapped = true;
  int j = 0;
  Point tmp;
  while (swapped) {
    swapped = false;
    j++;
    for (int i = 0; i < points.length - j; i++) {                                       
      if (points[i].sv < points[i + 1].sv) {                          
        tmp = points[i];
        points[i] = points[i + 1];
        points[i + 1] = tmp;
        swapped = true;
      }
    }
  }
}

// draw a cross
void drawCross(int x, int y) {
  strokeWeight(1);
  stroke(255, 0, 0);
  line(x-5, y, x+5, y);
  line(x, y-5, x, y+5);
}

// draw a line between points
void drawLine(int x, int y, int x2, int y2) {
  strokeWeight(1);
  stroke(255, 0, 0);
  line(x, y, x2, y2);
}

