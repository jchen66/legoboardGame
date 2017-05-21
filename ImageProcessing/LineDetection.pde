List<PVector> hough(PImage edgeImg) { //<>// //<>//
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];

  // pre-compute the sin and cos values
  float[] tabSin = new float[phiDim];
  float[] tabCos = new float[phiDim];
  float ang = 0;
  float inverseR = 1.f / discretizationStepsR;
  for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
    // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
    tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
    tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
  }

  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        for (int indexPhi = 0; indexPhi < phiDim; indexPhi++ ) {
          float r = x * tabCos[indexPhi] + y * tabSin[indexPhi];
          int indexR = (int) r + (rDim - 1) / 2;
          accumulator[(indexPhi+1) * (rDim + 2) + 1 + indexR] += 1;
        }
      }
    }
  }

  houghDisplayAccumulator(accumulator, rDim, phiDim);

  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();

  int neighbourhood = 10;
  int minVotes = 150;
  
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int i = accPhi * rDim + accR;
      if (accumulator[i] > minVotes) {
        boolean bestCandidate = true;
        for (int neighPhi=-neighbourhood/2; neighPhi < neighbourhood/2; neighPhi++) {
          // outside the image? --> leave loop
          if ( accPhi+neighPhi < 0 || accPhi+neighPhi >= phiDim) continue;
          
          for (int neighR=-neighbourhood/2; neighR < neighbourhood/2; neighR++) {
          // outside the image? --> leave loop
            if (accR+neighR < 0 || accR+neighR >= rDim) continue;
            
            int neighIdx = (accPhi + neighPhi) * rDim + (accR + neighR);
            if (accumulator[i] < accumulator[neighIdx]) {
              // the current index is not a local maximum
              bestCandidate = false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current index is a local maximum
          bestCandidates.add(i);
        }
      }
    }
  }

  Collections.sort(bestCandidates, new HoughComparator(accumulator));
  int nb = min(bestCandidates.size(), nLines);

  //vector containing (r, phi) pairs
  ArrayList<PVector> bestCandLines = new ArrayList();

  for (int i : bestCandidates.subList(0, nb)) {
    if (accumulator[i] > 130) {
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) i / rDim;
      int accR = i - accPhi * rDim;
      float r = (accR - rDim/2) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;

      bestCandLines.add(new PVector(r, phi));
      
      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = (int) edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = (int) edgeImg.width;
      int x3 = (int) - ((y3 - r / sin(phi)) * sin(phi) / cos(phi));
      
      /*int test = 2;
      x0 = x0/test;
      x1 = x1/test;
      x2 = x2/test;
      x3 = x3/test;
      y0 = y0/test;
      y1 = y1/test;
      y2 = y2/test;
      y3 = y3/test;*/
      
      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        } else
          line(x2, y2, x3, y3);
      }
    }
  }

  return bestCandLines;
}

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  @Override
    public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2]
      || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1;
    return 1;
  }
}

void houghDisplayAccumulator(int[] accumulator, int rDim, int phiDim) {
  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  houghImg.updatePixels();

  //Display the accumulator
  img2 = houghImg;
}