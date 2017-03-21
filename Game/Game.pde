float rx = 0;
float rz = 0;
float speed = 1.0;
float boxHeight = 10;
float boxWidth = 500;
Sphere sphere;
boolean shiftMode = false;
ArrayList<Cylinder> cylinders = new ArrayList();
ArrayList<PVector> positions = new ArrayList();
float cylinderBaseSize = 25.0;

void settings() {
  size(1280, 720, P3D);
}
void setup() {
  noStroke();
  sphere = new Sphere();
}
void draw() {
  camera();
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  if (!shiftMode) {
    rotateX(-PI/6);
    noStroke();
    rotateX(-rx);
    rotateZ(rz);
    box(boxWidth, boxHeight, boxWidth);
    sphere.update();
    sphere.checkEdges();
    sphere.checkCylinderCollision();
    sphere.display();
  } else {
    stroke(3);
    box(boxWidth, boxWidth, boxHeight);
    sphere.display();
  }
  for (int i = 0; i < cylinders.size(); i++) {
    cylinders.get(i).display();
  }
}
void mouseDragged() {
  if (!shiftMode) {
    rx = map(mouseY*speed, 0, height, -PI/3, PI/3);
    rz = map(mouseX*speed, 0, width, -PI/3, PI/3);
    if (rx > PI/3) rx = PI/3;
    if (rx < -PI/3) rx = -PI/3;
    if (rz > PI/3) rz = PI/3;
    if (rz < -PI/3) rz = -PI/3;
  }
}
void mouseWheel(MouseEvent event) {
  if (!shiftMode) {
    speed -= event.getCount()/50.0;
    if (speed < 0.1) speed = 0.1;
    if (speed > 3) speed = 3;
    println("Speed = " + speed);
  }
}
void mouseClicked() {
  if (shiftMode) {
    cylinders.add(new Cylinder(mouseX-width/2, mouseY-height/2));
    positions.add(new PVector(mouseX-width/2, mouseY-height/2));
  }
}
void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftMode = true;
    }
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftMode = false;
    }
  }
}