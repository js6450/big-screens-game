class Boundary {

  float x;
  float y;
  float w;
  float h;
  
  float a;
  
  float c;
  
  Body b;
  BodyDef bd;
  PolygonShape sd;

  Boundary(float x_,float y_, float w_, float h_) {
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
    bd.angle = random(TWO_PI);
    b = box2d.createBody(bd);
    
    b.createFixture(sd,1);
    
    c = random(0, 255);
  }
  
  void killBody(){
    box2d.destroyBody(b);
  }
  
  void update(float x_, float y_, float _a){   
    x = x_;
    y = y_;
    
    box2d.destroyBody(b);
    
    bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    bd.angle = _a;
    b = box2d.createBody(bd);
    
    b.createFixture(sd,1);
  }

  void display(PImage sprite) {
    
    Vec2 pos = box2d.getBodyPixelCoord(b);
    float a = b.getAngle();
    
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    noFill();
    strokeWeight(3);
    stroke(c, 255, 255);
    rect(0, 0, w, h);
    imageMode(CENTER);
    image(sprite, 0, 0, w, h);
    popMatrix();
  }

}
