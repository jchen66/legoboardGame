class Cylinder {
  float cylinderHeight = 50.0;
  int cylinderResolution = 30;
  PVector location;
  float groundHeight =cylinderHeight+boxHeight/2.0;
  PShape openCylinder = new PShape();
  PShape surface = new PShape();
  float angle;
  float[] x;
  float[] y;

  Cylinder(float xx, float yy) { //constructor most likely inefficient, requires some modifications
    location = new PVector(xx, -groundHeight, yy);
    x = new float[cylinderResolution + 1];
    y = new float[cylinderResolution + 1];
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      x[i] = sin(angle) * cylinderBaseSize;
      y[i] = cos(angle) * cylinderBaseSize;
    }
    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    surface = createShape();
    surface.beginShape(TRIANGLE_FAN);
    surface.vertex(0, 0, 0);
    for (int i = 0; i < x.length; i++) {
      openCylinder.vertex(x[i], y[i], 0);
      openCylinder.vertex(x[i], y[i], cylinderHeight);
      surface.vertex(x[i], y[i], 0);
    }
    openCylinder.endShape();
    surface.endShape();
  }

  void display() {
    pushMatrix();
    if (!shiftMode) {
      translate(location.x, location.y, location.z);
      rotateX(-PI/2);
    } else {
      translate(location.x, location.z, cylinderHeight);
      rotateX(-PI);
    }
    shape(openCylinder);
    shape(surface);
    popMatrix();
  }
}