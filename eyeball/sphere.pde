class ESphere {
  int num_verts;
  PShape eye;
  PShape org;
  PVector orientation;
  PVector dest_orientation;
  float unit_speed;
  int state = 0;            // 0: STATIONARY, 1: IN TRANSIT
  int fix_frames = 0;
  int done = 0;
  SaccData saccades;
  
  public ESphere(PShape e, SaccData s) {
    eye = e;
    num_verts = 382; 
    orientation = new PVector(0.0, 0.0, 0.0);
    dest_orientation = new PVector(0.0, 0.0, 0.0);
    unit_speed = radians(15.0);
    saccades = s;
  }
  
  public void display() {
    noStroke();
    
    // if fixated
    if (state == 0) {
      if (fix_frames > 0) {
        println(frameCount, ": FIXED - ", fix_frames, " frames left");
        fix_frames -= 1;
        shape(eye);
        return;
      }
      // end of fixation
      else {
        // end of sequence
        if (fix_frames < 0 || done < 0) {
          // sequence is finished, at original orientation
          if (abs(orientation.x) < 0.0001 && abs(orientation.y) < 0.0001) {
            println(frameCount, ": FINISHED!");
            state = 0;
            shape(eye);
            return;
          }
          // rotate back to origin
          else {
            float dx = -orientation.x;
            float dy = -orientation.y;
            
            // if orientation left is more than what could go in one frame
            if (pow(pow(dx, 2.0)+pow(dy, 2.0), 0.5) > unit_speed) {
                PVector r = new PVector(dx, dy);
                r.normalize();
                r.mult(unit_speed);
                dx = r.x;
                dy = r.y;
            }
            
            orientation.add(dx, dy, 0.0);
            println(frameCount, ": IN TRANSIT TO ORIGINAL - rotating (", dx, ", ", dy, ")");
          }
        }
        
        state = 1;
        if (done >= 0 && fix_frames >= 0) {
          PVector next_loc = saccades.get_next_loc();
          fix_frames = saccades.get_fixation();
          
          float rotx = asin((next_loc.x - saccades.org_loc.x)/1600);
          float roty = asin((next_loc.y - saccades.org_loc.y)/1600);
          
          dest_orientation.set(rotx, roty, 0.0);
          done = saccades.update();
          println(frameCount, ": SHIFTING - done fixating");
        }
      }
    }
    
    // if in trasit
    if (state == 1) {
      if (fix_frames > 0 || done > 0) {
        float dx = dest_orientation.x - orientation.x;
        float dy = dest_orientation.y - orientation.y;
        
        // finished transit
        if (abs(dx) < 0.001 && abs(dy) < 0.001) {
          println(frameCount, ": END OF FIXATION - going to next");
          state = 0;
          shape(eye);
          return;
        }
        
        // if orientation left is more than what could go in one frame
        if (pow(pow(dx, 2.0)+pow(dy, 2.0), 0.5) > unit_speed) {
            PVector r = new PVector(dx, dy);
            r.normalize();
            r.mult(unit_speed);
            dx = r.x;
            dy = r.y;
        }
        
        orientation.add(dx, dy, 0.0);
        println(frameCount, ": IN TRANSIT - rotating (", dx, ", ", dy, ")");
      }
      
      else {
        // sequence is finished, at original orientation
        if (abs(orientation.x) < 0.0001 && abs(orientation.y) < 0.0001) {
          println(frameCount, ": FINISHED!");
          state = 0;
          shape(eye);
          return;
        }
        // rotate back to origin
        else {
          float dx = -orientation.x;
          float dy = -orientation.y;
          
          // if orientation left is more than what could go in one frame
          if (pow(pow(dx, 2.0)+pow(dy, 2.0), 0.5) > unit_speed) {
              PVector r = new PVector(dx, dy);
              r.normalize();
              r.mult(unit_speed);
              dx = r.x;
              dy = r.y;
          }
          
          orientation.add(dx, dy, 0.0);
          println(frameCount, ": IN TRANSIT TO ORIGINAL - rotating (", dx, ", ", dy, ")");
        }
      }
    }
     

    // flipping the rotation because the image is facing away from us relative to the eye
    pushMatrix();
    translate(width/3, height/2, 0);
    rotateY(radians(5));
    rotateX(-orientation.x);
    rotateY(-orientation.y);
    shape(eye);
    popMatrix();
    
    pushMatrix();
    translate(width*2/3, height/2, 0);
    rotateY(radians(-13));
    rotateX(radians(3));
    rotateX(-orientation.x);
    rotateY(-orientation.y);
    shape(eye);
    popMatrix();

    
  }
}
