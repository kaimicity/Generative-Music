
boolean inLeftSwitchButton() {
  if (getDistance(mouseX, mouseY, instrumentPosition.x - tw / 1.3, instrumentPosition.y + 3) < switchButtonR)
    return true;
  else
    return false;
}

boolean inRightSwitchButton() {
  if (getDistance(mouseX, mouseY, instrumentPosition.x + tw / 1.3, instrumentPosition.y + 3) < switchButtonR)
    return true;
  else
    return false;
}


boolean inClinch() {
  if (getDistance(mouseX, mouseY, scrollPosition.x + scrollWidth, instructionPosition.y + height / 10 + 7.5) < 7.5)
    return true;
  else
    return false;
}
