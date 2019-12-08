import 'dart:html';

import 'package:stagexl/stagexl.dart' show Point;

import './ITool.dart';
import '../stateful_graphics/Text.dart';
import '../property_mixins/TextStyleMixin.dart';
import '../view/MainWindow.dart';

class TextTool extends ITool with TextStyleMixin {
  TextTool() : super(document.querySelector("#toolbox #textTool"));

  @override
  String get tooltipText => "Text";

  @override
  void contextPropertiesHaveChanged() {
    // TODO: implement contextPropertiesHaveChanged
  }

  @override
  Iterable<Point<num>> getSnappablePoints() {
    // TODO: implement getSnappablePoints
    return Iterable.empty();
  }

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }

  @override
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    super.onMouseDown(unsnappedMousePosition, snappedMousePosition);

    Text text = Text()
      ..fromTextStyleMixin(this)
      ..position = snappedMousePosition;

    MainWindow.canvas
      ..currentGraphics.addShape(text, true)
      ..invalidateVertices();
  }

  @override
  void onMouseMove(num x, num y) {}
}
