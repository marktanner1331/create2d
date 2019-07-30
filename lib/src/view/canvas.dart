import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';

import './MainWindow.dart';
import '../stateful_graphics/Container.dart';
import '../Renderers/StageXLRenderer.dart';

class Canvas extends Sprite with RefreshMixin, SetSizeAndPositionMixin {
  MainWindow _mainWindow;

  Container _graphicsContainer;
  Container get currentGraphics => _graphicsContainer;

  int _backgroundColor = 0xffffffff;

  StageXLRenderer _renderer;

  Canvas(MainWindow mainWindow) {
    this._mainWindow = mainWindow;
    this._graphicsContainer = Container();
    
    this._renderer = StageXLRenderer();
    this.addChild(_renderer.canvas);

    this.onMouseDown.listen(_onMouseDown);
    this.onMouseMove.listen(_onMouseMove);
    this.onMouseUp.listen(_onMouseUp);
  }

  void invalidateCurrentGraphics() {
    _renderer.reset();
    _renderer.renderContainer(this._graphicsContainer);
  }

  void _onMouseMove(MouseEvent e) {
    if (_mainWindow.currentTool.isActive) {
      _mainWindow.currentTool.onMouseMove(e.localX, e.localY);
    }
  }

  void _onMouseDown(MouseEvent e) {
    _mainWindow.currentTool.onMouseDown(e.localX, e.localY);
  }

  void _onMouseUp(MouseEvent e) {
    _mainWindow.currentTool.onMouseUp(e.localX, e.localY);
  }

  @override
  void refresh() {
    graphics.clear();
    graphics.rect(0, 0, width, height);
    graphics.fillColor(_backgroundColor);

    invalidateCurrentGraphics();
  }
}
