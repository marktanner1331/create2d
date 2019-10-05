import 'package:stagexl/src/drawing.dart';

import './Vertex.dart';
import './IShape.dart';
import 'package:stagexl/src/geom/point.dart';

//the high level class that owns and manages the stateful graphics objects
class Container extends IShape {
  List<IShape> _shapes;
  Iterable<IShape> get shapes => _shapes;

  Container() {
    _shapes = List();
  }

  void addShape(IShape shape, bool mergeVertices) {
    if (mergeVertices) {
      for(Vertex vertex in shape.getVertices()) {
        Vertex existingVertex = getFirstVertexUnderPoint(vertex, 1, true);

        if(existingVertex != null) {
          shape.swapVertex(vertex, existingVertex);
        }
      }
    }

    if(shape is Container) {
      _shapes.addAll(shape._shapes);
    } else {
      _shapes.add(shape);
    }
  }

  ///returns the first vertex found which is close enough to the given point with the given tolerance
  ///or null if one cannot be found
  @override
  Vertex getFirstVertexUnderPoint(Point p, num squareTolerance, bool ignoreLockedVertices) {
    for (IShape shape in _shapes) {
      Vertex v = shape.getFirstVertexUnderPoint(p, squareTolerance, ignoreLockedVertices);
      if (v != null) {
        return v;
      }
    }
    
    return null;
  }

  List<IShape> getAllShapesThatHaveVertex(Vertex vertex) {
    List<IShape> shapes = List();

    for (IShape shape in _shapes) {
      if (shape.hasVertex(vertex)) {
        shapes.add(shape);
      }
    }

    return shapes;
  }

  //if two vertices are connected then they become the same vertex
  //moving one means moving the other
  void connectVertices(Vertex a, Vertex b) {
    //there might be multiple shapes that contain both vertices
    //we keep all shapes the same that contain the first vertex
    //and update all that contain the second vertex
    List<IShape> shapes = getAllShapesThatHaveVertex(b);

    for (IShape shape in shapes) {
      shape.swapVertex(b, a);

      if (shape.isValid() == false) {
        _shapes.remove(shape);
      }
    }
  }

  @override
  bool hasVertex(Vertex vertex) {
    for (IShape shape in _shapes) {
      if (shape.hasVertex(vertex)) {
        return true;
      }
    }
  }

  @override
  bool isValid() => true;

  @override
  void swapVertex(Vertex oldVertex, Vertex newVertex) {
    for (IShape shape in _shapes) {
      if (shape.hasVertex(oldVertex)) {
        return shape.swapVertex(oldVertex, newVertex);
      }
    }
  }

  @override
  Iterable<Vertex> getVertices() {
    List<Vertex> vertices = List();
    for (IShape shape in _shapes) {
      vertices.addAll(shape.getVertices());
    }

    return vertices;
  }

  @override
  void renderToStageXL(Graphics graphics) {
    for(IShape shape in _shapes) {
      shape.renderToStageXL(graphics);
    }
  }
}
