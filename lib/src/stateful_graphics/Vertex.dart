class Vertex {
  num x;
  num y;

  Vertex(num x, num y) {
    this.x = x;
    this.y = y;
  }

  num squareDistanceToPoint(num pointX, num pointY) {
    num deltaX = x - pointX;
    num deltaY = y - pointY;

    return deltaX * deltaX + deltaY * deltaY;
  }
}