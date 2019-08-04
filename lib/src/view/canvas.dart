import 'package:stagexl/stagexl.dart';

import './Toolbox.dart';

import '../property_mixins/InitializeMixins.dart';
import '../property_mixins/GridMixin.dart';
import '../property_mixins/GridPropertiesMixin.dart';

import '../stateful_graphics/Container.dart';
import '../Renderers/StageXLRenderer.dart';

class Canvas extends Sprite with InitializeMixins, GridMixin, GridPropertiesMixin {
  Container _graphicsContainer;
  Container get currentGraphics => _graphicsContainer;

  int _backgroundColor = 0xffffffff;

  StageXLRenderer _renderer;

  num _canvasWidth = 1000;
  num get canvasWidth => _canvasWidth;

  num _canvasHeight = 1000;
  num get canvasHeight => _canvasHeight;

  Canvas() {
    initializeMixins();

    _graphicsContainer = Container();

    this.addChild(grid);
    
    _renderer = StageXLRenderer();
    this.addChild(_renderer.canvas);

    this.onMouseDown.listen(_onMouseDown);
    this.onMouseMove.listen(_onMouseMove);
    this.onMouseUp.listen(_onMouseUp);

    _refreshCanvasBackground();
  }

  void dispose() {
    grid.dispose();
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

    grid.refresh();
  }

  void invalidateCurrentGraphics() {
    _renderer.reset();
    _renderer.renderContainer(_graphicsContainer);
  }

  void _onMouseMove(MouseEvent e) {
    if (Toolbox.currentTool.isActive) {
      Point p = grid.getClosestPoint(e.localX, e.localY);
      Toolbox.currentTool.onMouseMove(p.x, p.y);
    }
  }

  void _onMouseDown(MouseEvent e) {
    Point p = grid.getClosestPoint(e.localX, e.localY);
    Toolbox.currentTool.onMouseDown(p.x, p.y);
  }

  void _onMouseUp(MouseEvent e) {
    Point p = grid.getClosestPoint(e.localX, e.localY);
    Toolbox.currentTool.onMouseUp(p.x, p.y);
  }
}
