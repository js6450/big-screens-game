class BasketWall {

  float x;
  float y;
  float w;
  float h;
  
  float a;
  
  Body b;
  BodyDef bd;
  PolygonShape sd;

  BasketWall(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    
    sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    b.createFixture(sd,1);
  }
  
  void killBody(){
    box2d.destroyBody(b);
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(b);
    
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255, 0, 0);
    stroke(0);
    rect(0, 0, w, h);
    popMatrix();
  }

}
