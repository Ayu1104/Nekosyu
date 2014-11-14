void setup()
{
  Serial.begin(9600);//シリアルポートの設定
}

void loop()
{
  SerialRead(); //実行
   int valA =analogRead(0);//アナログ0pinの値を取得
   int valB =analogRead(1);//アナログ1pinの値を取得

   int tmpA = map(valA, 1023, 0, 500, 100); //計算
   int tmpB = map(valB, 1023, 0, 0, 1000 ); //計算
   
   Serial.print(tmpA);  //画面へ出力
   Serial.print(','); //カンマ
   Serial.print(tmpB);  //画面へ出力
   Serial.print('\n'); //改行←超重要
   //Serial.write(tmpA);
   
   //Serial.write(tmpB);
   //delay(50);
}

void SerialRead(){
  int i=0;
  char read_c;
  char read_datas[10];
  //データ受信
  if(Serial.available()){
    while(1){
      if(Serial.available()){
        read_c = Serial.read(); //1文字読み込み
        read_datas[i] = read_c;
        //文字列の終わりはzで判断
        if(read_c == 'z'){break;}
        i++;
      }
    }
    read_datas[i]= '\0';
  
    //測定スタート
    if(read_datas[0]=='O' && read_datas[1]=='N'){
        int valAs =analogRead(0);//アナログ0pinの値を取得
        //int valBs =analogRead(1);//アナログ1pinの値を取得

        int tmpAs = map(valAs, 1023, 0, 0, 255); //計算
        //float tmpBs = map(valBs, 1023, 0, 0, 100); //計算
        
        //Serial.print("start : "); //スタート
        //Serial.print(tmpAs);  //出力
        //Serial.print(","); //カンマ
        //Serial.println(tmpBs);  //出力
        
        Serial.write(tmpAs);
    }
  }
}

      



