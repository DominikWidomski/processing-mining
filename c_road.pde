class Road {
  ArrayList<PVector> route;
  float s = 10;

  Road() {
    route = new ArrayList<PVector>();
  }

  void addPoint(PVector newPoint) {
    route.add(newPoint);
  }

  void render() {

    float pointSize = 2.0f;

    stroke(255);
    //    strokeWeight(2);
    noFill();
    beginShape(LINE_STRIP);
    for (PVector p : route) {
      vertex(p.x, p.y, p.z);
    }
    endShape();


    for (PVector p : route) {
      pushMatrix();
      translate(p.x, p.y, p.z);
      beginShape(LINE_LOOP);
      vertex(0, s, 0);
      vertex(s, 0, 0);
      vertex(0, -s, 0);
      vertex(-s, 0, 0);
      endShape();
      popMatrix();
    }
  }



  PVector findNearestPoint(PVector to) {
    PVector best = null;
    float bestDist = MAX_FLOAT;

    for (PVector p : route) {
      float distance = dist(p.x, p.y, p.z, to.x, to.y, to.z);
      if (distance < bestDist) {
        bestDist = distance;
        best = p;
      }
    }
    return best;
  }
}

