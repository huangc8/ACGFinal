PImage img;
Point [] points;    // all the points
Point [] marks;     // all the fixation point
Point pp;           // pervious fixation point
BoundBox [] boxes;  // the bounding boxes
int markIndex = 0;  // current mark index
int boxIndex = 0;   // current box index
int markMax = 5;    // maximum mark on screen
int lastMark = -1;  // last added mark
int dimension = 10; // the size of the box

void setup() {
  // load image and pixels
  img = loadImage("sal_portrait_boy.jpg");
  size(img.width, img.height);
  img.loadPixels();

  // create array
  points = new Point[img.width*img.height];
  marks = new Point[markMax];
  boxes = new BoundBox[markMax];

  // log all points & sort them
  int pointIndex = 0;
  boolean sorted = false;
  for (int x=0; x<img.width; x++) {
    for (int y=0; y<img.height; y++) {
      addPoint(x, y, pointIndex);
      pointIndex++;
    }
  }

  // quick sort the points
  quickSort(0, points.length-1);
}// end of set up

void draw() {
  image(img, 0, 0);
  int p = -1;
  // draw cross and links
  for (int i = 0; i < markMax; i++) {
    if (marks[i] != null) {
      drawCross(marks[i].x, marks[i].y);
      if (p >= 0) {
        if (i == lastMark) {
          drawLineBlue(marks[i].x, marks[i].y, marks[p].x, marks[p].y);
        } else {
          drawLine(marks[i].x, marks[i].y, marks[p].x, marks[p].y);
        }
      }
      p = i;
    }
  }

  // draw the box
  for (int i = 0; i < markMax; i++) {
    if (boxes[i] != null) {
      boxes[i].drawBox();
    }
  }

  if (lastMark >= 0) {
    boxes[lastMark].drawBoxBlue();
    drawCrossBlue(marks[lastMark].x, marks[lastMark].y);
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

        // check if point inbound
        if (pt.x > img.width || pt.x < 0 
          || pt.y > img.height || pt.y < 0) {
          points[index].sv = 0;
          sortPoints();
          continue;
        }

        // check if point been visited
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

      // calculate fixation duration
      float durationTime = 200;
      if (pp != null) {
        Point pt = points[index];
        float n = dist(pt.x, pt.y, pp.x, pp.y);
        n += abs(pt.sv - pp.sv);
        durationTime =+ random(n);
      } else {
        durationTime =+ random(100);
      }
      pp = points[index].clone();

      // mark the point
      markPoint(points[index], durationTime);
      sortPoints();
    }
  }
}

// mark a point on the image
void markPoint(Point p, float dt) {

  if (markIndex == markMax) {
    markIndex = 0;
  }

  // add to mark
  marks[markIndex] = p;
  lastMark = markIndex;
  markIndex++; 

  // remove from top
  p.sv = 0;
  if (boxIndex == markMax) {
    boxIndex = 0;
  }
  boxes[boxIndex] = new BoundBox(p.x, p.y, dimension, dt);
  boxIndex++;
}

// add a point to points
void addPoint(int x, int y, int index) {
  // add the point
  points[index] = new Point(x, y, brightness(img.pixels[x + y*img.width]));
}

// partition for quick sort
int partition(int left, int right)
{
  int i = left, j = right;
  Point tmp;
  Point pivot = points[(left + right) / 2];

  while (i <= j) {
    while (points[i].sv > pivot.sv)
      i++;
    while (points[j].sv < pivot.sv)
      j--;
    if (i <= j) {
      tmp = points[i];
      points[i] = points[j];
      points[j] = tmp;
      i++;
      j--;
    }
  }
  return i;
}

// quick sort
void quickSort(int left, int right) {
  int index = partition(left, right);
  if (left < index - 1)
    quickSort(left, index - 1);
  if (index < right)
    quickSort(index, right);
}

// insert sort the points array
void sortPoints() {
  for (int j = 1; j < points.length; j++) {
    Point kp = points[j];
    int i = j - 1;
    while (i >= 0 && points[i].sv < kp.sv) {
      points[i + 1] = points[i];
      i = i - 1;
      points[i + 1] = kp;
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

//  draw a blue cross
void drawCrossBlue(int x, int y) {
  strokeWeight(1);
  stroke(0, 0, 255);
  line(x-5, y, x+5, y);
  line(x, y-5, x, y+5);
}

// draw a line between points
void drawLine(int x, int y, int x2, int y2) {
  strokeWeight(1);
  stroke(255, 0, 0);
  line(x, y, x2, y2);
}

// draw a blue line between points
void drawLineBlue(int x, int y, int x2, int y2) {
  strokeWeight(1);
  stroke(0, 0, 255);
  line(x, y, x2, y2);
}

