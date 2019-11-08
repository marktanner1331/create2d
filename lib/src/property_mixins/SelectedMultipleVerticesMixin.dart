import 'package:stagexl/stagexl.dart';
import 'dart:math';

import '../group_controllers/ContextController.dart';
import '../group_controllers/SelectedMultipleVerticesViewController.dart';
import './ContextPropertyMixin.dart';
import '../stateful_graphics/Vertex.dart';

mixin SelectedMultipleVerticesMixin on ContextPropertyMixin {
  List<Vertex> get selectedVertices;

  @override
  List<ContextController> getPropertyGroups() {
    if(selectedVertices.length > 1) {
      return super.getPropertyGroups()
        ..add(SelectedMultipleVerticesViewController.instance..properties = this);
    } else {
      return super.getPropertyGroups();
    }
  }

  Rectangle getBoundingBox() {
    Vertex first = selectedVertices.first;
    Rectangle box = Rectangle(first.x, first.y, 0, 0);
    
    for(Vertex v in selectedVertices.skip(1)) {
      box.left = min(box.left, v.x);
      box.top = min(box.top, v.y);
      box.right = max(box.right, v.x);
      box.bottom = max(box.bottom, v.y);
    }

    return box;
  }

  void set x(num value) {
    Rectangle box = getBoundingBox();
    num diff = value - box.left;

    for(Vertex v in selectedVertices) {
      v.x += diff;
    }

    invalidateProperties();
  }

  void set y(num value) {
    Rectangle box = getBoundingBox();
    num diff = value - box.top;

    for(Vertex v in selectedVertices) {
      v.y += diff;
    }
    
    invalidateProperties();
  }

  void set width(num value) {
    Rectangle box = getBoundingBox();
    num multiplier = value / box.width;
    
    for(Vertex v in selectedVertices) {
      v.x = box.left + (v.x - box.left) * multiplier;
    }

    invalidateProperties();
  }

  void set height(num value) {
    Rectangle box = getBoundingBox();
    num multiplier = value / box.height;

    for(Vertex v in selectedVertices) {
      v.y = box.top + (v.y - box.top) * multiplier;
    }
    
    invalidateProperties();
  }

  int get numVertices => selectedVertices.length;
}