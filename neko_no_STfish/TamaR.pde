class TamaR {
  boolean Life = true;

  float x;// 円の中心のX 座標
  float y;// 円の中心のY 座標
  float r;// 円の半径
  color c; // 円の色
  float speed; //速さ


  // コンストラクタの設定
  TamaR (float x0, float y0, 
  float r0, color c0, float speed0) {
    x = x0;
    y = y0;
    r = r0;
    c = c0;
    speed = speed0;

  }
  // 円を移動させる
  void update() {
    x -= speed; //動き
    if ( x + r < 0) {
      x = width+random(2000, 4000)+ r ;
      y = random(150, 450);
      speed = random(10, 30);
    }
  }
  // 円を描く
  void draw() {
    if (Life == true) { //弾が生きているなら
      stroke(c);
      fill(c);
      ellipse(x, y, 2*r, 2*r);
      image(RLTama, x-45, y-30);

      //ねこと当たり判定
      if (dist(x, y, valB, valA+60) <= r||dist(x, y, valB, valA-10) <= r+10) {
        Life = false;
        hit.trigger();
        HP=HP-1;
        speed = random(10, 30);
        x = width+random(2000, 4000)+ r ;
        y = random(150, 450);
        Life = true;
      }
    }
  }
}
