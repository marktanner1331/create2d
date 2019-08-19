import 'package:stagexl/stagexl.dart';

import './Canvas.dart';
import '../stateful_graphics/Vertex.dart';

class SelectionLayer extends Sprite {
  Canvas _canvas;
  List<Vertex> _selectedVertices;

  SelectionLayer(Canvas canvas) {
    _canvas = canvas;
    _selectedVertices = List();

    mouseEnabled = false;
  }

  ///removes all selected vertices and selects the vertices given
  void deselectAllAndSelectVertices(Iterable<Vertex> vertices) {
    _selectedVertices.clear();
    _selectedVertices.addAll(vertices);
    refresh();
  }

  void addVertexToSelection(Vertex v) {
    _selectedVertices.add(v);
    refresh();
  }

  void deselectAllVertices() {
    _selectedVertices.clear();
    refresh();
  }

  void deselectVertex(Vertex v) {
    _selectedVertices.remove(v);
    refresh();
  }

  void refresh() {
    graphics.clear();

    for (Vertex v in _selectedVertices) {
      graphics
        ..beginPath()
        ..circle(v.x * _canvas.drawingSpaceToCanvasSpace,
            v.y * _canvas.drawingSpaceToCanvasSpace, 2)
        ..fillColor(0xffaa0000)
        ..closePath();
    }
  }
}
