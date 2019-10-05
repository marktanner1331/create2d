import './Vertex.dart';
import 'package:stagexl/stagexl.dart' show Point, Graphics;

abstract class IShape {
  ///returns true if the shape contains the given vertex
  bool hasVertex(Vertex vertex);

  ///removes the oldVertex from the shape and replaces it with the new vertex
  void swapVertex(Vertex oldVertex, Vertex newVertex);

  ///returns true if the shape is valid
  ///the shape may be invalid for a number of reasons
  ///it doesn't have enough unique vertices
  bool isValid();

  ///if a vertex exists under the given point (or close enough with the given tolerance) then it is returned
  ///otherwise null is returned instead
  ///the tolerance is given in its squared form
  ///this is so it works more efficiently with pythagorus
  Vertex getFirstVertexUnderPoint(Point p, num squareTolerance, bool ignoreLockedVertices);

  ///returns a collection containing all vertices used in the shape
  Iterable<Vertex> getVertices();

  void renderToStageXL(Graphics graphics);
}