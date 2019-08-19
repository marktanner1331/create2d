import 'package:stagexl/stagexl.dart';

import '../view/MainWindow.dart';
import './ITool.dart';
import '../stateful_graphics/Line.dart';
import '../stateful_graphics/Vertex.dart';
import '../stateful_graphics/Container.dart';

class LineTool extends ITool {
  Line _currentLine;
  Container _currentGraphics;

  @override
  void onMouseDown(num x, num y) {
    super.onMouseDown(x, y);

    _currentLine = Line(Vertex(x, y), Vertex(x, y));
    _currentGraphics = MainWindow.canvas.generateTemporaryLayer();

    _currentGraphics.addShape(_currentLine, false);
    MainWindow.canvas.invalidateVertices();
  }

  @override
  DisplayObject getIcon() {
    TextField tf = TextField("L");
    
    return tf
      ..autoSize = TextFieldAutoSize.NONE
      ..width = tf.textWidth
      ..height = tf.textHeight;
  }

  @override
  void onMouseUp(num x, num y) {
    super.onMouseUp(x, y);

    _currentLine = null;
    MainWindow.canvas.mergeInTemporaryLayer(_currentGraphics);
    _currentGraphics = null;
    MainWindow.canvas.invalidateVertices();
  }

  @override
  void onMouseMove(num x, num y) {
    assert(isActive == false);
    
    _currentLine.end.x = x;
    _currentLine.end.y = y;

    MainWindow.canvas.invalidateVertexPositions();
  }
}