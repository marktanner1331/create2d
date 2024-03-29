import 'package:design2D/src/stateful_graphics/Vertex.dart';
import 'package:stagexl/stagexl.dart';

import '../helpers/StageXLDrawingHelper.dart';
import './IShape.dart';
import '../property_mixins/BoundingBoxMixin.dart';
import '../property_mixins/TextStyleMixin.dart';
import '../property_mixins/TextContentMixin.dart';

class Text extends IShape
    with TextStyleMixin, TextContentMixin, BoundingBoxMixin {
  //text only has one vertex that tracks the top left of the bounding box
  Vertex _topLeft;

  int get numVertices => 1;

  //we cache the text field so that we can reuse it for hittesting
  TextField _text;

  Text() {
    _topLeft = Vertex(0, 0);
    _text = TextField();
  }

  Point get position => _topLeft;
  void set position(Point value) => _topLeft = Vertex.fromPoint(value);

  @override
  void deleteVertices(Iterable<Vertex> selectedVertices) {
    if (selectedVertices.contains(_topLeft)) {
      _topLeft = null;
    }
  }

  @override
  bool foreachVertex(callback) {
    return callback(_topLeft);
  }

  @override
  Iterable<Vertex> getAllVerticesConnectedToVertex(Vertex v) {
    return Iterable.empty();
  }

  @override
  Vertex getFirstVertexUnderPoint(Point<num> p,
      {num squareTolerance = 0, bool ignoreLockedVertices = false}) {
    if (ignoreLockedVertices && _topLeft.locked) {
      return null;
    }

    if (squareTolerance == 0) {
      if (_topLeft == p) {
        return _topLeft;
      }
    } else {
      if (_topLeft.squaredDistanceTo(p) <= squareTolerance) {
        return _topLeft;
      }
    }
  }

  @override
  Iterable<Vertex> getVertices() {
    return [_topLeft];
  }

  @override
  Iterable<Vertex> getVerticesUnderPoint(Point<num> p) {
    if (_topLeft == p) {
      return [_topLeft];
    } else {
      Iterable.empty();
    }
  }

  @override
  bool hasVertex(Vertex vertex) {
    return _topLeft == vertex;
  }

  @override
  bool hasVertexAtPoint(Point<num> p) {
    return _topLeft == p;
  }

  @override
  bool hitTest(Point<num> p) {
    return p.x >= _topLeft.x &&
        p.x < _topLeft.x + _text.width &&
        p.y >= _topLeft.y &&
        p.y < _topLeft.y + _text.height;
  }

  @override
  bool isValid() {
    //TODO maybe only valid if we actually have text?
    return _topLeft != null;
  }

  @override
  void mergeVerticesUnderVertex(Vertex v) {
    if (_topLeft == v) {
      _topLeft = v;
    }
  }

  @override
  void renderToStageXL(Sprite s) {
    _text
      ..text = content == "" ? " " : content
      ..x = _topLeft.x
      ..y = _topLeft.y;

    applyStyleToText(_text);

    s.addChild(_text);

    if (boundingBoxVisible) {
      if (boundingBoxDashed == false) {
        s.graphics
          ..beginPath()
          ..moveTo(_text.x, _text.y)
          ..lineTo(_text.x + _text.width, _text.y)
          ..lineTo(_text.x + _text.width, _text.y + _text.height)
          ..lineTo(_text.x, _text.y + _text.height)
          ..closePath();
      } else {
        drawDash(
            s.graphics,
            Point(_text.x, _text.y),
            Point(_text.x + _text.width, _text.y),
            boundingBoxDashLength,
            boundingBoxDashSpacing);
        drawDash(
            s.graphics,
            Point(_text.x + _text.width, _text.y),
            Point(_text.x + _text.width, _text.y + _text.height),
            boundingBoxDashLength,
            boundingBoxDashSpacing);
        drawDash(
            s.graphics,
            Point(_text.x + _text.width, _text.y + _text.height),
            Point(_text.x, _text.y + _text.height),
            boundingBoxDashLength,
            boundingBoxDashSpacing);
        drawDash(
            s.graphics,
            Point(_text.x, _text.y + _text.height),
            Point(_text.x, _text.y),
            boundingBoxDashLength,
            boundingBoxDashSpacing);
      }

      if (boundingBoxThickness > 0) {
        s.graphics.strokeColor(boundingBoxStrokeColor, boundingBoxThickness,
            boundingBoxJointStyle);
      }
    }

    if (selected) {
      s.graphics
        ..beginPath()
        ..moveTo(_text.x, _text.y)
        ..lineTo(_text.x + _text.width, _text.y)
        ..lineTo(_text.x + _text.width, _text.y + _text.height)
        ..lineTo(_text.x, _text.y + _text.height)
        ..closePath()
        ..strokeColor(0xffff0000, 1);
    }
  }

  @override
  void swapVertex(Vertex oldVertex, Vertex newVertex) {
    if (_topLeft == oldVertex) {
      _topLeft = newVertex;
    }
  }

  @override
  Point<num> getClosestPointOnEdge(Point<num> p) {
    return null;
  }

  @override
  bool isPointOnEdge(Point<num> p, num tolerance) {
    return false;
  }

  @override
  void mergeInShape(IShape shape) {
    // TODO: implement mergeInShape
  }

  @override
  void mergeInVertices(Iterable<Vertex> vertices) {
    // TODO: implement mergeInVertices
  }
}
