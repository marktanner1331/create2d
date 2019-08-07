import 'package:design2D/src/view/Grid.dart';
import 'package:stagexl/stagexl.dart';

import './Toolbox.dart';

import '../property_mixins/InitializeMixins.dart';
import '../property_mixins/GridPropertiesMixin.dart';
import '../property_mixins/SnappingPropertiesMixin.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

import '../stateful_graphics/Container.dart';
import '../Renderers/StageXLRenderer.dart';

class Canvas extends Sprite
    with
        InitializeMixins,
        GridPropertiesMixin,
        SnappingPropertiesMixin,
        CanvasPropertiesMixin {
  
  Container _graphicsContainer;
  Container get currentGraphics => _graphicsContainer;

  StageXLRenderer _renderer;

  Grid _grid;
  Grid get grid => _grid;

  Canvas() {
    initializeMixins();

    _graphicsContainer = Container();
    
    _grid = Grid(this);
    this.addChild(grid);

    _renderer = StageXLRenderer();
    this.addChild(_renderer.canvas);

    this.onMouseDown.listen(_onMouseDown);
    this.onMouseMove.listen(_onMouseMove);
    this.onMouseUp.listen(_onMouseUp);

    refreshCanvasBackground();
  }

  void dispose() {
    grid.dispose();
  }

  void refreshCanvasBackground() {
    graphics.clear();
    graphics.rect(0, 0, canvasWidth, canvasHeight);
    graphics.fillColor(backgroundColor);

    grid.refresh();
  }

  void invalidateCurrentGraphics() {
    _renderer.reset();
    _renderer.renderContainer(_graphicsContainer);
  }

  void _onMouseMove(MouseEvent e) {
    if (Toolbox.currentTool.isActive) {
      if (snapToGrid) {
        Point p = grid.getClosestPoint(e.localX, e.localY);
        Toolbox.currentTool.onMouseMove(p.x, p.y);
      } else {
        Toolbox.currentTool.onMouseMove(e.localX, e.localY);
      }
    }
  }

  void _onMouseDown(MouseEvent e) {
    if (snapToGrid) {
      Point p = grid.getClosestPoint(e.localX, e.localY);
      Toolbox.currentTool.onMouseDown(p.x, p.y);
    } else {
      Toolbox.currentTool.onMouseDown(e.localX, e.localY);
    }
  }

  void _onMouseUp(MouseEvent e) {
    if (snapToGrid) {
      Point p = grid.getClosestPoint(e.localX, e.localY);
      Toolbox.currentTool.onMouseUp(p.x, p.y);
    } else {
      Toolbox.currentTool.onMouseUp(e.localX, e.localY);
    }
  }
}
