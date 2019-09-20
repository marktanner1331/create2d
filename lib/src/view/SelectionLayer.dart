import 'package:stagexl/stagexl.dart';

import './Canvas.dart';
import '../stateful_graphics/Vertex.dart';

class SelectionLayer extends Sprite {
  Canvas _canvas;
  Map<String, List<Vertex>> _selectedVerticesGroups;

  SelectionLayer(Canvas canvas) {
    _canvas = canvas;
    _selectedVerticesGroups = Map();

    mouseEnabled = false;
  }

  ///removes all selected vertices for the given group and selects the vertex given
  void deselectAllAndSelectVertex(String groupName, Vertex vertex) {
    _selectedVerticesGroups[groupName] = [vertex].toList();
    refresh();
  } 

  ///removes all selected vertices for the given group and selects the vertices given
  void deselectAllAndSelectVertices(String groupName, Iterable<Vertex> vertices) {
    _selectedVerticesGroups[groupName] = vertices.toList();
    refresh();
  }

  void addVertexToSelection(String groupName, Vertex v) {
    if(_selectedVerticesGroups.containsKey(groupName) == false) {
      _selectedVerticesGroups[groupName] = List();
    }

    _selectedVerticesGroups[groupName].add(v);
    refresh();
  }

  void deselectAllVertices(String groupName) {
    _selectedVerticesGroups.remove(groupName);
    refresh();
  }

  void deselectVertex(String groupName, Vertex v) {
    if(_selectedVerticesGroups.containsKey(groupName) == false) {
      return;
    }

    _selectedVerticesGroups[groupName].remove(v);
    refresh();
  }

  void refresh() {
    graphics.clear();

    for(List<Vertex> _selectedVertices in _selectedVerticesGroups.values) {
      for (Vertex v in _selectedVertices) {
        graphics
          ..beginPath()
          ..circle(v.x * _canvas.drawingSpaceToCanvasSpace,
              v.y * _canvas.drawingSpaceToCanvasSpace, 3)
          ..fillColor(0xffaa0000)
          ..closePath();
      }
    }
  }
}
