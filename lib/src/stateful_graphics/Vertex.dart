class Vertex {
  num _x;
  num get x => _x;
  
  num _y;
  num get y => _y;

  Vertex(num x, num y) {
    this._x = x;
    this._y = y;
  }

  num squareDistanceToPoint(num pointX, num pointY) {
    num deltaX = x - pointX;
    num deltaY = y - pointY;

    return deltaX * deltaX + deltaY * deltaY;
  }
}