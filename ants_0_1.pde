
PrintWriter output;
int counter;

final color ANT_COLOR = #000000;
final color HOME_COLOR = #775c0a;
final color FOOD_COLOR = #2eb217;
final color SIGNAL_POS_COLOR = #7251cc;
final color SIGNAL_NEG_COLOR = #f70e35;

ArrayList<Signal>[][] signals;
ArrayList<Signal>[][] signalsTBR;

ArrayList<Food> foods = new ArrayList<Food>();
ArrayList<Food> foodsTBR = new ArrayList<Food>();

ArrayList<Ant> ants = new ArrayList<Ant>();
ArrayList<Ant> antsTBR = new ArrayList<Ant>();

Home home;

int NUMBER_ANTS = 500;

boolean paused = true;
boolean show_signals = false;
boolean show_all = true;
void setup() {
  //size(1280, 720);
  size(1600, 900);
  frameRate(1000);
  ellipseMode(RADIUS);
  fill(0);
  textAlign(LEFT, TOP);
  textSize(30);


  output = createWriter("ants.csv"); 


  signals = new ArrayList[int(width/Ant.VIEW_CONE_RADIUS)+1][int(height/Ant.VIEW_CONE_RADIUS)+1];
  signalsTBR = new ArrayList[signals.length][signals[0].length];
  for (int i = 0; i < signals.length; i++) {
    for (int j = 0; j < signals[0].length; j++) {
      signals[i][j] = new ArrayList<Signal>();
      signalsTBR[i][j] = new ArrayList<Signal>();
    }
  }

  home = new Home(new PVector(width/2, height/2), 50);
  for (int i = 0; i < NUMBER_ANTS; i++) {
    home.newAnt();
  }
}
void draw() {
  background(0xcc);

  if (!paused) {
    updateAll();

    if (foods.size() < 8) {
      foods.add(new Food(new PVector(random(0, width), random(0, height)), int(random(50, 100))));
    }
    counter ++;
    if (counter >= 100) {
      counter = 0;
      output.println(ants.size());
      // output.flush();
    }
    if (ants.size() <= 0) {
      output.flush();
      output.close();
      exit();
    }
  }
  if (show_all) {
    showAll();
  }
  text(ants.size(), 0, 0);
  text(frameRate, 0, 25);
}

void updateAll() {
  for (int i = 0; i < signals.length; i++) {
    for (int j = 0; j < signals[0].length; j++) {
      for (Signal s : signals[i][j]) {
        s.update();
      }
      signals[i][j].removeAll(signalsTBR[i][j]);
    }
  }

  for (Ant a : ants) {
    a.update();
  }
  ants.removeAll(antsTBR);

  foods.removeAll(foodsTBR);

  home.update();
}
void showAll() {
  if (show_signals) {
    for (int i = 0; i < signals.length; i++) {
      for (int j = 0; j < signals[0].length; j++) {
        for (Signal s : signals[i][j]) {
          s.show();
        }
      }
    }
  }

  for (Food f : foods) {
    f.show();
  }

  for (Ant a : ants) {
    a.show();
  }

  home.show();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    addNewSignal(new Signal(new PVector(mouseX, mouseY), 100));
  } else if (mouseButton == RIGHT) {
    addNewSignal(new Signal(new PVector(mouseX, mouseY), -100));
  } else if (mouseButton == CENTER) {
    foods.add(new Food(new PVector(mouseX, mouseY), 200));
  }
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  } else if (key == 's') {
    show_signals = !show_signals;
  } else if (key == ESC) {
    output.flush();
    output.close();
    exit();
  } else if ( key == 'a') {
    show_all = !show_all;
  }
}


void addNewSignal(Signal s) {
  signals[signalsIndex(s.pos.x)][signalsIndex(s.pos.y)].add(s);
}

int signalsIndex(float p) {
  return int(p/Ant.VIEW_CONE_RADIUS);
}
