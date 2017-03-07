void settings() {
  size(500, 500, P3D);
}
void setup() {
  noStroke();
}
void draw() {
  camera(width/2, height/2, 500, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(200);
  translate(width/2, height/2, 0);
  
  float rx = map(mouseY*speed, 0, height, -PI/3, PI/3);
  float rz = map(mouseX*speed, 0, width, -PI/3, PI/3);
  if(rx > PI/3) rx = PI/3;
  if(rx < -PI/3) rx = -PI/3;
  if(rz > PI/3) rz = PI/3;
  if(rz < -PI/3) rz = -PI/3;
  rotateX(-rx);
  rotateZ(rz);
  
  box(200,10,200);
}

float speed = 1.0;

void mouseWheel(MouseEvent event) {
  speed -= event.getCount()/50.0;
  if(speed < 0.1) speed = 0.1;
  if(speed > 3) speed = 3;
  println("Speed = " + speed);
}