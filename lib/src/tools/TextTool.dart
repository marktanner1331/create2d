import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL show Point;

import './SelectTool.dart';
import './ITool.dart';
import '../stateful_graphics/Text.dart';
import '../property_mixins/BoundingBoxMixin.dart';
import '../property_mixins/TextStyleMixin.dart';
import '../property_mixins/TextContentMixin.dart';
import '../view/MainWindow.dart';

class TextTool extends ITool with TextStyleMixin, TextContentMixin, BoundingBoxMixin {
  TextTool() : super(document.querySelector("#toolbox #textTool"));

  @override
  String get tooltipText => "Text";

  @override
  void contextPropertiesHaveChanged() {
    // TODO: implement contextPropertiesHaveChanged
  }

  @override
  Iterable<stageXL.Point> getSnappablePoints() {
    return Iterable.empty();
  }

  @override
  void onEnter() {
  }

  @override
  void onExit() {
  }

  @override
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    super.onMouseDown(unsnappedMousePosition, snappedMousePosition);

    Text text = Text()
      ..fromTextStyleMixin(this)
      ..fromTextContentMixin(this)
      ..position = snappedMousePosition;

    MainWindow.canvas
      ..currentGraphics.addShape(text, true)
      ..invalidateVertices();

    //if the text is empty then its going to be tricky for the user
    //to select the text and edit it
    //we select it for them to give them a chance to add text to it
    if(content == "") {
      MainWindow.toolbox.switchToTool<SelectTool>();
      MainWindow.toolbox.selectTool.selectShape(text);
    }
  }

  @override
  void onMouseMove(num x, num y) {}
}
