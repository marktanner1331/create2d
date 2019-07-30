import 'package:stagexl/stagexl.dart';
import '../../StatefulGraphics.dart';

class StageXLRenderer {
  Sprite _canvas;
  Sprite get canvas => _canvas;

  StageXLRenderer() {
    _canvas = Sprite();
  }

  Sprite renderContainer(Container container) {
    for(IShape shape in container.shapes) {
      if(shape is Line) {
        _renderLine(shape);
      }
    }
  }

  void _renderLine(Line line) {
    _canvas.graphics.moveTo(line.start.x, line.start.y);
    _canvas.graphics.lineTo(line.end.x, line.end.y);
  }
}