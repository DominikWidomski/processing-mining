class Vehicle {
  float SLOW = 2.0;
  float FAST = 6.0;
  float MAD = 10.0;
  
  PVector acc, vel, pos;
  float maxSpeed = SLOW;        
  float near, far, arrived;
  float heading;
  
  float cargo, maxCargo, transferSpeed;
  
  boolean loaded, unloaded, loading, unloading;

  Road road = null;
  GameObject target = null;

  boolean slowing = false;

  Vehicle(PVector _pos) {
    acc = new PVector(0, 0, 0);
    vel = new PVector(0, 0, 0);
    pos = _pos;

    near = 100; 
    far = 250;
    arrived = 50;
    
    cargo = 0;
    maxCargo = random(100, 500);
    transferSpeed = parseInt(random(1, 3));
    
    loaded = false;
    unloaded = false;
    loading = false;
    unloading = false;
  }


  void update() {
    PVector t;
    if (target != null) {
      t = target.pos;
    } else {
      t = new PVector(mouseX, mouseY, 0);
    }
    acc = new PVector(t.x - pos.x, t.y - pos.y, t.z - pos.z);
    slowing = false;


    // GREEN zone
    if (acc.mag() < far && acc.mag() > near) {
      // move, das good
      acc.normalize();
      float mag = vel.mag();
      vel.add(acc);
      if (mag == 0) {
        vel.setMag(0.1);
      } else {
        vel.setMag(mag + 0.1);
      }
      
    // outside of range, wanna move slowly... for some reason
    } else if ( acc.mag() > far || (acc.mag() < near && acc.mag() > arrived)) {
      // move, das good
      acc.normalize();
      float mag = vel.mag();
      vel.add(acc);
      if (mag == 0) {
        vel.setMag(0.1);
      } else {
        vel.setMag(mag + 0.1);
        //vel.limit(maxSpeed/2);  // NOTE: SHOULD NOT BE HERE MAYBE?
      }

      // RED zone
    } else if ( acc.mag() < arrived) {
      acc.normalize();
      float mag = vel.mag();
      vel.add(acc);
      vel.setMag(mag);
      slowDown();
      
      // ARRIVED, stopped moving
      loading = unloading = false;
      if(mag == 0) { 
        if(target instanceof Station) {
          if( unloadTo((Station)target) && unloaded) {
            findNewAsteroid();
          }
        } else if ( target instanceof Asteroid) {
           if( loadFrom((Asteroid)target) && loaded ) {
              findNewStation();
            }
        } 
      }

    // Outside of its range
    } else {
      acc.normalize();
      float mag = vel.mag();
      vel.add(acc);
      vel.setMag(mag);
      slowDown();
    }

    heading = acc.heading();
    //    vel.set(0, 0, 0);
    //    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
  }

  void slowDown() {
    slowing = true;
    if ( vel.mag() > 0.1)
      vel.mult(0.95);
    else 
      vel.set(0, 0, 0);
  }

  // ================================================================================================================================================
  // ================================================================================================================================================
  void render() {
    // NOTE: I would have thought this would be the other way around???
    float w = 10;
    float h = 5;
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    pushMatrix();
    rotate(heading);

    if ( slowing ) 
      stroke(255, 0, 0);
    else
      stroke(255);
    noFill();
    beginShape(LINE_LOOP);
    vertex(w, h, 0);
    vertex(w, -h, 0);
    vertex(-w, -h, 0);
    vertex(-w, h, 0);
    endShape();
    
    fill(255);
    noStroke();
    float c = cargo / maxCargo;
    beginShape(TRIANGLE_STRIP);
    vertex(w, h, 0);
    vertex(w, -h, 0);
    vertex(w + (-w * c*2), h, 0);
    vertex(w + (-w * c*2), -h, 0);
    endShape();
    noFill();
    
    // thrusters
    stroke(255);
    if ( vel.mag() > 0) {
      beginShape(LINE_STRIP);
      vertex( -w, h * 0.6, 0);
      //        vertex( -w*(1+vel.mag()), 0, 0);
      vertex( -w*(1+(vel.mag()))+random(w*0.4), random(h*.5)-h*.25, 0); //extra variation in thrusters
      vertex( -w, -h * 0.6, 0);
      endShape();
    }

    // visualising bounds
    /*
    stroke(0, 255, 0);
    ellipse(0, 0, far*2, far*2);
    stroke(255, 0, 0);
    ellipse(0, 0, near*2, near*2);
    stroke(0, 255, 255);
    ellipse(0, 0, arrived*2, arrived*2);
    //*/

    popMatrix();
    fill(255);
//    text(vel.mag(), 10, 10);
//    text(this.cargo, 0, 20);
    popMatrix();
    
    //*
    if ( loading ) {
//      PVector f = this.pos;
      PVector f = new PVector(pos.x, pos.y, pos.z);
      PVector off = new PVector(w,1,0);
      off.rotate(heading);
      f.add(off);
      beginShape(LINES);
        vertex(f.x, f.y, f.z);
        vertex(target.pos.x, target.pos.y, target.pos.z);
      endShape();
    }
    
    if ( unloading ) {
//      PVector f = this.pos;
      PVector f = new PVector(pos.x, pos.y, pos.z);
      PVector off = new PVector(w,-1,0);
      off.rotate(heading);
      f.add(off);
      beginShape(LINES);
        vertex(f.x, f.y, f.z);
        vertex(target.pos.x, target.pos.y, target.pos.z);
      endShape();
    }
    //*/
    
  } // end of RENDER function
  // ================================================================================================================================================
  // ================================================================================================================================================


  void setTarget(GameObject t) {
    target = t;
  }
  
  void findNewStation() {
    println("NEW STATION");
    boolean found = false;
    while(!found) {
      Station s = stations.get(parseInt(random(stations.size()))); 
      if ( s != target ) {
        target = s;
        unloaded = false;
        loaded = false;
        break;
      }
    }
  }
  void findNewAsteroid() {
    boolean found = false;
    while(!found) {
      if(asteroids.size() == 0) {
        // ok something else should force it to find a station, not necessarily this... not at the beginning at least... fak
//        if(this.cargo > 0) 
        findNewStation();
//        else chill();
        break;
      }
      Asteroid a = asteroids.get(parseInt(random(asteroids.size()))); 
      if ( a != target ) {
        target = a;
        unloaded = false;
        loaded = false;
        break;
      }
    }
  }
  void chill() {
    // do nothing...
  }
  
  
  boolean unloadTo(Station station) {
    if(unloaded) return true;
    if(this.cargo > 0) {
      station.cargo += transferSpeed;
      this.cargo -= transferSpeed;  
      unloading = true;
    }
    if(this.cargo <= 0) {
      station.cargo += abs(this.cargo);
      this.cargo = 0;
      unloading = false;
      unloaded = true;
      return true;
    } else {
      return false;
    }
  }
  
  boolean loadFrom(Asteroid asteroid) {
    if(asteroid.empty) {
      if(this.cargo < maxCargo) {
        findNewAsteroid();  
      } else {
        findNewStation();
      }
    }
    if(this.cargo < maxCargo && asteroid.cargo > 0) {
      asteroid.cargo -= transferSpeed;
      this.cargo += transferSpeed;
      particles.add(new Particle(new PVector(asteroid.pos.x, asteroid.pos.y, asteroid.pos.z)));
      loading = true;
      return false;
    }
    if( this.cargo >= maxCargo) {
      asteroid.cargo += this.cargo - maxCargo;
      this.cargo = maxCargo;
      loaded = true;
      loading = false;
      return true;
    } else {
      return false;
    }
  }
  
  
}

