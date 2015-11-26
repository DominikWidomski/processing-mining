class GameObject {
  PVector pos, vel;
  
  GameObject() {
    pos = new PVector(0,0,0);
    vel = new PVector(0,0,0);
  }
  
  void update(){};
  void render(){};
  
  PVector getPos() {
    return pos;
  }
}
