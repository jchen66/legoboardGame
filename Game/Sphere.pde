class Sphere {
  float radius = 28;
  PVector location;
  PVector velocity;
  PVector gravityForce;
  float gravityConstant = 0.0981;
  float groundHeight = radius+boxHeight/2;
  float normalForce = 1;
  float mu = 0.01;
  float frictionMagnitude = normalForce * mu;

  Sphere() {
    location = new PVector(0, -groundHeight, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
  }

  void update() {
    gravityForce.x = sin(rz) * gravityConstant;
    gravityForce.z = sin(rx) * gravityConstant;
    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravityForce);
    velocity.add(friction);
    location.add(velocity);
  }

  void display() {
    pushMatrix();
    if (!shiftMode) {
      translate(location.x, location.y, location.z);
    } else {
      translate(location.x, location.z, 0);
    }
    sphere(radius);
    popMatrix();
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
  
    
  void checkCylinderCollision(){
    for(int i = 0; i<cylinders.size(); i++){
      double dist = Math.pow(Math.pow(location.x - positions.get(i).x,2) + Math.pow(location.z - positions.get(i).y,2), 0.5);
      if(dist < radius + cylinderBaseSize){
        //collision
        PVector n = new PVector(location.x - positions.get(i).x, 0, location.z - positions.get(i).y);
        n = n.normalize();
        PVector V2 = velocity.sub(n.mult(2*(velocity.dot(n))));
        velocity = V2;
      }
    }
  }
}