class Particle {
  PVector pos, vel;
  
  float life;
  boolean dead;

  Particle(PVector _pos) {
    pos = _pos;
    vel = new PVector(random(-1, 1), random(-1, 1), 0);
    life = 100;
    dead = false;
  }
  
  void update() {
    pos.add(vel);
    life--;
    if(life <= 0) dead = true;
  }
  
  void render() {
    fill(255, life*2.55);
    stroke(255, life*2.55);
//    pushMatrix();
//    translate(pos.x, pos.y, pos.z);
//    beginShape(POINT);
//    vertex(0,0,0);
//    endShape();
    point(pos.x, pos.y, pos.z);
//    popMatrix();
  }
}



