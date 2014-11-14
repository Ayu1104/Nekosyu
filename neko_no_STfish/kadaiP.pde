import processing.serial.*;
Serial port;
//音楽
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer player;//BGM
Minim minim2;
AudioSample hit;//被弾
Minim minim3;
AudioSample gets;//げっと
Minim minim4;
AudioPlayer GO;

BallR FishR;
BallL FishL;
TamaR JyamaR;
TamaL JyamaL;
PImage Neko; //ねこ画像
PImage Heart; //残機表示
PImage RFish; //右からくる魚
PImage LFish; //左からくる魚
PImage RLTama; //たま
PImage Back; //背景画像
PImage Title; //最初の画像
PImage Over; //ゲームオーバー画像
PFont Font; //文字
//ライフ
int HP;
boolean CLife = true;
//スコア
int score = 0;
int highscore = 0;

int play = 0;

//変数
int valA=0; //圧力センサの値
int valB=0; //抵抗器の値
//ゲームの状況をcurrentStateの値で判断するようにする関数宣言
int GAME_READY = 0; //始める前
int GAME_RUNNING = 1; //ゲーム中
int GAME_OVER = 2; //ゲームオーバー
int GAME_CLEAR = 3;
int GAME_CLEAR2 = 4;
int currentState;
int msave;
int sss;
void setup() {
  port = new Serial(this, "COM1", 9600);
  size(1000, 600);
  smooth(); //なめらかー
  //音楽の宣言
  minim = new Minim(this);
  player = minim.loadFile("sekaneko.mp3");//BGM
  minim2 = new Minim(this);
  hit =minim2.loadSample("damage.wav"); //被弾音
  minim3 = new Minim(this);
  gets =minim3.loadSample("sco.wav"); //げっと音
    minim4 = new Minim(this);
  GO =minim4.loadFile("zannen.mp3"); //ゲームオーバー

  //画像の宣言
  Neko = loadImage("neko.png"); //自機
  RFish = loadImage("fishRimg.png"); //右からくる魚
  LFish = loadImage("fishLimg.png"); //左からくる魚
  RLTama = loadImage("gomi.png"); //邪魔弾
  Heart=loadImage("life.png"); //ハート画像
  Back=loadImage("haikei.png"); //背景
  Title=loadImage("title.png"); //はじめ
  Over=loadImage("over.png"); //はじめ

  //フォントの宣言
  Font = loadFont("HGMaruGothicMPRO-48.vlw");
  textFont(Font);


  FishR = new BallR(width+random(100, 400), random(150, 450), 20, color(0, 99, 99), random(5, 10), random(2, 5));
  FishL = new BallL(random(-100, -400), random(150, 450), 20, color(250, 0, 0), random(5, 10), random(2, 5));
  //FishL = new BallL(random(-100,-400), random(150,450), 20, color(250, 0, 0), random(5,10),random(2,5));
  JyamaR = new TamaR(width+random(2000, 4000), random(150, 450), 20, color(0, 99, 99), random(5, 10));
  JyamaL = new TamaL(random(-2000, -4000), random(150, 450), 20, color(0, 99, 99), random(5, 10));
  HP = 5; //初期ライフ5
  score = 0;

  currentState = GAME_READY; //最初はスタート画面だから・・・
}

void draw() {
  if (currentState == GAME_READY) {//スタート前
    image(Title, 0, 0); //タイトル画面の画像を出すよ
    if (play>0) {
      setup();
    }
  }
  else if (currentState == GAME_RUNNING) {
    // player.rewind();
    player.play();
    play = 1;
    background(Back);
    noFill();


    FishR.update();
    FishR.draw();
    FishL.update();
    FishL.draw();
    JyamaR.update();
    JyamaR.draw();
    JyamaL.update();
    JyamaL.draw();
    fill(100, 255, 200);
    image(Neko, valB-33, valA-10); //猫画像表示
    //ellipse(valB, valA+10, 40, 40); //魚用当たり判定の円
    //ellipse(valB, valA+60, 50, 50); //当たり判定の円
    noStroke();
    rect(0, 0, width, 100);//スコアボード
    fill(250, 70, 40);
    textFont(Font, 30);// 表示するフォントと大きさの指定
    text("Score:"+score, /*"High score:"+highscore,*/ 400, 70);

    String jikan = millisTime(millis()-msave); //プレイ時間
    text(jikan, 800, 70);

    text("Life", 70, 40); //ライフ(文字)
    for (int h = 0; h < HP; h++) {//ハート
      image(Heart, (35*h+80), 50);
    }
    if (HP<=0) {
      currentState = GAME_OVER;
    }
  }//GAME_RUNNING閉じるかっこ
  if (currentState == GAME_OVER) { 
    image(Over, 0, 100);
    player.pause();
    GO.play();
  }
}//draw閉じるかっこ
//シリアルポートを受信したら
void serialEvent(Serial p) {
  String inString = port.readStringUntil('\n');
  //改行を検出したら、文字列を受信する

  if (inString != null) { //受信した文字列が空nullでなければ
    inString = trim(inString); //文字の前後空白を除去
    String [] value = split(inString, ',' );
    //カンマを検出して配列に格納

    if (value.length > 1) {
      println(value[0] +','+value[1]);
      valA = parseInt(value[0]); //文字列をint型に変換
      valB = parseInt(value[1]); //文字列をint型に変換
    }
  }
}  

String millisTime(int ms) {
  int ts = ms / 1000 ;// ミリ秒を秒に変換
  int s = ts%60; // ts から秒の部分を求める
  int m =ts/60 ; // ts から分の部分を求める
  return str(m) + "m" + str(s) + "s";
}

void mouseClicked() { //マウス押したらゲームスタート！
  if (currentState == GAME_READY) 
  {//タイトル画面
    currentState = GAME_RUNNING; //ゲームはじまるよ
    msave=0;
    msave=millis(); //スタートした瞬間の時間を記憶
  }
}


void stop() { //音止めるためのもの
  player.close(); // AudioPlayerの機能を終了する
  minim.stop(); // Minimの機能を停止する
  // minim2.stop();
  // minim3.stop();
  super.stop(); // 停止の際のおまじない
}

