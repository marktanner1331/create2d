import 'package:stagexl/stagexl.dart';
import '../stateful_graphics/StatefulGraphics.dart';

class StageXLRenderer {
  Sprite _canvas;
  Sprite get canvas => _canvas;

  StageXLRenderer() {
    _canvas = Sprite();
  }

  ///resets the renderer back to its initial state
  void reset() {
    _canvas.graphics.clear();
  }

  ///renders the given container and all of its children onto the canvas
  void renderContainer(Container container) {
    for(IShape shape in container.shapes) {
      if(shape is Line) {
        _renderLine(shape);
      }
    }
  }

  void _renderLine(Line line) {
    _canvas.graphics.moveTo(line.start.x, line.start.y);
    _canvas.graphics.lineTo(line.end.x, line.end.y);
    _canvas.graphics.strokeColor(0xff000000);
  }
}