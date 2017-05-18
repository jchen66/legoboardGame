PImage img;
HScrollbar thresholdBar;
HScrollbar thresholdBar2;
BlobDetection bd = new BlobDetection();
int thr = 128;
float h1 = 128;
float h2 = 128;


void settings() {
  size(2400, 600);
}
void setup() {
  noLoop();
  //thresholdBar = new HScrollbar(0, 580, 800, 20);
  //thresholdBar2 = new HScrollbar(0, 550, 800, 20);
  img = loadImage("board1.jpg");
}
void draw() {
  background(color(0, 0, 0));
  image(img, 0, 0);
  //thresholdBar.display();
  //thresholdBar.update();
  //thresholdBar2.display();
  //thresholdBar2.update();
  //thr = (int)(thresholdBar.getPos()*255);
  //h1 = thresholdBar.getPos()*255;
  //h2 = thresholdBar2.getPos()*255;
  PImage img1 = thresholdHSB(img, 100, 140, 100, 255, 25, 155);
  PImage img2 = bd.findConnectedComponents(img1, false);
  image(img2, img.width, 0);
  image(scharr(img1), img.width*2, 0);
}

PImage threshold(PImage img, int threshold) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) > threshold) {
      result.pixels[i] = color(0, 0, 0);
    } else {
      result.pixels[i] = color(255, 255, 255);
    }
  }
  return result;
}
PImage huehue(PImage img) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (hue(img.pixels[i]) >= h1 && hue(img.pixels[i]) <= h2) {
      result.pixels[i] = color(hue(img.pixels[i]));
    }
  }
  return result;
}
PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; i++) {
    if (hue(img.pixels[i]) >= minH && hue(img.pixels[i]) <= maxH) {
      if (saturation(img.pixels[i]) >= minS && saturation(img.pixels[i]) <= maxS) {
        if (brightness(img.pixels[i]) >= minB && brightness(img.pixels[i]) <= maxB) {
          result.pixels[i] = color(255, 255, 255);
        }
      }
    }
  }
  return result;
}
boolean imagesEqual(PImage img1, PImage img2) {
  if (img1.width != img2.width || img1.height != img2.height)
    return false;
  for (int i = 0; i < img1.width*img1.height; i++)
    //assuming that all the three channels have the same value
    if (red(img1.pixels[i]) != red(img2.pixels[i]))
      return false;
  return true;
}

PImage convolute(PImage img) { //wrong, use alg from gaussian (could fix, but we're not using this function anymore)
  float[][] kernel = { { 0, 0, 0}, 
    { 0, 2, 0 }, 
    { 0, 0, 0 }};
  float normFactor = 1.f;
  int N = 3;
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int i = 0; i < img.width * img.height; i++) {
    float p = 0;
    for (int y = -N/2; y <= N/2; y++) {
      for (int x = -N/2; x <= N/2; x++) {
        int j = i+x + y*img.width;
        if (j >= 0 && j < img.width*img.height) {
          p+= brightness(img.pixels[j])*kernel[y+N/2][x+N/2];
        }
      }
    }
    p/= normFactor;
    result.pixels[i] = (color(p));
  }
  return result;
}

PImage gaussian(PImage img) {
  float[][] kernel = { { 9, 12, 9}, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};
  float normFactor = 99.f;
  int N = 3;
  PImage result = createImage(img.width, img.height, RGB);
  for (int xx = 1; xx < img.width-1; xx++) {
    for (int yy = 1; yy < img.height-1; yy++) { 
      float p = 0;
      for (int y = -N/2; y <= N/2; y++) {
        for (int x = -N/2; x <= N/2; x++) {
          int j = (xx+img.width*yy)+x + y*img.width;
          p+= brightness(img.pixels[j])*kernel[y+N/2][x+N/2];
        }
      }
      p/= normFactor;
      result.pixels[xx+yy*img.width] = (color(p));
    }
  }
  return result;
}

PImage scharr(PImage img) {
  float[][] vKernel = {
    {  3, 0, -3  }, 
    { 10, 0, -10 }, 
    {  3, 0, -3  } };
  float[][] hKernel = {
    {  3, 10, 3 }, 
    {  0, 0, 0 }, 
    { -3, -10, -3 } };
  int N = 3;
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];
  for (int xx = 1; xx < img.width-1; xx++) {
    for (int yy = 1; yy < img.height-1; yy++) { 
      float sum_h = 0;
      float sum_v = 0;
      for (int y = -N/2; y <= N/2; y++) {
        for (int x = -N/2; x <= N/2; x++) {
          int j = (xx+img.width*yy)+x + y*img.width;
          sum_h+= brightness(img.pixels[j])*hKernel[y+N/2][x+N/2];
          sum_v+= brightness(img.pixels[j])*vKernel[y+N/2][x+N/2];
        }
      }
      float sum=sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      if (sum > max) max = sum;
      buffer[xx+img.width*yy] = sum;
    }
  }


  for (int y = 2; y < img.height - 2; y++) {
    // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) {
      // Skip left and right
      int val=(int) ((buffer[y * img.width + x] / max)*255);
      result.pixels[y * img.width + x]=color(val);
    }
  }
  return result;
}