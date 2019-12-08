import 'dart:collection';
import 'package:stagexl/stagexl.dart';

import '../stateful_graphics/IShape.dart';
import './Canvas.dart';
import '../stateful_graphics/Vertex.dart';

class SelectionLayer extends Sprite {
  Canvas _canvas;
  Map<String, List<Vertex>> _selectedVerticesGroups;

  List<Vertex> _selectedBlacklist;

  //any vertices that appear here will never be selected
  List<Vertex> get selectedBlacklist => _selectedBlacklist;

  List<IShape> _selectedShapes;

  SelectionLayer(Canvas canvas) {
    _canvas = canvas;
    _selectedVerticesGroups = Map();
    _selectedBlacklist = List();
    _selectedShapes = List();

    mouseEnabled = false;
  }

  void deselectAllAndSelectShapes(List<IShape> shapes) {
    for(IShape shape in _selectedShapes) {
      shape.selected = false;
    }

    _selectedShapes.clear();
    _selectedShapes.addAll(shapes);

    for(IShape shape in _selectedShapes) {
      shape.selected = true;
    }
  }

  void deselectAllShapes() {
    for(IShape shape in _selectedShapes) {
      shape.selected = false;
    }

    _selectedShapes.clear();
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

    for(MapEntry<String, List<Vertex>> group in _selectedVerticesGroups.entries) {
      for (Vertex v in group.value) {
        if(selectedBlacklist.contains(v)) {
          continue;
        }

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
