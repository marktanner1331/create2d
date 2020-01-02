import 'dart:html' as html;

import 'package:stagexl/stagexl.dart';

import './ITool.dart';
import '../property_mixins/LinePropertiesMixin.dart';
import '../stateful_graphics/Container.dart';
import '../stateful_graphics/Line.dart';
import '../stateful_graphics/Vertex.dart';
import '../view/MainWindow.dart';

class LineTool extends ITool with LinePropertiesMixin {
  Line _currentLine;
  Container _currentGraphics;

  LineTool() : super(html.document.querySelector("#lineTool"));
  
  @override
  String get tooltipText => "Line Tool";

  @override
  void contextPropertiesHaveChanged() {
  }

  @override
  Iterable<Point<num>> getSnappablePoints() {
    return [_currentLine.start];
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
    
    _currentLine = Line(Vertex.fromPoint(snappedMousePosition), Vertex.fromPoint(snappedMousePosition));
    _currentLine.fromLinePropertiesMixin(this);

    _currentGraphics = MainWindow.canvas.generateTemporaryLayer();
    _currentGraphics.addShape(_currentLine, false);

    MainWindow.canvas.invalidateVertices();
  }

  @override
  void onMouseMove(num x, num y) {
    assert(isActive == false);
    
    _currentLine.end.x = x;
    _currentLine.end.y = y;

    MainWindow.canvas.invalidateVertexPositions();
  }

  @override
  void onMouseUp(num x, num y) {
    super.onMouseUp(x, y);

    _currentLine = null;
    MainWindow.canvas.mergeInTemporaryLayer(_currentGraphics);
    _currentGraphics = null;
    MainWindow.canvas.invalidateVertices();
  }
}