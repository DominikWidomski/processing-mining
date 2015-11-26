class Asteroid extends GameObject {
  float cargo;
  boolean empty;
  float size;

  
  Asteroid(PVector _pos) {
    pos = _pos;
    float r = 0.3;
    vel = new PVector(random(-r, r), random(-r, r), 0);
    size = cargo * 0.3;
    
    // trying to adjust the asteroids to like, not be outside of bounds, because at the moment I just want them to bounce around
    // weird problem, some just get stuck there at the boundaries... wat
    if(pos.x + size/2 >= width) {
      pos.x = width - size/2;
      vel.x = -abs(vel.x);
    } else if( pos.x - size/2 < 0) {
      pos.x = size/2;
      vel.x = abs(vel.x);
    }
    if(pos.y + size/2 >= height) {
      pos.y = height - size/2;
      vel.y = -abs(vel.y);
    } else if (pos.y - size/2 < 0) {
      pos.y = size/2;
      vel.y = abs(vel.y);
    }
    
    cargo = random(100, 300);
    
    empty = false;
  }
  
  void update() {
    size = cargo * 0.1;
    if(pos.x + size/2 > width || pos.x - size/2 < 0) {
      vel.x = -vel.x;
    }
    if(pos.y + size/2 > height || pos.y - size/2 < 0) {
      vel.y = -vel.y;
    }
    pos.add(vel);
    if( cargo <= 0 ) {
      this.empty = true;
    }
  }
  
  void render() {
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y);
    ellipse(0, 0, size, size);
//    sphere(size/2);
    text(parseInt(this.cargo), 0, size);
    popMatrix();
  }
  
}
