void settings() {
  size(500, 500, P2D);
}
void setup () {
}

float scale = 1;
float xRot = 0;
float yRot = 0;

void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  //scale
  input3DBox = transformBox(input3DBox, scaleMatrix(scale,scale,scale));
  //rotate
  input3DBox = transformBox(input3DBox, rotateXMatrix(xRot));
  input3DBox = transformBox(input3DBox, rotateYMatrix(yRot));
  //translate
  input3DBox = transformBox(input3DBox, translationMatrix(200, 200, 0));

  projectBox(eye, input3DBox).render();
}


void mouseDragged(){
  scale += (pmouseY-mouseY)/500.0;
  println(scale);
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      xRot += PI/16;
    }else if(keyCode == DOWN){
      xRot -= PI/16;
    }else if(keyCode == RIGHT){
      yRot += PI/16;
    }else if(keyCode == LEFT){
      yRot -= PI/16;
    }
  }
}






My2DPoint projectPoint(My3DPoint eye, My3DPoint p){
  float[][] T = { {1, 0, 0, -eye.x},
                  {0, 1, 0, -eye.y},
                  {0, 0, 1, -eye.z},
                  {0, 0, 0,      1} };
                  
  float[][] P = { {1, 0,          0, 0},
                  {0, 1,          0, 0},
                  {0, 0,          1, 0},
                  {0, 0, 1/(-eye.z), 0} };

  float[] v = {0, 0, 0, 0};
  float[] f = {0, 0, 0, 0};
  float[] pv = {p.x, p.y, p.z, 1};
  
  for (int i = 0; i < 4; i++) { 
    for (int k = 0; k < 4; k++) { 
      v[i] += T[i][k] * pv[k];
    }
  }

  for (int i = 0; i < 4; i++) { 
    for (int k = 0; k < 4; k++) { 
      f[i] += P[i][k] * v[k];
    }
  }
  return new My2DPoint(f[0]/f[3], f[1]/f[3]);
}


My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] points = new My2DPoint[8];
  for(int i = 0; i < 8; i++){
    points[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(points);
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}

float[][]  rotateXMatrix(float angle) {
  return(new float[][] { {1, 0 , 0 , 0},
                         {0, cos(angle), sin(angle) , 0},
                         {0, -sin(angle) , cos(angle) , 0},
                         {0, 0 , 0 , 1} });
}
float[][]  rotateYMatrix(float angle) {
  return(new float[][] { {cos(angle), 0 , sin(angle), 0},
                         {0, 1, 0 , 0},
                         {-sin(angle), 0, cos(angle), 1},
                         {0, 0, 0 , 1} });
}
float[][]  rotateZMatrix(float angle) {
  return(new float[][] { {cos(angle), -sin(angle) , 0, 0},
                         {sin(angle) , cos(angle) , 0, 0},
                         {0, 0 , 1 , 0},
                         {0, 0 , 0 , 1}});
}
float[][]  scaleMatrix(float x, float y, float z) {
  return(new float[][] { {x, 0, 0, 0},
                         {0, y, 0, 0},
                         {0, 0 , z , 0},
                         {0, 0 , 0 , 1}});
}
float[][]  translationMatrix(float x, float y, float z) {
  return(new float[][] { {1, 0, 0, x},
                         {0, 1, 0, y},
                         {0, 0, 1, z},
                         {0, 0, 0, 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] result = new float[4];
  for(int i = 0; i < a.length; i++){
    for(int j = 0; j < b.length; j++){
      result[i] += a[i][j] * b[j];
    }
  }
  return result;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] points = new My3DPoint[8];
  for(int i = 0; i < box.p.length; i++){
    float[] f = {box.p[i].x, box.p[i].y, box.p[i].z, 1};
    points[i] = euclidian3DPoint(matrixProduct(transformMatrix, f));
  }
  return new My3DBox(points);
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}