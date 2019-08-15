import 'dart:collection';

import 'package:stagexl/stagexl.dart';

import '../stateful_graphics/Vertex.dart';

typedef Matrix GetMatrix();

class SelectionLayer extends Sprite {
  GetMatrix _vectorToUserSpace;
  List<Vertex> _selectedVertices;

  SelectionLayer(GetMatrix vectorToUserSpace) {
    _vectorToUserSpace = vectorToUserSpace;
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
      Point p = _vectorToUserSpace().transformPoint(v);

      graphics
        ..beginPath()
        ..circle(p.x, p.y, 2)
        ..fillColor(0xffaa0000)
        ..closePath();
    }
  }
}
