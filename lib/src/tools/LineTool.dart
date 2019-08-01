import 'package:design2D/src/view/Canvas.dart';

import '../view/MainWindow.dart';
import './ITool.dart';
import '../stateful_graphics/Line.dart';
import '../stateful_graphics/Vertex.dart';

class LineTool extends ITool {
  Line _currentLine;

  @override
  void onMouseDown(num x, num y) {
    super.onMouseDown(x, y);

    _currentLine = Line(Vertex(x, y), Vertex(x, y));
    MainWindow.currentCanvas.currentGraphics.addShape(_currentLine);
  }

  @override
  void onMouseUp(num x, num y) {
    super.onMouseUp(x, y);

    _currentLine = null;
  }

  @override
  void onMouseMove(num x, num y) {
    assert(isActive == false);
    
    _currentLine.end.x = x;
    _currentLine.end.y = y;
    MainWindow.currentCanvas.invalidateCurrentGraphics();
  }
}