PGraphics pallet, tab01, tab02, tab03;
final float golden_ratio = 1.618;
final float circle_ratio = 0.75;
color selectColor = color(0, 0, 0); //ウィンドウサイズが100と同じ
color eraserColor = color(255, 255, 255);

int size_height = 1000; //仕方ない
int lv01_golden = round(size_height*(golden_ratio-1)); // 618
int lv02_golden = round(lv01_golden*(golden_ratio-1)); // 382
int lv03_golden = round(lv02_golden*(golden_ratio-1)); // 236

float pen_size = 0.5; //0.5 2 5
float ers_size = 0.1; //0.1 1 5

boolean ers_change = false;

PImage[] stepImg;
int stepImgNumber = 15; //保存する画像数
int backCount = 0, forwardCount = 0; // 戻った回数進んだ回数
int stepImgCount; // 取り出す画像の指定
boolean changeCanvas = false;

void setup(){
  size(1618, 1000);

  colorMode(HSB, 360, 100, 100);
  makeWindow();
  makeWindow_setup02(color(0, 0, 100));
  makeColorpallet(pallet);

  makeWindow_show();

  make_stepImg_setup();
}
void makeWindow(){
  //canvas = createGraphics(height, height);
  pallet = createGraphics(lv02_golden, lv02_golden);
  tab01 = createGraphics(lv02_golden/2, lv01_golden);
  tab02 = createGraphics(lv02_golden/2, lv01_golden);
  tab03 = createGraphics(lv03_golden, height);
}
void makeWindow_setup02(color base_color){
  noStroke();
  fill(base_color);
  rect(0, 0, 1000, 1000);
}

void makeColorpallet(PGraphics gg){
  int squareOneSide = gg.height;
  float large_r = squareOneSide/2;
  float small_r = (large_r)*circle_ratio;

  gg.beginDraw();
  gg.colorMode(HSB, 360, 100, 100);
  gg.pushMatrix();
  gg.translate(large_r, large_r);
  makeColorpallet_draw01(gg, large_r, small_r);
  makeColorpallet_draw02(gg, small_r, 0);
  gg.endDraw();
}
void makeColorpallet_draw01(PGraphics gg, float r01, float r02){
  float on_rad = TWO_PI/360;
  gg.noStroke();
  gg.fill(200);
  gg.rect(-r01, -r01, r01*2, r01*2);
  gg.noStroke();
  for(int i = 0; i < 360; i++){
    gg.fill(i, 100, 100);
    gg.arc(0, 0, r01*2, r01*2, i*on_rad, (i+1)*on_rad);
  }
  gg.fill(0, 0, 100);
  gg.ellipse(0, 0, r02*2, r02*2);
}
void makeColorpallet_draw02(PGraphics gg, float r02, float color_hue){
  int separate = 50;
  float separate_squareOneSide = r02*(1/sqrt(2))*2/separate;
  float start_separate_coordinate = -r02*(1/sqrt(2)); // スタートの座標

  gg.noStroke();
  for(int i = 0; i < separate; i++){
    for(int j = 0; j < separate; j++){
      float change_saturation = 100*(i+1)/separate;
      float change_brightness = 100*(j+0)/separate;
      gg.fill(color_hue, 100-change_saturation, 100-change_brightness);
      gg.rect(start_separate_coordinate + separate_squareOneSide*i, start_separate_coordinate + separate_squareOneSide*j, separate_squareOneSide + 1, separate_squareOneSide + 1); // 縦書いて横に伸ばす
    }
  }
}

void makeWindow_show(){
  //image(canvas, 0, 0);
  image(pallet, height, lv01_golden);
  //image(tab01, height, 0);
  //image(tab02, height+lv02_golden/2, 0);
  //image(tab03, height+lv02_golden, 0);
}

void make_stepImg_setup(){
  stepImg = new PImage[stepImgNumber];
  for (int i=0; i<stepImgNumber; i++){
    stepImg[i] = get(0, 0, 1000, 1000);
  }
}
void save_stepImg(){
  backCount = min(backCount+1, round(stepImgNumber/2));
  forwardCount = 0;
  stepImgCount_add();
  stepImg[stepImgCount] = get(0, 0, 1000, 1000);
}
void undo(){
  if (0 < backCount){
    backCount--;
    forwardCount++;
    stepImgCount_sub();
    show_stepImg();
  }
}
void redo(){
  if (0 < forwardCount){
    backCount++;
    forwardCount--;
    stepImgCount_add();
    show_stepImg();
  }
}
void stepImgCount_add(){
  stepImgCount = (stepImgCount + 1) % stepImgNumber;
}
void stepImgCount_sub(){
  stepImgCount = (stepImgCount - 1 + stepImgNumber) % stepImgNumber;
}
void show_stepImg(){
  image(stepImg[stepImgCount], 0, 0);
}

void mouseClicked(){
  float x = mouseX, y = mouseY;
  if ( height < x && x < height+lv02_golden/2
  && lv01_golden*0/3 < y && y < lv01_golden*1/3){
    ers_change = false;
    pen_size = 0.5*10;
    println(pen_size, ers_size, ers_change);
  }else if(height < x && x < height+lv02_golden/2
  && lv01_golden*1/3 < y && y < lv01_golden*2/3){
    ers_change = false;
    pen_size = 2*10;
    println(pen_size, ers_size, ers_change);
  }else if(height < x && x < height+lv02_golden/2
  && lv01_golden*2/3 < y && y < lv01_golden*3/3){
    ers_change = false;
    pen_size = 5*10;
    println(pen_size, ers_size, ers_change);
  }
  else if(height+lv02_golden/2 < x && x < height+lv02_golden
  && lv01_golden*0/3 < y && y < lv01_golden*1/3){
    ers_change = true;
    ers_size = 0.1*10;
    println(pen_size, ers_size, ers_change);
  }
  else if(height+lv02_golden/2 < x && x < height+lv02_golden
  && lv01_golden*1/3 < y && y < lv01_golden*2/3){
    ers_change = true;
    ers_size = 1*10;
    println(pen_size, ers_size, ers_change);
  }
  else if(height+lv02_golden/2 < x && x < height+lv02_golden
  && lv01_golden*2/3 < y && y < lv01_golden*3/3){
    ers_change = true;
    ers_size = 5*10;
    println(pen_size, ers_size, ers_change);
  }
  else if(height+lv02_golden < x && x < height+lv01_golden
  && height*3/4 < y && y < height*4/4){
    undo();
  }
  else if(height+lv02_golden < x && x < height+lv01_golden
  && height*2/4 < y && y < height*3/4){
    redo();
  }
}
void mousePressed(){
  if (0 < mouseX && mouseX < 1000 && 0 < mouseY && mouseY < 1000){
    changeCanvas = true;
  }
}
void mouseDragged(){
  if (0 < mouseX && mouseX < 1000 && 0 < mouseY && mouseY < 1000){
    changeCanvas = true;
  }
}
void mouseReleased(){
  if (changeCanvas){
    save_stepImg();
    changeCanvas = false;
  }
}

void draw(){
  float gg_pallet_center_x = height + lv02_golden/2;
  float gg_pallet_center_y = lv01_golden + lv02_golden/2;
  float gg_pallet_squareOneSide = (1/sqrt(2))*circle_ratio*lv02_golden/2;

  if (mousePressed){
    float x = mouseX, y = mouseY;

    // カラーパレットの色相
    if (gg_pallet_center_x - gg_pallet_squareOneSide < x
    && x < gg_pallet_center_x + gg_pallet_squareOneSide
    && gg_pallet_center_y - gg_pallet_squareOneSide < y
    && y < gg_pallet_center_y + gg_pallet_squareOneSide){
      selectColor = get(round(x), round(y));
    }

    // カラーパレットの彩度と明度　dist 座標から座標の距離　円の領域指定
    if (circle_ratio*lv02_golden/2 < dist(x, y, gg_pallet_center_x, gg_pallet_center_y)
    && dist(x, y, gg_pallet_center_x, gg_pallet_center_y) < lv02_golden/2){
      selectColor = get(round(x), round(y));
      pallet.beginDraw();
      pallet.translate(lv02_golden/2, lv02_golden/2);
      makeColorpallet_draw02(pallet, circle_ratio*lv02_golden/2, hue(selectColor));
      pallet.endDraw();
      image(pallet, height, lv01_golden);
    }

    // キャンバスだけ書けるように条件付け
    if (mousePressed){
      if (0 < mouseX && mouseX < 1000 && 0 < mouseY && mouseY < 1000
      && 0 < pmouseX && pmouseX < 1000 && 0 < pmouseY && pmouseY < 1000){
        if (ers_change){
          stroke(eraserColor);
          strokeWeight(ers_size);
        }else{
          stroke(selectColor);
          strokeWeight(pen_size);
        }
      line(mouseX, mouseY, pmouseX, pmouseY);
      }
    }
  }
}
