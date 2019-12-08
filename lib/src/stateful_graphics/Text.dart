import 'package:design2D/src/stateful_graphics/Vertex.dart';
import 'package:stagexl/stagexl.dart';

import './IShape.dart';
import '../property_mixins/TextStyleMixin.dart';

class Text extends IShape with TextStyleMixin {
  //text only has one vertex that tracks the top left of the bounding box
  Vertex _topLeft;

  Text() {
    _topLeft = Vertex(0, 0);
  }

  Point get position => _topLeft;
  void set position(Point value) => _topLeft = Vertex.fromPoint(value);

  @override
  void deleteVertices(Iterable<Vertex> selectedVertices) {
    if(selectedVertices.contains(_topLeft)) {
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
  Vertex getFirstVertexUnderPoint(Point<num> p, {num squareTolerance = 0, bool ignoreLockedVertices = false}) {
    if(ignoreLockedVertices && _topLeft.locked) {
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
    //TODO need to keep the textfield around
    //and then use its bounds
    return false;
  }

  @override
  bool isValid() {
    //TODO maybe only valid if we actually have text?
    return _topLeft != null;
  }

  @override
  void mergeVerticesUnderVertex(Vertex v) {
    if(_topLeft == v) {
      _topLeft = v;
    }
  }

  @override
  void renderToStageXL(Sprite s) {
    TextField text = TextField();
    
    TextFormat format = text.defaultTextFormat
      ..color = textColor
      ..size = textSize;

    text
      ..text = "hello world"
      ..defaultTextFormat = format
      ..x = _topLeft.x
      ..y = _topLeft.y;

    text
      ..width = text.textWidth
      ..height = text.textHeight;

    s.addChild(text);
  }

  @override
  void swapVertex(Vertex oldVertex, Vertex newVertex) {
    if(_topLeft == oldVertex) {
      _topLeft = newVertex;
    }
  }
}