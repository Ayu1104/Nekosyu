class Tama2 {
  float mx, my, mr,bx, by;
  boolean isLife =true;

  Tama2(float x2, float y2, float r2 , float a2,float b2) {
    mx = x2;
    my = y2;
    mr = r2;
    bx = a2;
    by = b2;
  }

  void update() {
    
    my += by+3;
    mx += bx+3;
    

 strokeWeight(1);   
    if (my>= height) {
      my = 0;
      mx = random(mr/2-100,mr);
      isLife =true;
    }
    if (mx+mr/2>width-200 || mx-mr/2<0) {
      mx = width/2-320;
      isLife =true;
    }
    
    if(isLife ==true){
    noFill();
    stroke(60,255,80);
    strokeWeight(2);
    ellipse(mx, my, mr, mr);
    
   //にゃんこと敵弾のあたり判定
   if (BSHP>0) {
   if(dist(mx, my, atariX, atariY) <= (mr/2+25)){
   fill(200);
   hit.trigger(); //被弾音なる
   isLife = false;
   HP=HP-1;
   }

 }
   //にゃんたまと敵弾のあたり判定
   for(int i=0;i<maxBalls;i++){
   if(dist(xBall[i] , yBall[i] , mx,my) <=(mr/2+radius)){
   isLife = false;
      score = score+100;
   highscore = highscore+100;
  }
}
    }
  }
}

