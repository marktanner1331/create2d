import 'package:stagexl/src/geom/point.dart';

class Vertex extends Point {
  bool locked = false;

  Vertex(num x, num y) : super(x, y);

  static Vertex fromPoint(Point p) {
    return Vertex(p.x, p.y);
  }
}