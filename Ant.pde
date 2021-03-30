class Ant {
  PVector pos;
  PVector dir;

  final float SPEED = 3;
  static final float VIEW_CONE_RADIUS = 100;
  final float VIEW_CONE_ANGLE = radians(45);
  final float VIEW_CONE_SLICE = cos(VIEW_CONE_ANGLE);
  final float RANDOM_ROTATE_MAX = radians(30);
  final float RANDOM_ROTATE_MIN = radians(15);

  int counter = 0;
  final int STEPS_BETWEEN_SIGNAL = int(75/SPEED);

  float mood = 0;
  final float FEAR_MOOD = -0.25;
  final float FOOD_MOOD = 1;
  final float DELIVERY_MOOD = 1;

  float life;
  final float LIFE_DRAIN = 0.001;
  final float LIFE_PANIC = 0.1;



  boolean carries_food = false;

  Ant(PVector pos_, PVector dir_) {
    pos = pos_;
    dir = dir_;
    life = random(0.75, 1);
  }

  void update() {

    PVector tempDir = new PVector();

    if (!carries_food) {
      for (Food f : foods) {
        PVector relativePos = PVector.sub(f.pos, pos);
        if (relativePos.mag() < f.RADIUS) {
          f.take(1);
          carries_food = true;
          mood += FOOD_MOOD;
          dir.mult(-1);
          f.take(1-life);
          life = 1;
        }
        if (inViewCone(relativePos)) {
          tempDir.set(relativePos);
        }
      }
    }

    {
      PVector relativePos = PVector.sub(home.pos, pos);
      if (relativePos.mag() < home.radius) {
        if (carries_food) {
          carries_food = false;
          mood += DELIVERY_MOOD;
          home.food += 1;
          //dir.mult(-1);
          dir = PVector.random2D();
        }
        if (home.take_food(1-life)) {
          life=1;
        }
      }
      if (carries_food && inViewCone(relativePos)) {
        tempDir.set(relativePos);
      }
    }

    if (tempDir.magSq() == 0) {
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          int x = signalsIndex(pos.x)+i;
          int y = signalsIndex(pos.y)+j;
          if (x >= 0 && x< signals.length && y >= 0 && y < signals[0].length) {
            for (Signal s : signals[x][y]) {
              PVector relativePos = PVector.sub(s.pos, pos);
              if (inViewCone(relativePos)) {
                float dist = relativePos.mag();
                float dot = PVector.dot(relativePos, dir)/dist;
                relativePos.mult((s.intensity*((dot-VIEW_CONE_SLICE)/(1-VIEW_CONE_SLICE)))/max(VIEW_CONE_RADIUS/2, VIEW_CONE_RADIUS-dist));
                tempDir.add(relativePos);
              }
            }
          }
        }
      }
    }


    if (tempDir.magSq() != 0) {
      dir.add(tempDir);
      dir.normalize();
    }
    {
      float r = max(RANDOM_ROTATE_MIN, (1-life)*RANDOM_ROTATE_MAX);
      dir.rotate(random(-r, r));
    }
    //if (inViewCone(new PVector(mouseX, mouseY).sub(pos))) {
    //  dir.mult(-1);
    //  mood += FEAR_MOOD;
    //}

    pos.add(PVector.mult(dir, SPEED));

    if (pos.x > width) {
      pos.x = width;
      dir.x = - dir.x;
    }
    if (pos.x < 0) {
      pos.x = 0;
      dir.x = - dir.x;
    }    
    if (pos.y > height) {
      pos.y = height;
      dir.y = - dir.y;
    }    
    if (pos.y < 0) {
      pos.y = 0;
      dir.y = - dir.y;
    }

    mood *= 0.99;

    counter++;
    if (counter >= STEPS_BETWEEN_SIGNAL) {
      counter = 0;
      if (abs(mood) > 0.01) {
        addNewSignal(new Signal(pos.copy(), mood));
      }
    }

    life -= LIFE_DRAIN;
    if (mood >= 0 && life < LIFE_PANIC) {
      mood = FEAR_MOOD;
    } else if (life <= 0) {
      antsTBR.add(this);
    }
  }

  boolean inViewCone(PVector p_rel) {
    float dist = p_rel.mag();
    float dot = PVector.dot(p_rel, dir)/dist;
    return dist < VIEW_CONE_RADIUS && dot > VIEW_CONE_SLICE;
  }

  void show() {
    pushStyle();
    noStroke();
    //if (mood > 0) {
    //  fill(0, 20*mood, 0);
    //} else {
    //  fill(20*mood, 0, 0);
    //}
    fill(ANT_COLOR);
    circle(pos.x-5*dir.x, pos.y-5*dir.y, 3);
    circle(pos.x, pos.y, 2);

    if (carries_food) {
      fill(FOOD_COLOR);
    } else {
      fill(ANT_COLOR);
    }
    circle(pos.x+5*dir.x, pos.y+5*dir.y, 2.5);

    PVector o = new PVector(dir.y, -dir.x);
    
    stroke(ANT_COLOR);
    line(pos.x + 5*(o.x+dir.x), pos.y + 5*(o.y+dir.y), pos.x - 5*(o.x+dir.x), pos.y - 5*(o.y+dir.y));
    line(pos.x + 5*(-o.x+dir.x), pos.y + 5*(-o.y+dir.y), pos.x - 5*(-o.x+dir.x), pos.y - 5*(-o.y+dir.y));
    line(pos.x + 5*(o.x), pos.y + 5*(o.y), pos.x - 5*(o.x), pos.y - 5*(o.y));

    popStyle();
  }
}
