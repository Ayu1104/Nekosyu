class Tama {
  float tx, ty, tr, dx, dy;
  boolean isLife =true;

  Tama(float x, float y, float r, float a, float b) {
    tx = x;
    ty = y;
    tr = r;
    dx = a;
    dy = b;
  }

  void update() {

    ty += dy;
    tx += dx;


    strokeWeight(1);   
    if (tx+tr/2>width-200 || tx-tr/2<0) {
      tx = width/2-100;
      isLife =true;
    }
    if (ty+tr/2>height || ty-tr/2<0) {
      ty = 100;
      isLife =true;
    }


    if (isLife ==true) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      ellipse(tx, ty, tr, tr);

      //にゃんこと敵弾のあたり判定

      if (BSHP>0) {
        if (dist(tx, ty, atariX, atariY) <= (tr/2+25)) {
          fill(200);
          hit.trigger(); //被弾音なる
          isLife = false;
          HP=HP-1;
        }
      }

      //にゃんたまと敵弾のあたり判定
      for (int i=0;i<maxBalls;i++) {
        if (dist(xBall[i], yBall[i], tx, ty) <=(tr/2+radius)) {
          isLife = false; 
          score = score+50;
          highscore = highscore+50;
        }
      }
    }
  }
}

