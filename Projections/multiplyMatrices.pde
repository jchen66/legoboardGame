public static float[][] multiplyMatrices(float[][] m1, float[][] m2) {
    float[][] ergebnismatrix = null;
    
    int ii = m1[0].length;
    int ji = m2.length;

    if (ii == ji) {
      int zeilenm1 = m1.length;
      int spaltenm1 = m1[0].length;
      int spalenm2 = m2[0].length;

      ergebnismatrix = new float[zeilenm1][spalenm2];

      for (int i = 0; i < zeilenm1; i++) {
        for (int j = 0; j < spalenm2; j++) {
          ergebnismatrix[i][j] = 0;
          for (int k = 0; k < spaltenm1; k++) {
            ergebnismatrix[i][j] += m1[i][k] * m2[k][j];
          }
        }
      }
    }
    return ergebnismatrix;
  }