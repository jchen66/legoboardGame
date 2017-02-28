class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render(){
    // Complete the code! use only line(x1, y1, x2, y2) built-in function.
    for(int i = 0; i < 3; i++){
      line(s[i].x, s[i].y, s[i+1].x, s[i+1].y);
      line(s[i].x, s[i].y, s[i+4].x, s[i+4].y);
    }
    for(int i = 4; i < 7; i++){
      line(s[i].x, s[i].y, s[i+1].x, s[i+1].y);
    }
    line(s[4].x, s[4].y, s[7].x, s[7].y);
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[3].x, s[3].y, s[7].x, s[7].y);
  }
}