import 'dart:math';

import 'package:stagexl/stagexl.dart';
import 'package:tuple/tuple.dart';

import './IShape.dart';
import './Vertex.dart';
import '../helpers/StageXLDrawingHelper.dart';
import '../property_mixins/LinePropertiesMixin.dart';

class Line extends IShape with LinePropertiesMixin {
  Vertex _start;
  Vertex _end;

  ///vertex stored alongside its position along the line
  ///e.g. if it is at the start then it will be 0
  ///     if it is at the end then it will be 1
  ///     if it is half way along then it will be 0.5
  List<Tuple2<Vertex, num>> _insignificantVertices;

  ///set to true when we are in the middle of processing vertices being changed
  ///as some of the processing will cause more vertex change callbacks to fire
  ///by checking this it means we won't end up in an endless loop
  bool _verticesAreChanging = false;

  Line(Vertex start, Vertex end)
      : assert(start != null),
        assert(end != null) {
    this._start = start;
    this._end = end;
  }
  Vertex get end => _end;

  Vertex get start => _start;

  @override
  void deleteVertices(Iterable<Vertex> selectedVertices) {
    //setting start and end to be the same vertex will make it invalid
    //which will cause it to be removed
    if (selectedVertices.contains(_start)) {
      _start = _end;
    } else if (selectedVertices.contains(_end)) {
      _end = _start;
    }
  }

  //from: https://github.com/scottglz/distance-to-line-segment/blob/master/index.js
  num distanceSquaredToLineSegment2(
      lx1, ly1, ldx, ldy, lineLengthSquared, px, py) {
    //print("$lx1, $ly1, $ldx, $ldy, $lineLengthSquared, $px, $py");

    var t = ((px - lx1) * ldx + (py - ly1) * ldy) / lineLengthSquared;

    if (t < 0)
      t = 0;
    else if (t > 1) t = 1;

    var lx = lx1 + t * ldx;
    var ly = ly1 + t * ldy;
    var dx = px - lx;
    var dy = py - ly;
    return dx * dx + dy * dy;
  }

  //returns the point on the line that is closest to the given point
  Point<num> _getClosestPointOnLine(num lx1, num ly1, num ldx, num ldy,
      num lineLengthSquared, num px, num py) {
    num t = ((px - lx1) * ldx + (py - ly1) * ldy) / lineLengthSquared;

    if (t < 0) {
      t = 0;
    } else if (t > 1) {
      t = 1;
    }

    num lx = lx1 + t * ldx;
    num ly = ly1 + t * ldy;

    return Point<num>(lx, ly);
  }

  @override
  bool foreachVertex(callback) {
    return callback(_start) && callback(_end);
  }

  @override
  Iterable<Vertex> getAllVerticesConnectedToVertex(Vertex v) {
    if (v == _start) {
      return [_end];
    }

    if (v == _end) {
      return [_start];
    }

    return [];
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

  @override
  Iterable<Vertex> getVertices() {
    return [_start, _end];
  }

  Iterable<Vertex> getVerticesUnderPoint(Point p) {
    if (_start == p) {
      return [_start];
    } else if (_end == p) {
      return [_end];
    } else {
      return Iterable.empty();
    }
  }

  @override
  bool hasVertex(Vertex vertex) {
    return identical(vertex, _start) || identical(vertex, _end);
  }

  @override
  bool hasVertexAtPoint(Point p) {
    return p == _start || p == _end;
  }

  @override
  Point getClosestPointOnEdge(Point p) {
    num dx = _end.x - _start.x;
    num dy = _end.y - _start.y;
    num lineLengthSquared = dx * dx + dy * dy;

    return _getClosestPointOnLine(
        _start.x, _start.y, dx, dy, lineLengthSquared, p.x, p.y);
  }

  @override
  bool isPointOnEdge(Point p, num tolerance) =>
      _hitTest(p, tolerance + thickness);

  @override
  bool hitTest(Point<num> p) => _hitTest(p, thickness);

  bool _hitTest(Point<num> p, num tolerance) {
    if (_start.x < _end.x) {
      if (p.x <= _start.x - tolerance || p.x >= _end.x + tolerance) {
        return false;
      }
    } else {
      if (p.x <= _end.x - tolerance || p.x >= _start.x + tolerance) {
        return false;
      }
    }

    if (_start.y < _end.y) {
      if (p.y <= _start.y - tolerance || p.y >= _end.y + tolerance) {
        return false;
      }
    } else {
      if (p.y <= _end.y - tolerance || p.y >= _start.y + tolerance) {
        return false;
      }
    }

    num dx = _end.x - _start.x;
    num dy = _end.y - _start.y;
    num lineLengthSquared = dx * dx + dy * dy;
    num squareTolerance = tolerance * tolerance;

    num squareDistance = distanceSquaredToLineSegment2(
        _start.x, _start.y, dx, dy, lineLengthSquared, p.x, p.y);

    return squareDistance <= squareTolerance;
  }

  @override
  bool isValid() {
    //a line is valid if the two vertices are different
    return _start != _end;
  }

  @override
  void mergeVerticesUnderVertex(Vertex v) {
    if (v == _start) {
      _start = v;
    } else if (v == _end) {
      _end = v;
    }
  }

  @override
  void renderToStageXL(Sprite s) {
    if (dashed == false) {
      s.graphics
        ..beginPath()
        ..moveTo(_start.x, _start.y)
        ..lineTo(_end.x, _end.y)
        ..closePath();
    } else {
      drawDash(s.graphics, start, end, dashLength, dashSpacing);
    }

    if (thickness > 0) {
      s.graphics.strokeColor(strokeColor, thickness, jointStyle);
    }

    if (selected) {
      s.graphics
        ..beginPath()
        ..moveTo(_start.x, _start.y)
        ..lineTo(_end.x, _end.y)
        ..closePath()
        ..strokeColor(0xffff0000, 1);
    }
  }

  @override
  void swapVertex(Vertex oldVertex, Vertex newVertex) {
    if (_start == oldVertex) {
      _start = newVertex;
    } else if (_end == oldVertex) {
      _end = newVertex;
    }
  }
  
  ///only fires if we have insignificant vertices
  void _onVertexPositionChanged() {
    if(_verticesAreChanging) {
      return;
    }

    _verticesAreChanging = true;

    //move insignificant vertices here

    _verticesAreChanging = false;
  }

  void _addInsignificantVertex(Vertex v) {
    if(_insignificantVertices == null) {
      _insignificantVertices = List();
      _start.listenToMovements(_onVertexPositionChanged);
      _end.listenToMovements(_onVertexPositionChanged);
    }

    _insignificantVertices.add(Tuple2(v, 0));
  }

  @override
  void mergeInShape(IShape shape) {
    for (Vertex vertex in shape.getVertices()) {
      if (_start.locked == false && _start == vertex) {
        shape.swapVertex(vertex, _start);
      } else if (_end.locked == false && _end == vertex) {
        shape.swapVertex(vertex, _end);
      } else if (_hitTest(vertex, 0)) {
        //shape is directly on the edge, so we can add it as an insignificant vertex
        _addInsignificantVertex(vertex);
      }
    }
  }
}
