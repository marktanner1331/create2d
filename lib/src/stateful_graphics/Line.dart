import 'dart:math';

import 'package:stagexl/stagexl.dart' show Point, Sprite;

import './IShape.dart';
import './Vertex.dart';
import '../helpers/StageXLDrawingHelper.dart';
import '../property_mixins/LinePropertiesMixin.dart';

class Line extends IShape with LinePropertiesMixin {
  Vertex _start;
  Vertex _end;

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
    if(selectedVertices.contains(_start)) {
      _start = _end;
    } else if(selectedVertices.contains(_end)) {
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

    var lx = lx1 + t * ldx, ly = ly1 + t * ldy, dx = px - lx, dy = py - ly;
    return dx * dx + dy * dy;
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
  bool hitTest(Point<num> p) {
    if (_start.x < _end.x) {
      if (p.x <= _start.x - thickness || p.x >= _end.x + thickness) {
        return false;
      }
    } else {
      if (p.x <= _end.x - thickness || p.x >= _start.x + thickness) {
        return false;
      }
    }

    if (_start.y < _end.y) {
      if (p.y <= _start.y - thickness || p.y >= _end.y + thickness) {
        return false;
      }
    } else {
      if (p.y <= _end.y - thickness || p.y >= _start.y + thickness) {
        return false;
      }
    }

    num dx = _end.x - _start.x;
    num dy = _end.y - _start.y;
    num lineLengthSquared = dx * dx + dy * dy;
    num squareThickness = (thickness + 5) * (thickness + 5);

    num squareDistance = distanceSquaredToLineSegment2(
        _start.x, _start.y, dx, dy, lineLengthSquared, p.x, p.y);
    
    return squareDistance <= squareThickness;
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
    if(dashed == false) {
      s.graphics
      ..beginPath()
      ..moveTo(_start.x, _start.y)
      ..lineTo(_end.x, _end.y)
      ..closePath();
    } else {
      drawDash(s.graphics, start, end, dashLength, dashSpacing);
    }
    
    if(thickness > 0) {
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
}
