class BallR {
  boolean Life = true;

  float x;// 円の中心のX 座標
  float y;// 円の中心のY 座標
  float r;// 円の半径
  color c; // 円の色
  float speed; //速さ
  float updown;
  int turn=0;
  // コンストラクタの設定
  BallR (float x0, float y0, 
  float r0, color c0, float speed0, float updown0) {
    x = x0;
    y = y0;
    r = r0;
    c = c0;
    speed = speed0;
    updown = updown0;
  }
  // 円を移動させる
  void update() {
    x -= speed; //動き
    y += updown;
    if (40<turn) {
      updown*=-1;
      turn=0;
    }
    else {
      turn++;
    }

    if ( x + r < 0) {
      x = width+random(500, 1000)+ r ;
      y = random(150, 450);
      speed = random(5, 15);
    }
  }
  // 円を描く
  void draw() {
    if (Life == true) { //弾が生きているなら
      stroke(c);
      fill(c);
      ellipse(x, y, 2*r, 2*r);
      image(RFish, x-45, y-30);

      //ねこと当たり判定
      if (dist(x, y, valB, valA-10) <= r+10) {
        Life = false;
        score = score + 100;
        gets.trigger();
        highscore = highscore  + 100;
        speed = random(5, 10);
        x = width+random(500, 1000)+ r ;
        y = random(150, 450);
        Life = true;
      }
    }
  }
}

