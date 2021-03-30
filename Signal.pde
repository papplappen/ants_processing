class Signal {
  PVector pos;
  float intensity;
  float INIT_INTENSITY;

  Signal(PVector pos_, float intensity_) {
    pos = pos_;
    intensity = intensity_;
    INIT_INTENSITY = abs(intensity_);
  }

  void update() {
    intensity *= 0.99;
    if (abs(intensity) < 0.1*INIT_INTENSITY) {
      signalsTBR[signalsIndex(pos.x)][signalsIndex(pos.y)].add(this);
    }
  }
  void show() {
    pushStyle();
    noStroke();
    if (intensity < 0) {
      fill(SIGNAL_NEG_COLOR, abs(intensity)*255);
    } else {
      fill(SIGNAL_POS_COLOR, abs(intensity)*255);
    }
    circle(pos.x, pos.y, 4);
    popStyle();
  }
}
