class Sphere {
  PVector location;
  PVector velocity;
  PVector gravityForce;
  float gravityConstant = 0.0981;
  float groundHeight;

  Sphere() {
    groundHeight = radius+boxHeight/2;
    location = new PVector(0, -groundHeight, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
  }

  void update() {
    gravityForce.x = sin(rz) * gravityConstant;
    gravityForce.z = sin(rx) * gravityConstant;
    float normalForce = 1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce);
    velocity.add(friction);
    location.add(velocity);
  }

  void display() {
    translate(location.x, location.y, location.z);
    sphere(radius);
  }

  void checkEdges() {
    if (location.y > -groundHeight) {
      location.y = -groundHeight;
    }
    if (location.x > boxWidth/2) {
      location.x = boxWidth/2;
      velocity.x = -velocity.x;
    }
    if (location.x < -boxWidth/2) {
      location.x = -boxWidth/2;
      velocity.x = -velocity.x;
    }
    if (location.z > boxWidth/2) {
      location.z = boxWidth/2;
      velocity.z = -velocity.z;
    }
    if (location.z < -boxWidth/2) {
      location.z = -boxWidth/2;
      velocity.z = -velocity.z;
    }
  }
}