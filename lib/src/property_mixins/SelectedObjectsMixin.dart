import 'dart:collection';

import '../stateful_graphics/IShape.dart';

import './IHavePropertyMixins.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:math';

import '../group_controllers/ContextController.dart';
import '../group_controllers/SelectedViewController.dart';
import '../stateful_graphics/Vertex.dart';

mixin SelectedObjectsMixin on IHavePropertyMixins {
  HashSet<Vertex> get selectedVertices;
  List<IShape> get selectedShapes;

  @override
  HashSet<ContextController> registerAndReturnViewControllers() {
    SelectedViewController.instance.properties = this;
    return super.registerAndReturnViewControllers()
      ..add(SelectedViewController.instance);
  }

  void deleteSelectedObjects();

  Rectangle getBoundingBox() {
    if(selectedVertices.length == 0) {
      return Rectangle(0, 0, 0, 0);
    }
    
    Vertex first = selectedVertices.first;

    if(selectedVertices.length  == 1) {
      return Rectangle(first.x, first.y, 0, 0);
    }

    num left = first.x;
    num right = first.x;
    num top = first.y;
    num bottom = first.y;

    for (Vertex v in selectedVertices.skip(1)) {
      left = min(left, v.x);
      top = min(top, v.y);
      right = max(right, v.x);
      bottom = max(bottom, v.y);
    }

    return Rectangle(left, top, right - left, bottom - top);
  }

  void set x(num value) {
    Rectangle box = getBoundingBox();
    num diff = value - box.left;

    if (diff.abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.x += diff;
    }
  }

  void set y(num value) {
    Rectangle box = getBoundingBox();
    num diff = value - box.top;

    if (diff.abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.y += diff;
    }
  }

  void set width(num value) {
    Rectangle box = getBoundingBox();
    num multiplier = value / box.width;

    if ((1 - multiplier).abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.x = box.left + (v.x - box.left) * multiplier;
    }
  }

  void set height(num value) {
    Rectangle box = getBoundingBox();
    num multiplier = value / box.height;

    if ((1 - multiplier).abs() < 0.01) {
      return;
    }

    for (Vertex v in selectedVertices) {
      v.y = box.top + (v.y - box.top) * multiplier;
    }
  }

  int get numVertices => selectedVertices.length;
  int get numShapes => selectedShapes.length;
}
