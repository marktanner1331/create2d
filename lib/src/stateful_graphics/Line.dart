import 'package:stagexl/src/drawing.dart';
import 'package:stagexl/src/geom/point.dart';

import './Vertex.dart';
import './IShape.dart';
import '../property_mixins/LinePropertiesMixin.dart';
import '../property_mixins/ContextPropertyMixin.dart';

class Line extends IShape with ContextPropertyMixin, LinePropertiesMixin {
  Vertex _start;
  Vertex get start => _start;

  Vertex _end;
  Vertex get end => _end;

  Line(Vertex start, Vertex end)
      : assert(start != null),
        assert(end != null) {
    this._start = start;
    this._end = end;
  }

  @override
  bool hasVertex(Vertex vertex) {
    return identical(vertex, _start) || identical(vertex, _end);
  }

  @override
  bool isValid() {
    //a line is valid if the two vertices are different
    return _start != _end;
  }

  @override
  void swapVertex(Vertex oldVertex, Vertex newVertex) {
    assert(newVertex != null);

    if (_start == oldVertex) {
      _start = newVertex;
    } else if (_end == oldVertex) {
      _end = newVertex;
    }
  }

  @override
  Vertex getFirstVertexUnderPoint(Point p,
      {num squareTolerance = 0, bool ignoreLockedVertices = false}) {
    if (squareTolerance == 0) {
      if ((ignoreLockedVertices == false || _start.locked == false) &&
          _start == p) {
        return _start;
      } else if ((ignoreLockedVertices == false || _end.locked == false) &&
          _end == p) {
        return _end;
      }
    } else {
      if ((ignoreLockedVertices == false || _start.locked == false) &&
          _start.squaredDistanceTo(p) <= squareTolerance) {
        return _start;
      } else if ((ignoreLockedVertices == false || _end.locked == false) &&
          _end.squaredDistanceTo(p) <= squareTolerance) {
        return _end;
      }
    }

    return null;
  }

  Iterable<Vertex> getVerticesUnderPoint(Point p) {
    if (_start == p) {
      return [_start];
    } else if (_end == p) {
      return [_end];
    } else {
      return [];
    }
  }

  @override
  Iterable<Vertex> getVertices() {
    return [_start, _end];
  }

  @override
  void renderToStageXL(Graphics graphics) {
    graphics.beginPath();
    graphics.moveTo(_start.x, _start.y);
    graphics.lineTo(_end.x, _end.y);
    graphics.closePath();

    graphics.strokeColor(strokeColor, thickness);
  }

  @override
  bool hasVertexAtPoint(Point p) {
    return p == _start || p == _end;
  }

  @override
  void mergeVerticesUnderVertex(Vertex v) {
    if(v == _start) {
      _start = v;
    } else if(v == _end) {
      _end = v;
    }
  }

  @override
  bool foreachVertex(callback) {
    return callback(_start) && callback(_end);
  }

  @override
  Iterable<Vertex> getAllVerticesConnectedToVertex(Vertex v) {
    if(v == _start) {
      return [_end];
    }

    if(v == _end) {
      return [_start];
    }

    return [];
  }
}
