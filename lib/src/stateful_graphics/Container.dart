import './Line.dart';
import './Vertex.dart';
import './IShape.dart';

//the high level class that owns and manages the stateful graphics objects
class Container {
  List<IShape> _shapes;
  Iterable<IShape> get shapes => _shapes;

  Container() {
    _shapes = List();
  }

  void addShape(IShape shape) {
    _shapes.add(shape);
  }

  ///returns the first vertex found which is close enough to the given point with the given tolerance
  ///or null if one cannot be found
  Vertex getFirstVertexUnderPoint(num x, num y, num tolerance) {
    num squareTolerance = tolerance * tolerance;

    for(IShape shape in _shapes) {
      Vertex v = shape.getFirstVertexUnderPoint(x, y, squareTolerance);
      if(v != null) {
        return v;
      }
    }

    return null;
  }

  List<IShape> getAllShapesThatHaveVertex(Vertex vertex) {
    List<IShape> shapes = List();
    
    for(IShape shape in _shapes) {
      if(shape.hasVertex(vertex)) {
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

    for(IShape shape in shapes) {
      shape.swapVertex(b, a);

      if(shape.isValid() == false) {
        _shapes.remove(shape);
      }
    }
  }
}