
class Food {
  PVector pos;
  float capacity;
  float INIT_CAPACITY;
  final float RADIUS = 25;

  Food(PVector pos_, int capacity_) {
    pos = pos_;
    capacity = capacity_;
    INIT_CAPACITY = capacity_;
  }

  void take(float f) {
    capacity -= f;
    if (capacity <= 0) {
      foodsTBR.add(this);
    }
  }

  void show() {
    pushStyle();
    noStroke();
    fill(FOOD_COLOR, 128);
    circle(pos.x, pos.y, RADIUS);
    fill(FOOD_COLOR);
    circle(pos.x, pos.y, capacity/INIT_CAPACITY * RADIUS);
    popStyle();
  }
}
