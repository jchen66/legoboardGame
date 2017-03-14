float rx = 0;
float rz = 0;
float boxHeight = 10;
float boxWidth = 200;
float radius = 14;
Sphere sphere;
void settings() {
  size(1280, 720, P3D);
}
void setup() {
  noStroke();
  sphere = new Sphere();
}
void draw() {
  camera(width/2, height/2, 250, width/2, height/2, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  rotateX(-rx);
  rotateZ(rz);
  box(boxWidth, boxHeight, boxWidth);
  
  sphere.update();
  sphere.checkEdges();
  sphere.display();
}

void mouseDragged(){
  rx = map(mouseY*speed, 0, height, -PI/3, PI/3);
  rz = map(mouseX*speed, 0, width, -PI/3, PI/3);
  if(rx > PI/3) rx = PI/3;
  if(rx < -PI/3) rx = -PI/3;
  if(rz > PI/3) rz = PI/3;
  if(rz < -PI/3) rz = -PI/3;
}

float speed = 1.0;

void mouseWheel(MouseEvent event) {
  speed -= event.getCount()/50.0;
  if(speed < 0.1) speed = 0.1;
  if(speed > 3) speed = 3;
  println("Speed = " + speed);
}