import './Vertex.dart';
import './IShape.dart';

class Line extends IShape {
  Vertex _start;
  Vertex get start => _start;

  Vertex _end;
  Vertex get end => _end;

  Line(Vertex start, Vertex end) : assert(start != null), assert(end != null) {
    this._start = start;
    this._end = end;
  }

  @override
  bool hasVertex(Vertex vertex) {
    return _start == vertex || _end == vertex;
  }

  @override
  bool isValid() {
    //a line is valid if the two vertices are different
    return _start != _end;
  }

  @override
  void swapVertex(Vertex oldVertex, Vertex newVertex) {
    assert(newVertex != null);

    if(_start == oldVertex) {
      _start = newVertex;
    } else if(_end == oldVertex) {
      _end = newVertex;
    }
  }

  @override
  Vertex getFirstVertexUnderPoint(num x, num y, num squareTolerance) {
    assert(_end != null);
    if(_start.squareDistanceToPoint(x, y) <= squareTolerance) {
      return _start;
    } else if(_end.squareDistanceToPoint(x, y) <= squareTolerance) {
      return _end;
    } else {
      return null;
    }
  }
}