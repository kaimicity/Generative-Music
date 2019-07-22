
float normaliseAngle(float angle) {
  if (angle < 0)
    angle += PI * 2;
  else if (angle >= PI * 2)
    angle -= PI * 2;
  return angle;
}

void tagsReset() {
  lightTag.setX(currentPercussion.getLowThreshold());
  lightTag.setContent(currentPercussion.getSoundName1());
  heavyTag.setX(currentPercussion.getHighThreshold());
  heavyTag.setContent(currentPercussion.getSoundName2());
}

void mountEnterStroke(color c, int opa) {
  if (enter || back) {
    stroke(c, opa);
  } else {
    stroke(c);
  }
}
void mountEnterFill(color c, int opa) {
  if (enter|| back) {
    fill(c, opa);
  } else {
    fill(c);
  }
}


float getDistance(float x1, float y1, float x2, float y2) {
  PVector dis = new PVector(x1 - x2, y1 - y2) ;
  return dis.mag() ;
}
