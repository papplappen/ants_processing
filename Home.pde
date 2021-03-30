
class Home {
  PVector pos;
  float radius;

  float food = 0;

  int counter = 0;
  final int BIRTH_RATE = 10;
  final float NEW_ANT_COST = 3;
  final float NEW_ANT_MINIM = 20;

  Home(PVector pos_, float radius_) {
    pos = pos_;
    radius = radius_;
  }


  void update() {
    counter++;
    if (food > NEW_ANT_MINIM && counter >= BIRTH_RATE) {
      counter = 0;
      newAnt();
      food -= NEW_ANT_COST;
    }
  }

  void newAnt() {
    ants.add(new Ant(pos.copy(), PVector.random2D()));
  }

  boolean take_food(float f) {
    if (food == 0) { 
      return false;
    }
    food -= f;
    if (food <= 0) {
      food = 0;
    }
    return true;
  }


  void show() {
    pushStyle();

    fill(HOME_COLOR);
    circle(pos.x, pos.y, radius);
    
    noStroke();
    fill(FOOD_COLOR);
    circle(pos.x, pos.y, 0.9*min(1, food/NEW_ANT_MINIM) * radius);


    popStyle();
  }
}
