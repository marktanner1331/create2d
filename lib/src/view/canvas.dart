import 'package:stagexl/stagexl.dart';

import './Grid.dart';
import './CanvasMouseEventsController.dart';
import './SelectionLayer.dart';

import '../property_mixins/GridPropertiesMixin.dart';
import '../property_mixins/SnappingPropertiesMixin.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

import '../stateful_graphics/Container.dart';
import '../stateful_graphics/Vertex.dart';

import '../helpers/SetSizeMixin.dart';

import '../Renderers/StageXLRenderer.dart';

class Canvas extends Sprite
    with
        SetSizeMixin,
        GridPropertiesMixin,
        SnappingPropertiesMixin,
        CanvasPropertiesMixin {
  //used by mixins to get a reference to the canvas
  Canvas get myCanvas => this;

  Container _graphicsContainer;
  Container get currentGraphics => _graphicsContainer;

  //temp layers are used for staging
  //i.e. for shapes that are being currently drawn
  //but are not yet complete
  Container _temporaryLayer;

  StageXLRenderer _renderer;

  Grid _grid;
  Grid get grid => _grid;

  CanvasMouseEventsController _canvasMouseEventsController;
  CanvasMouseEventsController get canvasMouseEventsController =>
      _canvasMouseEventsController;
  SelectionLayer _selectionLayer;
  SelectionLayer get selectionLayer => _selectionLayer;

  Canvas() {
    _graphicsContainer = Container();

    _grid = Grid(this);
    this.addChild(grid);

    _renderer = StageXLRenderer();
    this.addChild(_renderer.canvas);

    _selectionLayer = SelectionLayer(this);
    addChild(_selectionLayer);

    _canvasMouseEventsController = CanvasMouseEventsController(this);
    _canvasMouseEventsController.detectMouseOverVertex = true;
    _canvasMouseEventsController.onMouseOverVertex
        .listen((_) => _refreshSelectedVertices());

    refreshCanvasBackground();
  }

  ///represents both the xScale and yScale that maps from drawing space (using canvasWidth and canvasHeight)
  ///into canvas space (using width and height)
  num _drawingSpaceToCanvasSpace = 0;
  num get drawingSpaceToCanvasSpace => _drawingSpaceToCanvasSpace;

  num _canvasSpaceToDrawingSpace = 0;
  num get canvasSpaceToDrawingSpace => _canvasSpaceToDrawingSpace;

  void _refreshSelectedVertices() {
    _selectionLayer.deselectAllVertices("MOUSE_OVER_VERTICES");

    if (_canvasMouseEventsController.currentMouseOverVertex != null) {
      _selectionLayer.addVertexToSelection("MOUSE_OVER_VERTICES",
          _canvasMouseEventsController.currentMouseOverVertex);
    }
  }

  Container generateTemporaryLayer() {
    if (_temporaryLayer == null) {
      _temporaryLayer = Container();
    }

    return _temporaryLayer;
  }

  Iterable<Vertex> getAllTemporaryVertices() {
    if (_temporaryLayer == null) {
      return [];
    } else {
      return _temporaryLayer.getVertices();
    }
  }

  void refreshCanvasBackground() {
    //the width and height here are inherited from setSizeMixin
    //these are different from canvasWidth and canvasHeight
    //this is because we want the grid lines to be a constant width regardless of the scale (which is relative to canvasWidth)
    //instead, MainWindow.resetCanvasZoomAndPosition() looks at all the variables to figure out what the width and height should be and
    //calls setSize() on the canvas, which then calls this

    graphics.clear();
    graphics.rect(0, 0, width, height);
    graphics.fillColor(backgroundColor);
  }

  void mergeInTemporaryLayer(Container layer) {
    assert(_temporaryLayer == layer);

    _graphicsContainer.addShape(layer, true);
    _temporaryLayer = null;
  }

  //called when none of the vertices have changed but the graphics need to be redrawn anyway
  void invalidateGraphics() => _renderGraphics();

  ///called when the caller believes the positons of the vertices have changed and the rest
  ///of the program should know about it
  void invalidateVertexPositions() {
    _renderGraphics();
    _selectionLayer.refresh();
  }

  ///called when the caller believes the amount of vertices have changed and the rest
  ///of the program should know about it
  void invalidateVertices() {
    _renderGraphics();
    _refreshSelectedVertices();
    dispatchNumVerticesChangedEvent();
  }

  void _renderGraphics() {
    _renderer.reset();
    _renderer.renderContainer(_graphicsContainer);

    if (_temporaryLayer != null) {
      _renderer.renderContainer(_temporaryLayer);
    }
  }

  @override
  void refreshCached() {
    _drawingSpaceToCanvasSpace = width / canvasWidth;
    _canvasSpaceToDrawingSpace = canvasWidth / width;
  }

  @override
  void refresh() {
    _drawingSpaceToCanvasSpace = width / canvasWidth;
    _canvasSpaceToDrawingSpace = canvasWidth / width;

    _renderer.canvas
      ..scaleX = drawingSpaceToCanvasSpace
      ..scaleY = drawingSpaceToCanvasSpace;

    refreshCanvasBackground();

    grid.setSize(width * 2, height * 2);
    grid
      ..scaleX = 0.5
      ..scaleY = 0.5;
    
    grid.refreshCache();
  }
}
