import 'package:stagexl/src/geom/point.dart';

class Vertex extends Point {
  bool locked = false;
  List<void Function()> _onMoveCallbacks;

  Vertex(num x, num y) : super(x, y);

  static Vertex fromPoint(Point p) {
    return Vertex(p.x, p.y);
  }

  @override
  void set x(num value) {
    super.x = value;
    if(_onMoveCallbacks != null) {
      _onMoveCallbacks.forEach((a) => a());
    }
  }

  @override
  void set y(num value) {
    super.y = value;
    if(_onMoveCallbacks != null) {
      _onMoveCallbacks.forEach((a) => a());
    }
  }

  void setPosition(num x, num y) {
    super.x = x;
    super.y = y;
    if(_onMoveCallbacks != null) {
      _onMoveCallbacks.forEach((a) => a());
    }
  }

  bool stopListeningToMovements(void onMove()) {
    return _onMoveCallbacks.remove(onMove);
  }

  void listenToMovements(void onMove()) {
    if(_onMoveCallbacks == null) {
      _onMoveCallbacks = List();
    }

    _onMoveCallbacks.add(onMove);
  }
}