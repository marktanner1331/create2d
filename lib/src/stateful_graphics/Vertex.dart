import 'package:stagexl/src/geom/point.dart';

class Vertex extends Point {
  Vertex(num x, num y) : super(x, y);
  static Vertex fromPoint(Point p) {
    return Vertex(p.x, p.y);
  }
}