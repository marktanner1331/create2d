import 'package:stagexl/stagexl.dart';

import './Toolbox.dart';
import '../stateful_graphics/Container.dart';
import '../Renderers/StageXLRenderer.dart';

class Canvas extends Sprite {
  Container _graphicsContainer;
  Container get currentGraphics => _graphicsContainer;

  int _backgroundColor = 0xffffffff;

  StageXLRenderer _renderer;

  num _canvasWidth = 1000;
  num get canvasWidth => _canvasWidth;

  num _canvasHeight = 1000;
  num get canvasHeight => _canvasHeight;

  Canvas() {
    graphics.clear();
    graphics.rect(0, 0, _canvasWidth, _canvasHeight);
    graphics.fillColor(_backgroundColor);

    _graphicsContainer = Container();
    
    _renderer = StageXLRenderer();
    this.addChild(_renderer.canvas);

    this.onMouseDown.listen(_onMouseDown);
    this.onMouseMove.listen(_onMouseMove);
    this.onMouseUp.listen(_onMouseUp);
  }
  
  void setCanvasSize(num canvasWidth, num canvasHeight) {
    _canvasWidth = canvasWidth;
    _canvasHeight = canvasHeight;
    _refreshCanvasBackground();
  }

  void _refreshCanvasBackground() {
    graphics.clear();
    graphics.rect(0, 0, _canvasWidth, _canvasHeight);
    graphics.fillColor(_backgroundColor);
  }

  void invalidateCurrentGraphics() {
    _renderer.reset();
    _renderer.renderContainer(_graphicsContainer);
  }

  void _onMouseMove(MouseEvent e) {
    if (Toolbox.currentTool.isActive) {
      Toolbox.currentTool.onMouseMove(e.localX, e.localY);
    }
  }

  void _onMouseDown(MouseEvent e) {
    Toolbox.currentTool.onMouseDown(e.localX, e.localY);
  }

  void _onMouseUp(MouseEvent e) {
    Toolbox.currentTool.onMouseUp(e.localX, e.localY);
  }
}
