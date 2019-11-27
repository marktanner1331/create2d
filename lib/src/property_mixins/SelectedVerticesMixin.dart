import 'dart:collection';

import './IHavePropertyMixins.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:math';

import '../group_controllers/ContextController.dart';
import '../group_controllers/SelectedMultipleVerticesViewController.dart';
import '../group_controllers/SelectedSingleVertexViewController.dart';
import './ContextPropertyMixin.dart';
import '../stateful_graphics/Vertex.dart';

mixin SelectedVerticesMixin on IHavePropertyMixins {
  HashSet<Vertex> get selectedVertices;

  @override
  HashSet<ContextController> registerAndReturnViewControllers() {
    switch (selectedVertices.length) {
      case 0:
        return super.registerAndReturnViewControllers();
      case 1:
        SelectedSingleVertexViewController.instance.addModel(this);
        return super.getPropertyGroups()
          ..add(SelectedSingleVertexViewController.instance);
      default:
        SelectedMultipleVerticesViewController.instance.addModel(this);
        return super.getPropertyGroups()
          ..add(SelectedMultipleVerticesViewController.instance);
    }
  }

  Rectangle getBoundingBox() {
    Vertex first = selectedVertices.first;
    Rectangle box = Rectangle(first.x, first.y, 0, 0);

    for (Vertex v in selectedVertices.skip(1)) {
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

    if(diff.abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.x += diff;
    }
  }

  void set y(num value) {
    Rectangle box = getBoundingBox();
    num diff = value - box.top;

    if(diff.abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.y += diff;
    }
  }

  void set width(num value) {
    Rectangle box = getBoundingBox();
    num multiplier = value / box.width;

    if((1 - multiplier).abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.x = box.left + (v.x - box.left) * multiplier;
    }
  }

  void set height(num value) {
    Rectangle box = getBoundingBox();
    num multiplier = value / box.height;

    if((1 - multiplier).abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.y = box.top + (v.y - box.top) * multiplier;
    }
  }

  int get numVertices => selectedVertices.length;
}
