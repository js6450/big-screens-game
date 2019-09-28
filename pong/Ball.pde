class Ball {

  Body body;
  float r;

  Vec2 wind;
  boolean inGoal;
  boolean isDone;

  Ball(float x, float y) {
    r = random(25, 35);
    makeBody(new Vec2(x, y), r);

    wind = new Vec2(random(-10, 10), 0);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  void done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);  

    if (pos.x > goalX && pos.x < goalX + goalW && pos.y > height - 70) {
      inGoal = true;
    } else {
      inGoal = false;
    }

    if (pos.y > height + r * 2 || pos.x < - r * 2 || pos.x > width + r * 2) {
      killBody();
      isDone = true;
    } else {
      isDone = false;
    }
  }

  void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }

  // Drawing the box
  void display() {

    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    this.applyForce(wind);

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(150);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, r*2, r*2);
    line(0, 0, r, 0);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float _r) {

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(_r);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = int(random(1, 3));
    fd.friction = random(0, 0.5);
    fd.restitution = random(0.5, 1.0);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    bd.angle = random(TWO_PI);

    body = box2d.createBody(bd);
    body.createFixture(fd);
  }
}
