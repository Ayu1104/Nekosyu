ArrayList danmaku; //弾幕
ArrayList danmaku2;
//音楽
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer player;
Minim minim2;
AudioSample hit;
Minim minim3;
AudioSample nyantama;

PImage neko; //ねこ画像表示の関数
PImage title; //タイトル表示の関数
PImage life; //残機表示の関数
PImage start; //スタート画面表示関数
PImage over; //ゲームオーバー画面表示関数
PFont sidetext; //ライフの文字表示の関数

//ゲームの状況をcurrentStateの値で判断するようにする関数宣言
int GAME_READY = 0;
int GAME_RUNNING = 1;
int GAME_OVER = 2;
int currentState;

float atariX;
float atariY;


//弾幕じゃない弾についての関数
float sx = 160;
float sy = 0;
float sr = 20;

//自機弾の設定
float[] xBall, yBall, vBall; //弾
int numberOfBalls=0;
int maxBalls = 10;
float radius=30;

//背景の設定
float[] xhosi;
float[] yhosi;
int haikeiOfBalls = 100 ;
float haikei=1.5;

//ライフについての関数
int HP;

int score;
int highscore;
boolean isLife = true;

void setup() {
  size(700, 600); //画面サイズ
  frameRate(70); //毎秒のドロー実行の数
  smooth(); //なめらかー
  
  minim = new Minim(this);
  player = minim.loadFile("back_to_fall.mp3");//BGM
  minim2 = new Minim(this);
  hit =minim2.loadSample("damage.wav"); //被弾音
  minim3 = new Minim(this);
  nyantama =minim3.loadSample("sco.wav"); //被弾音
  
  HP = 5; //初期ライフ5
  score = 0;
  //表示する画像を指定
  neko=loadImage("neko.png");
  life=loadImage("life.png");
  title=loadImage("title.png");
  start=loadImage("start.png");
  over=loadImage("over.png");

  sidetext = loadFont("SegoePrint-48.vlw"); // vlwファイルの読み込み
  textFont(sidetext);

  currentState = GAME_READY; //最初はスタート画面だから・・・
  

  danmaku = new ArrayList(); //赤弾幕ー
  for (int i = 0; i < 360; i+=20) { 
    float rad = radians(i);
    danmaku.add(new Tama(width/2-100, 200, 30, cos(rad), sin(rad)));

    danmaku2 = new ArrayList(); //緑弾幕
    for (int o = 0; o < 360; o+=30) { 
      float rad2 = radians(o);
      danmaku2.add(new Tama2(45, 45, 50, cos(rad2), sin(rad2)));
    }
    sy = height; //ちっさい弾の初期位置
    sx = random(width-200); //ちっさい弾の初期位置
    
    //自機弾設定
    smooth();
    xBall = new float[maxBalls];
    yBall = new float[maxBalls];
    vBall = new float[maxBalls];
    //背景設定
    xhosi = new float [haikeiOfBalls];
    yhosi = new float [haikeiOfBalls];
    for (int j=0;j<haikeiOfBalls;j++) {
      xhosi[j] = random(haikei, width-haikei);
      yhosi[j] = random(haikei, height-haikei);
    }
  }
}



void draw() {
  background(0);
  if (currentState == GAME_READY) { //スタート前のときは
    image(start, 0, 0); //タイトル画面の画像を出すよ
    cursor(); //マウスカーソルは見えてる
    setup(); //はじめからやり直しだ!!
    
 
  }
  else if (currentState == GAME_RUNNING) { //ゲームがスタートしてるとき

    //背景の無意味に飛んでる宇宙の星みたいなの
    for (int i=0;i<haikeiOfBalls;i++) {
      yhosi[i] += 1;
      if ( yhosi[i] - haikei> height) {// (h)には不等号がはいる
        yhosi[i] = -haikei;
      }
strokeWeight(1);
      stroke(0, 0, 255); //背景星の枠線
      fill(255); //色
      ellipse(xhosi[i], yhosi[i], 2*haikei, 2*haikei);
    }
 tamaS(); //後ろからくる弾
    strokeWeight(1);
    fill(200, 220, 250);
    rect(500, 0, 500, width); //スコア表示とかするとこ
    image(title, 440, 360); //タイトル

    //fill(0, 200, 70); 
    //String jikan = millisToMS(millis()); //プレイ時間
    //text(jikan, 520, 400);

    fill(0, 0, 200);
    textSize(35); 
    text("Life", 520, 100); //ライフ(文字)

          
    
    for(int h = 0; h < HP; h++){//ハート
    image(life,(35*h+510),130);
}
     
    text("Score", 520, 220); //スコア(文字)
    fill(0, 200, 70); 
    text(score, 540, 280); //スコア
    
    fill(0, 0, 200);
    text("HighScore", 510, 350); //ハイスコア(文字)
    fill(0, 200, 70); 
    text(highscore, 530, 410); //ハイスコア
    if (mouseX > 465) { //スコアバーにはいるな！
      image(neko, 430, mouseY-70); //はいらせないぞ！
    }
    else { //スコアバー以外なら
      
      //当たり判定のための関数にマウス座標だいにゅー
      atariX=mouseX+3;
      atariY=mouseY-13;
      ellipse(atariX, atariY, 50, 50); //当たり判定
      image(neko, mouseX-30, mouseY-70); //プレイヤー動かせる
      

    }

    for (int k = danmaku.size() -1; k  >= 0; k--) { //赤弾幕
      Tama t = (Tama)danmaku.get(k);
      t.update();
    }
    for (int o = danmaku2.size() -1; o  >= 0; o--) {//緑弾幕
      Tama2 p = (Tama2)danmaku2.get(o);
      p.update();
    }
   
   
    
    
    for (int k=0;k<numberOfBalls;k++) { //自機弾
      moveBall(k);
      drawBall(k);
    }
    if (HP<=0){currentState = GAME_OVER;
  }
  }else if (currentState == GAME_OVER) {
    image(over, 0, 0);
     player.pause();
     cursor();
  }
  
  //小さい弾との当たり判定
  if(isLife ==true){
     if(dist(sx, sy, atariX, atariY) <= (sr/2+25)){
   fill(200); 
   hit.trigger(); //被弾音なる
   isLife = false;
   HP = HP-1;

 }
  }
} //drawを閉じるかっこ



//弾幕じゃない後ろからくる弾
void tamaS() {
  sy -= 7;
  strokeWeight(2);
  stroke(0, 200, 150);
  noFill();
  ellipse(sx, sy, sr, sr);
  if (sy <= 0) {
    sy = height;
    sx = random(width);
    isLife = true;
  }
}

float mx = 160;
float my = 0;
float mr = 10;

void tama2() {
  my += 10;
  stroke(70, 255, 90);
  ellipse(mx, my, mr, mr);
  if (my >= height) {
    my = 0;
    mx = random(width);
  }
}

//プログラム起動からの時間表示(無意味)
String millisToMS(int ms) {
  int ts = ms / 1000 ;// ミリ秒を秒に変換
  int s = ts%60; // ts から秒の部分を求める
  int m =ts/60 ; // ts から分の部分を求める
  return str(m) + "m" + str(s) + "s";
}


void drawBall(int idx) { 
  //ビーム玉
  noStroke();
  fill(255, 255, 100);//玉の色
  ellipse(xBall[idx], yBall[idx], radius, radius);//ビームの情報
}

void moveBall(int idx) {
  yBall[idx] += vBall[idx];
}

void mouseClicked() { //マウス押したらゲームスタート！
  if (currentState == GAME_READY) 
  {//タイトル画面
    currentState = GAME_RUNNING; //ゲームはじまるよ
    noCursor();
    player.rewind();
    player.play();
  }else if(currentState == GAME_OVER)
  {currentState = GAME_READY; //
  player.pause();
}
}
void mousePressed() { //マウスクリックだと移動中に弾でないから
  if (currentState == GAME_RUNNING) { //ゲーム始まってるときに打てるよ
    if (mouseX<465) { //スコアバーのとこでは打たせない
      if (mousePressed == true && mouseButton == LEFT) { //左クリックのみ
      nyantama.trigger();
        int last = numberOfBalls;
        if (numberOfBalls == maxBalls ) {
          last = numberOfBalls-1;
          for (int i=0;i < last;i++) {
            xBall[i]= xBall[i+1];
            yBall[i] = yBall[i+1];
            vBall[i] = vBall[i+1];
          }
        }
        else {
          numberOfBalls++;
        }
        xBall[last] = mouseX+4 ;//ねこの先端のx座標
        yBall[last] = mouseY-70;//ねこらへんy座標
        vBall[last] = -10;//速度
      }
    }
  }
}

void stop(){ //音止めるためのもの
player.close(); // AudioPlayerの機能を終了する
minim.stop(); // Minimの機能を停止する
minim2.stop();
minim3.stop();
super.stop(); // 停止の際のおまじない
}
