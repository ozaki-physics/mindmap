PGraphics canvas, pallet;
final float golden_ratio = 1.618;
final float circle_ratio = 0.75;
color selectColor = color(0, 0, 0);
int size_height = 1000;
int lv01_golden = round(size_height*(golden_ratio-1)); 
int lv02_golden = round(lv01_golden*(golden_ratio-1)); 
int lv03_golden = round(lv02_golden*(golden_ratio-1));

void setup(){
  size(1618, 1000);
  colorMode(HSB, 360, 100, 100);
  makeWindow();
  makeWindow_setup01(canvas, color(0, 0, 100));
  makeColorpallet(pallet);

  makeWindow_show();
}

void makeWindow(){
  canvas = createGraphics(height, height);
  pallet = createGraphics(lv02_golden, lv02_golden);

}

void makeWindow_setup01(PGraphics ff, color base_color){
  ff.beginDraw();
  ff.colorMode(HSB, 360, 100, 100);
  ff.background(base_color);
  ff.endDraw();
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

  float start_separate_coordinate = -r02*(1/sqrt(2)); 
  gg.noStroke();
  for(int i = 1; i < separate; i++){
    for(int j = 0; j < separate; j++){
      float change_saturation = 100*(i+1)/separate;
      float change_brightness = 100*(j+0)/separate;
      gg.fill(color_hue, 100-change_saturation, 100-change_brightness);
      gg.rect(start_separate_coordinate + separate_squareOneSide*i, start_separate_coordinate + separate_squareOneSide*j, separate_squareOneSide + 1, separate_squareOneSide + 1); // 縦書いて横に伸ばす
    }
  }
}

void makeWindow_show(){
  image(canvas, 0, 0);
  image(pallet, height, lv01_golden);
}

void draw(){
  float gg_pallet_center_x = height + lv02_golden/2;
  float gg_pallet_center_y = lv01_golden + lv02_golden/2;
  float gg_pallet_squareOneSide = (1/sqrt(2))*circle_ratio*lv02_golden/2;

  if (mousePressed){
    float x = mouseX, y = mouseY;

    if (gg_pallet_center_x - gg_pallet_squareOneSide < x
    && x < gg_pallet_center_x + gg_pallet_squareOneSide
    && gg_pallet_center_y - gg_pallet_squareOneSide < y
    && y < gg_pallet_center_y + gg_pallet_squareOneSide){
      selectColor = get(round(x), round(y));
    }

    if (circle_ratio*lv02_golden/2 < dist(x, y, gg_pallet_center_x, gg_pallet_center_y)
    && dist(x, y, gg_pallet_center_x, gg_pallet_center_y) < lv02_golden/2)
    {selectColor = get(round(x), round(y));
      pallet.beginDraw();
      pallet.translate(lv02_golden/2, lv02_golden/2);
      makeColorpallet_draw02(pallet, circle_ratio*lv02_golden/2, hue(selectColor));
      pallet.endDraw();
      image(pallet, height, lv01_golden);
    }

    canvas.beginDraw();
    canvas.stroke(selectColor);
    canvas.strokeWeight(10);
    canvas.line(mouseX, mouseY, pmouseX, pmouseY);
    canvas.endDraw();
    image(canvas, 0, 0);
    
  }

}
