import processing.opengl.*;

boolean mouseOver = false;

ArrayList<Station> stations;
ArrayList<Road> roads;
ArrayList<Vehicle> vehicles;
ArrayList<Asteroid> asteroids;
ArrayList<Particle> particles;

boolean drawingRoad = false;
Road currentRoad = null;
PVector lastPoint = null;
float drawDistance = 50.0f;

void setup() {
  size(800, 600, P3D);

  stations   = new ArrayList<Station>();
  roads      = new ArrayList<Road>();
  vehicles   = new ArrayList<Vehicle>();
  asteroids  = new ArrayList<Asteroid>();
  particles  = new ArrayList<Particle>();

  stations.add(new Station("X-1", 0));
  stations.add(new Station("Pheonix", 1));
  stations.add(new Station("Missa 12", 2));
  
  for (int i = 0; i < 10; ++i) {
    Vehicle v = new Vehicle(new PVector(random(width - 50) + 50, random(height - 50) + 50, 0));
//    v.setTarget(stations.get(parseInt(random(stations.size()))));
    v.findNewAsteroid();
    vehicles.add(v);
  }
  
  for (int i = 0; i < 40; ++i) {
    Asteroid a = new Asteroid(new PVector(random(width - 50) + 50, random(height - 50) + 50, 0));
    asteroids.add(a);
  }
}



void draw() {
  background(20);
//  lights();
//  ortho();
  for (Station station : stations) {
    station.render();
  }
  for (Road road : roads) {
    road.render();
  }
  for(int i = asteroids.size()-1; i >= 0; --i) {
    Asteroid a = asteroids.get(i);
    a.update();
    if( a.empty ) {
      asteroids.remove(a);
    } else {
      a.render();
    }
  }
  for(int i = particles.size()-1; i >= 0; --i) {
    Particle p = particles.get(i);
    p.update();
    if( p.dead ) {
      particles.remove(p);
    } else {
      p.render();
    }
  }
  for (Vehicle v : vehicles) {
    v.update();
    v.render();
  }
  
//  strokeWeight(1);
  if (drawingRoad) {
    stroke(255);
    noFill();
    beginShape(LINES);
    vertex(lastPoint.x, lastPoint.y, 0);
    vertex(mouseX, mouseY, 0);
    endShape();
    
    ellipse(lastPoint.x, lastPoint.y, drawDistance*2, drawDistance*2);
  }
  
  PVector nearestPoint = findNearestPoint(new PVector(mouseX, mouseY, 0));
  if(nearestPoint != null) {
    beginShape(LINES);
    vertex(mouseX, mouseY, 0);
    vertex(nearestPoint.x, nearestPoint.y, nearestPoint.z);
    endShape();
  }
}


PVector findNearestPoint(PVector to) {
  PVector best = null;
  float bestDist = MAX_FLOAT;
  
  for(Road r : roads) {
    PVector p = r.findNearestPoint(to);
    float distance = dist(p.x, p.y, p.z, to.x, to.y, to.z);
    if(distance < bestDist) {
      bestDist = distance;
      best = p;
    }
  }
  
  return best;
}



void mouseOver() {
  mouseOver = true;
}
void mouseOut() {
  mouseOver = false;
}

void mousePressed() {
  if (mouseButton == LEFT) {
    drawingRoad = true;
    currentRoad = new Road();
    roads.add(currentRoad);
    lastPoint = new PVector(mouseX, mouseY, 0);
    currentRoad.addPoint(lastPoint);
  } else {
    vehicles.add( new Vehicle( new PVector(mouseX, mouseY, 0)));
  }
}

void mouseDragged() {
  if (drawingRoad) {
    if (dist(lastPoint.x, lastPoint.y, mouseX, mouseY) > drawDistance) {
      lastPoint = new PVector(mouseX, mouseY, 0);
      currentRoad.addPoint(lastPoint);
    }
  }
}

void mouseReleased() {
  if( mouseButton == LEFT) {
    drawingRoad = false;
    lastPoint = null;
    currentRoad.addPoint(new PVector(mouseX, mouseY, 0));
    currentRoad = null;
  }
}

