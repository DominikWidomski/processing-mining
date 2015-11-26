class Station extends GameObject { 
  String name;
  int id;
  float cargo = 1000;
  color c;

  Station(String _name, int _id) {
    pos  = new PVector(random(width - 200) + 100, random(height - 200) + 100, 0);
    name = _name;
    id   = _id;
    c = color(random(200)+55, random(200)+55, random(200)+55);
  }


  void render() {
    strokeWeight(2);
    stroke(c);
    fill(20);
    pushMatrix();
    translate(pos.x, pos.y);
    ellipse(0, 0, 20, 20);
    fill(200);
    textAlign(CENTER, CENTER);
    text(this.name, 0, -25);
    text(parseInt(this.cargo), 0, 25);
    popMatrix();
  }
}

