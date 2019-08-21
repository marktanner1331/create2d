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
    container.renderToStageXL(_canvas.graphics);
  }
}