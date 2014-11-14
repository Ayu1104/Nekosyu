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
Minim minim4;
AudioSample LPp;
Minim minim5;
AudioSample BSD;
Minim minim6;
AudioSample bossloss;
Minim minim7;
AudioPlayer GO;
Minim minim8;
AudioPlayer fun;

PImage neko; //ねこ画像表示の関数
PImage title; //タイトル表示の関数
PImage life; //残機表示の関数
PImage start; //スタート画面表示関数
PImage over; //ゲームオーバー画面表示関数
PImage clear; //クリア画像
PImage boss; //ボスの画像
PImage bosslose; //負けたボスの画像
PImage hikari;//ボスのエフェクト
PImage care;//回復エフェクト
PImage lifepp;

PFont Stext; //台詞フォント

//ゲームの状況をcurrentStateの値で判断するようにする関数宣言
int GAME_READY = 0;
int GAME_RUNNING = 1;
int GAME_OVER = 2;
int GAME_CLEAR = 3;
int GAME_CLEAR2 = 4;
int currentState;
int sss;

float atariX;
float atariY;

int rectX, rectY;




//弾幕じゃない弾についての関数
float sx = 160;
float sy = 0;
float sr = 20;

float br=90;

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

//ゲーム開始するまでの時間を保存する関数
int msave;
//ボス倒した瞬間の時間を記憶
int wsave;

//ライフについての関数
int HP;
boolean isLife = true;

int score;
int highscore;

float bsx, bsy; //ボスの座標
float lsx, lsy; //ボスが死んだ座標を記録する変数
int BSHP; //ボスのHP
boolean bossdie = true; //ボス死んだ効果音
float bsspX;
float bsspY;


void setup() {
  size(700, 600); //画面サイズ
  frameRate(70); //毎秒のドロー実行の数
  smooth(); //なめらかー

  minim = new Minim(this);
  player = minim.loadFile("kiseki_no_mukoude.mp3");//BGM
  minim2 = new Minim(this);
  hit =minim2.loadSample("damage.wav"); //被弾音
  minim3 = new Minim(this);
  nyantama =minim3.loadSample("sco.wav"); //被弾音
  minim4 = new Minim(this);
  LPp =minim4.loadSample("lp.wav"); //回復音
  minim5 = new Minim(this);
  BSD =minim5.loadSample("bsdamage.wav"); //ボスにあたる音
  minim6 = new Minim(this);
  bossloss =minim6.loadSample("loss.wav"); //ボスが死ぬ音
  minim7 = new Minim(this);
  GO =minim7.loadFile("zannen.mp3"); //ゲームオーバー
  minim8 = new Minim(this);
  fun =minim8.loadFile("yeah.mp3"); //クリアおめでとー

  HP = 5; //初期ライフ5
  BSHP = 1000; //ボスのライフ
  score = 0;

  //表示する画像を指定
  neko=loadImage("neko.png");
  life=loadImage("life.png");
  title=loadImage("title.png");
  start=loadImage("start.png");
  over=loadImage("over.png");
  lifepp=loadImage("lifep.png");
  boss=loadImage("boss.png");
  hikari=loadImage("hidan.png");
  care=loadImage("care.png");
  bosslose=loadImage("bossloss.png");
  clear=loadImage("clear.png");

  bsx=120;
  bsy=70;
  bsspX=3;
  bsspY=3;

  Stext = loadFont("HGMaruGothicMPRO-48.vlw");
  textFont(Stext);

  currentState = GAME_READY; //最初はスタート画面だから・・・

  danmaku = new ArrayList(); //赤弾幕ー
  for (int i = 0; i < 360; i+=20) { 
    float rad = radians(i);
    danmaku.add(new Tama(width/2-110, 190, 40, 1.5*cos(rad), 1.5*sin(rad)));
  }

  danmaku2 = new ArrayList(); //緑弾幕
  for (int o = 0; o < 360; o+=50) { 
    float rad2 = radians(o);
    danmaku2.add(new Tama2(45, 45, 50, cos(rad2), sin(rad2)));
  }

  sy = height; //ちっさい弾の初期位置
  sx = random(width-200); //ちっさい弾の初期位置

  rectX=0;
  rectY=0;


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

    strokeWeight(1);
    fill(200, 220, 250);

    rect(500, 0, 500, width); //スコア表示とかするとこ
    image(title, 440, 360); //タイトル

    fill(100, 0, 200); 
    String jikan = millisToMS(millis()); //プレイ時間
    text(jikan, 550, 450);

    fill(0, 0, 200);
    textSize(35); 
    text("Life", 520, 100); //ライフ(文字)



    for (int h = 0; h < HP; h++) {//ハート
      image(life, (35*h+510), 130);
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


    //初期位置のボス


    int sss =second();

    ellipse(bsx+115, bsy+80, br, br);//ボスのあたり判定のためのやつ
    image(boss, bsx, bsy);

    textFont(Stext, 22);// 表示するフォントと大きさの指定
    fill(255);
    // 文字列の表示
    if (millis()-msave>5000&&millis()-msave<8000)
    {
      text("ここまで来るとは、たいしたものだ　▼", 100, 290);
    }
    if (millis()-msave>8000&&millis()-msave<11000)
    {
      player.rewind();
      player.play();
      text("その勇気だけは称えてやろう………　▼", 100, 290);
    }
    if (millis()-msave>11000&&millis()-msave<14000)
    {
      text("貴様に、俺が倒せるというのか　　　▼", 100, 290);
    }
    if (millis()-msave>14000&&millis()-msave<17000)
    {
      text("……来るがいい！　　　　　　　　　▼", 100, 290);
    }
    if (millis()-msave>17000)
    {
      if (millis()-msave<19000)
      {
        fill(0, 100, 200);
        textFont(Stext, 40);
        text("Last Battle Start !!", 80, 290);
      }


      tamaS(); //回復弾
      for (int k = danmaku.size() -1; k  >= 0; k--) { //赤弾幕
        Tama t = (Tama)danmaku.get(k);
        t.update();
      }
      for (int o = danmaku2.size() -1; o  >= 0; o--) {//緑弾幕
        Tama2 p = (Tama2)danmaku2.get(o);
        p.update();
      }


      //ボスの動き
      bsx=bsx+bsspX;
      bsy=bsy+bsspY;

      if (bsx>265||bsx<15) {
        bsspX=-bsspX;
      }
      if (bsy+50>height-400||bsy<0)
      {
        bsspY=-bsspY;
      }
    }
    //ボスが死ぬ
    if (BSHP<=0) {
      fill(255);
      rect(0, 0, width, height);
      lsx=bsx;
      lsy=bsy; //死んだ座標を代入
      bsx=1000;
      bsy=1000; //生きてる画像がどっかいく
      delay(200);
      currentState = GAME_CLEAR;
    }



    for (int k=0;k<numberOfBalls;k++) { //自機弾
      moveBall(k);
      drawBall(k);
    }

    //もしライフが0になればゲームオーバー
    if (HP<=0) {
      currentState = GAME_OVER;
    }


    //回復弾との当たり判定
    if (isLife ==true) {
      if (dist(sx, sy, atariX, atariY) <= (sr/2+25)) {
        fill(200);
        if (HP<5) {

          LPp.trigger(); //被弾音なる

          image(care, mouseX-30, mouseY-70);

          isLife = false;
          HP = HP+1;
        }
      }
    }
    //ニャンタマとボスのあたり判定
    for (int ba=0;ba<maxBalls;ba++) {
      if (dist(xBall[ba], yBall[ba], bsx+115, bsy+80) <=(br+radius)) {

        score = score+1;
        highscore = highscore+1;
        BSD.trigger();
        BSHP = BSHP-1;
        image(hikari, bsx+20, bsy-20, 200, 200);
      }
    }
  }

  //ゲームオーバーになると画像表示と音楽をとめる
  if (currentState == GAME_OVER) { 
    image(over, 0, 0);
    player.pause();
    GO.play();
    cursor();
  }

  //ゲームクリア
  if (currentState == GAME_CLEAR) { 
    if (bossdie==true)
    {

      fill(255);
      rect(0, 0, rectX+width, rectY+height);
      delay(300);
      fill(0, 255, 255);
      rect(0, 0, rectX+width, rectY+height);
      bossloss.trigger();
      player.pause();
      wsave=millis();
      bossdie=false;
    }

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

    strokeWeight(1);
    fill(200, 220, 250);

    rect(500, 0, 500, width); //スコア表示とかするとこ
    image(title, 440, 360); //タイトル

    fill(0, 0, 200);
    textSize(35); 
    text("Life", 520, 100); //ライフ(文字)

    for (int h = 0; h < HP; h++) {//ハート
      image(life, (35*h+510), 130);
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
    image(bosslose, lsx, lsy);
    textFont(Stext, 22);// 表示するフォントと大きさの指定
    fill(255);

    if (millis()-wsave>3000&&millis()-wsave<6000)
    {
      text("こ、この俺が負けた……だと!?　　　▼", 100, 290);
    }
    if (millis()-wsave>6000&&millis()-wsave<9000)
    {
      text("もはや……ここまで、か…　　　　　▼", 100, 290);
    }
    if (millis()-wsave>9000)
    {
      currentState = GAME_CLEAR2;
    }
  }//ゲームクリア閉じるかっこ
  if (currentState == GAME_CLEAR2) 
  {
    fun.play();
    image(clear, 0, 0);
    cursor();
  }
} //drawを閉じるかっこ

//後ろからくる回復弾
void tamaS() {
  sy -= 5;
  strokeWeight(2);
  stroke(0, 200, 150);
  noFill();
  image(lifepp, sx-25, sy-25);

  if (sy <= 0) {
    sy = height;
    sx = random(-500, width-230);
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
    BSHP = 1000; //ボスのライフ
    noCursor();
    msave=0;
    msave=millis(); //スタートした瞬間の時間を記憶
  }
  else if (currentState == GAME_OVER||currentState == GAME_CLEAR2)//ゲームオーバーやクリアのときにクリックしたら
  {//タイトルにもどるよー
    player.pause();
    GO.pause();
    fun.pause();
    currentState = GAME_READY; //
  }
}

//ねこのショット
void mousePressed() { //マウスクリックだと移動中に弾でないから
  if (currentState == GAME_RUNNING) { //ゲーム始まってるときに打てるよ
    if (millis()-msave>17000) { //ボスが喋りおわるまで打つなよ
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
}

void stop() { //音止めるためのもの
  player.close(); // AudioPlayerの機能を終了する
  minim.stop(); // Minimの機能を停止する
  minim2.stop();
  minim3.stop();
  super.stop(); // 停止の際のおまじない
}

