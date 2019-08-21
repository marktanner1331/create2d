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
  Vertex getFirstVertexUnderPoint(Point p, num squareTolerance) {
    assert(_end != null);
    if(_start.squaredDistanceTo(p) <= squareTolerance) {
      return _start;
    } else if(_end.squaredDistanceTo(p) <= squareTolerance) {
      return _end;
    } else {
      return null;
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
}