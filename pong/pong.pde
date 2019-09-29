import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

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

int score = 0;
int lastMillis = 0;

int goalCount = 0;
int doneCount = 0;

int timer;

PImage bg;
PImage ballSprite;
PImage topSprite;
PImage bottomSprite;
PImage boundarySprite;

void setup() {
  //size(960, 480);
  fullScreen();
  smooth();
  colorMode(HSB);

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();

  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.setGravity(0, -30);

  // Create ArrayLists  
  balls = new ArrayList<Ball>();
  boundaries = new ArrayList<Boundary>();
  basketWall = new ArrayList<BasketWall>();

  Ball p = new Ball(random(width), 10);
  balls.add(p);

  goalW = random(150, 250);
  goalH = random(50, 80);
  goalX = random(goalW, width - goalW);

  basketWall.add(new BasketWall(goalX, height - goalH / 2, 10, goalH));
  basketWall.add(new BasketWall(goalX + goalW, height - goalH / 2, 10, goalH));
  
  bg = loadImage("bg_black_128bit.png");
  ballSprite = loadImage("red_32bit.png");
  topSprite = loadImage("basket_top.png");
  bottomSprite = loadImage("basket_bottom.png");
  boundarySprite = loadImage("bound_2.png");
}

void draw() {
  background(255);
  imageMode(CORNER);
  image(bg, 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  box2d.step();
  
  pushStyle();
  imageMode(CENTER);
  image(topSprite, goalX + goalW / 2, height - 35, goalW, 70);
  popStyle();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();


      KJoint hand = joints[KinectPV2.JointType_HandRight];
      KJoint elbow = joints[KinectPV2.JointType_ElbowRight];

      if (hand.getX() > 0 && hand.getX() < 1920 && elbow.getX() > 0 && elbow.getX() < 1920) {
        float handX = map(hand.getX(), 0, 1920, 0, width);
        float handY = map(hand.getY(), 0, 1080, 0, height);
        float elbowX = map(elbow.getX(), 0, 1920, 0, width);
        float elbowY = map(elbow.getY(), 0, 1080, 0, height);

        PVector v = new PVector(handX - elbowX, handY - elbowY);
        float angle = v.heading() * -1;

        if (i < boundaries.size()) {
          boundaries.get(i).update(handX, handY, angle);
        } else {
          boundaries.add(new Boundary(handX, handY, abs(handX - elbowX) + int(random(20, 100)), 25));
        }
      }
    }
  }

  if (boundaries.size() > skeletonArray.size()) {
    for (int i = boundaries.size() - 1; i >= skeletonArray.size(); i--) {
      boundaries.get(i).killBody();
      boundaries.remove(i);
    }
  }

  for (Boundary wall : boundaries) {
    wall.display(boundarySprite);
  }

  //for (BasketWall wall : basketWall) {
  //  wall.display(basketSprite);
  //}

  for (Ball b : balls) {
    b.display(ballSprite);
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

      if (millis() - lastMillis > 1000) {
        lastMillis = millis();
        score++;
      }
    }
  }

  if (goalCount == ballMax) {    
    goalCount = 0;
  }

  if (doneCount == ballMax) {

    doneCount = 0;

    goalW = random(150, 250);
    goalH = random(50, 80);
    goalX = random(goalW, width - goalW);

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
  //rectMode(CENTER);
  //fill(0, 100);
  //rect(goalX + goalW / 2, height - 35, goalW, 70);
  imageMode(CENTER);
  image(bottomSprite, goalX + goalW / 2, height - 35, goalW, 70);
  popStyle();

  textSize(64);
  textAlign(CENTER);
  //image(bottomSprite, width/2, 25, 100, 80);
  fill(255,255,255,200);
  text(score, width / 2, 75);
}
