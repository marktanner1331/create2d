import 'dart:collection';

import 'package:stagexl/stagexl.dart' show Sprite, Point;

import './Vertex.dart';
import './IShape.dart';

//the high level class that owns and manages the stateful graphics objects
class Container extends IShape {
  List<IShape> _shapes;
  Iterable<IShape> get shapes => _shapes;

  Container() {
    _shapes = List();
  }

  bool foreachVertex(Function(Vertex) callback) {
    for (IShape shape in _shapes) {
      if (shape.foreachVertex(callback) == false) {
        return false;
      }
    }

    return true;
  }

  bool foreachShape(bool Function(IShape) callback) {
    for (IShape shape in _shapes) {
      if(shape is Container) {
        if (shape.foreachShape(callback) == false) {
          return false;
        }
      } else {
        if(callback(shape) == false) {
            return false;
          }
        }
    }

    return true;
  }

  //removes all shapes that are invalid and not in the whitelist
  void removeInvalidShapes(List<IShape> whiteList) {
    Iterable<IShape> temp =
        _shapes.where((shape) => !whiteList.contains(shape));

    for (IShape shape in temp) {
      if (shape is Container) {
        shape.removeInvalidShapes(whiteList);
      }

      if (shape.isValid() == false) {
        _shapes.remove(shape);
      }
    }
  }

  void addShape(IShape shape, bool mergeVertices) {
    if (mergeVertices) {
      mergeInShape(shape);
    }

    if (shape is Container) {
      _shapes.addAll(shape._shapes);
    } else {
      _shapes.add(shape);
    }
  }

  @override
  void mergeInShape(IShape shape) {
    foreachShape((sub) {
      sub.mergeInShape(shape);
      return true;
    });
  }

  @override
  void mergeInVertices(Iterable<Vertex> vertices) {
    foreachShape((sub) {
      sub.mergeInVertices(vertices);
      return true;
    });
  }

  @override
  void mergeVerticesUnderVertex(Vertex v) {
    for (IShape shape in _shapes) {
      shape.mergeVerticesUnderVertex(v);
    }
  }

  ///returns the first vertex found which is close enough to the given point with the given tolerance
  ///or null if one cannot be found
  @override
  Vertex getFirstVertexUnderPoint(Point p,
      {num squareTolerance = 0, bool ignoreLockedVertices = false}) {
    for (IShape shape in _shapes) {
      Vertex v = shape.getFirstVertexUnderPoint(p,
          squareTolerance: squareTolerance,
          ignoreLockedVertices: ignoreLockedVertices);
      if (v != null) {
        return v;
      }
    }

    return null;
  }
  
  Iterable<Vertex> getVerticesUnderPoint(Point p) {
    List<Vertex> vertices = List();
    HashSet<int> identities = HashSet();

    for (IShape shape in _shapes) {
      for (Vertex v in shape.getVerticesUnderPoint(p)) {
        int identity = identityHashCode(v);
        if (identities.contains(identity) == false) {
          identities.add(identity);
          vertices.add(v);
        }
      }
    }

    return vertices;
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

    return false;
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
  void renderToStageXL(Sprite s) {
    for (IShape shape in _shapes) {
      shape.renderToStageXL(s);
    }
  }

  @override
  bool hasVertexAtPoint(Point<num> p) {
    for (IShape shape in _shapes) {
      if (shape.hasVertexAtPoint(p)) {
        return true;
      }
    }
  }

  @override
  Iterable<Vertex> getAllVerticesConnectedToVertex(Vertex v) {
    List<Vertex> vertices = List();
    for (IShape shape in _shapes) {
      vertices.addAll(shape.getAllVerticesConnectedToVertex(v));
    }

    return vertices;
  }

  @override
  bool hitTest(Point<num> p) {
    for (IShape shape in _shapes) {
      if (shape.hitTest(p)) {
        return true;
      }
    }

    return false;
  }

  ///returns the shape under the given point
  ///the point should be in canvas space
  ///the returned shape will not be a container
  IShape getFirstShapeUnderPoint(Point p) {
    for (IShape shape in _shapes) {
      if (shape is Container) {
        IShape subShape = shape.getFirstShapeUnderPoint(p);
        if (subShape != null) {
          return subShape;
        }
      } else {
        if (shape.hitTest(p)) {
          return shape;
        }
      }
    }

    return null;
  }

  @override
  void set selected(bool value) {
    super.selected = value;

    for (IShape shape in _shapes) {
      shape.selected = value;
    }
  }

  @override
  void deleteShapes(HashSet<IShape> shapesToDelete) {
    for (IShape shape in _shapes.toList()) {
      if(shapesToDelete.contains(shape)) {
        _shapes.remove(shape);
        shapesToDelete.remove(shape);
      }
    }

    for (IShape shape in _shapes) {
      if(shape is Container) {
        shape.deleteShapes(shapesToDelete);
      }
    }
  }

  @override
  void deleteVertices(Iterable<Vertex> selectedVertices) {
    for (IShape shape in _shapes.toList()) {
      shape.deleteVertices(selectedVertices);
    }

    _shapes.removeWhere((shape) => shape.isValid() == false);
  }

  @override
  Point<num> getClosestPointOnEdge(Point<num> p) {
    //really shouldn't be calling this on a container
    throw Error();
  }

  @override
  bool isPointOnEdge(Point<num> p, num tolerance) {
    //really shouldn't be calling this on a container
    throw Error();
  }
}
