void settings() {
size(1000, 1000, P2D);
}
void setup () {
}

float[][] transform1 = rotateXMatrix(PI/8);
float[][] transform3 = scaleMatrix(2, 2, 2);
float previousY = 0;

void draw() {
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  
  //rotated around x
  //float[][] transform1 = rotateXMatrix(PI/8);
  input3DBox = transformBox(input3DBox, transform1);
  My2DBox bla = projectBox(eye, input3DBox);
  bla.render();
  
  //rotated and translated
  float[][] transform2 = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();
  
  //rotated, translated, and scaled
  //float[][] transform3 = scaleMatrix(2, 2, 2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
}


My2DPoint projectPoint(My3DPoint eye, My3DPoint p) { //<>//
  float zz = -p.z/eye.z + 1;
  My2DPoint res = new My2DPoint((p.x-eye.x)/zz, (p.y-eye.y)/zz);
  
  return res;
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint bb[] = new My2DPoint[8];
  My2DBox result = new My2DBox(bb);
  for (int i = 0; i<8; ++i)
  {
    result.s[i] = projectPoint(eye, box.p[i]);
  }

  return result;
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}

float[][]  rotateXMatrix(float angle) {
return(new float[][] {{1, 0 , 0 , 0},
                      {0, cos(angle), sin(angle) , 0},
                      {0, -sin(angle) , cos(angle) , 0},
                      {0, 0 , 0 , 1}});
}

float[][]  rotateYMatrix(float angle) {
return(new float[][] {{cos(angle), 0 , -sin(angle) , 0},
                      {0, 1, 0, 0},
                      {sin(angle),  0, cos(angle) , 0},
                      {0, 0 , 0, 1}});
}
float[][]  rotateZMatrix(float angle) {
return(new float[][] {{cos(angle), sin(angle), 0 , 0},
                      {-sin(angle), cos(angle),  0, 0},
                      {0,  0, 1 , 0},
                      {0, 0 , 0 , 1}});
}
float[][]  scaleMatrix(float x, float y, float z) {
return(new float[][] {{x , 0 , 0 , 0},
                      {0 , y , 0 , 0},
                      {0 , 0 , z , 0},
                      {0 , 0 , 0 , 1}});
}
float[][]  translationMatrix(float x, float y, float z) {
return(new float[][] {{1 , 0 , 0 , x},
                      {0 , 1 , 0 , y},
                      {0 , 0 , 1 , z},
                      {0 , 0 , 0 , 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] res = new float[a[0].length];
  for (int k = 0; k<res.length; ++k)
  {
    res[k] = 0.0;
  }
  for (int i = 0; i<a.length; ++i)
  {
    for (int j = 0; j<b.length; ++j)
    {
      res[i] += a[i][j] * b[j];
    }
  }
  
  return res;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  for (int i = 0; i<box.p.length; ++i)
  {
    float [] transf = matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i]));
    box.p[i] = euclidian3DPoint(transf);
  }
  
  return box;
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}