import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;

ArrayList<Boundary> boundaries;
ArrayList<BasketWall> basketWall;
ArrayList<Ball> balls;

float goalX;
float goalW;
float goalH;

int ballMax = 1;


int goalCount = 0;
int doneCount = 0;

void setup() {
  size(960, 480);
  smooth();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, -30);

  // Create ArrayLists  
  balls = new ArrayList<Ball>();
  boundaries = new ArrayList<Boundary>();
  basketWall = new ArrayList<BasketWall>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/4, height-5, width/2-100, 10));
  boundaries.add(new Boundary(3*width/4, height-5, width/2-100, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));

  Ball p = new Ball(random(width), 10);
  balls.add(p);

  goalW = random(200, 300);
  goalH = random(50, 80);
  goalX = random(width);

  basketWall.add(new BasketWall(goalX, height - goalH / 2, 10, goalH));
  basketWall.add(new BasketWall(goalX + goalW, height - goalH / 2, 10, goalH));
}

void draw() {
  background(255);

  box2d.step();

  if (mousePressed) {
    for (Ball b : balls) {
      Vec2 wind = new Vec2(20, 0);
      b.applyForce(wind);
    }
  }

  boundaries.get(0).update(mouseX, mouseY, PI);

  for (Boundary wall : boundaries) {
    wall.display();
  }

  for (BasketWall wall : basketWall) {
    wall.display();
  }

  for (Ball b : balls) {
    b.display();
  }

  for (int i = balls.size()-1; i >= 0; i--) {
    Ball b = balls.get(i);


    b.done();
    if (b.isDone) {
      balls.remove(i);
      doneCount++;
    }

    if (b.inGoal) {
      goalCount++;
    }
  }

  if (goalCount == ballMax) {    
    goalCount = 0;
  }

  if (doneCount == ballMax) {

    doneCount = 0;

    goalW = random(200, 300);
    goalH = random(50, 80);
    goalX = random(width);

    for (int i = basketWall.size() - 1; i >= 0; i--) {
      BasketWall b = basketWall.get(i);

      b.killBody();
      basketWall.remove(i);
    }

    basketWall.add(new BasketWall(goalX, height - goalH / 2, 10, goalH));
    basketWall.add(new BasketWall(goalX + goalW, height - goalH / 2, 10, goalH));

    ballMax = int(random(1, 3));

    while (balls.size() < ballMax) {
      Ball p = new Ball(random(width), 10);
      balls.add(p);
    }
  }

  pushStyle();
  rectMode(CENTER);
  fill(0, 100);
  rect(goalX + goalW / 2, height - 35, goalW, 70);
  
  popStyle();
}
