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
  // static const String VERTICES_MOVED = "VERTICES_MOVED";
  // static const String VERTICES_CHANGED = "VERTICES_CHANGED";

  // static const EventStreamProvider<Event> _verticesMovedEvent =
  //     const EventStreamProvider<Event>(VERTICES_MOVED);
  // static const EventStreamProvider<Event> _verticesChangedEvent =
  //     const EventStreamProvider<Event>(VERTICES_CHANGED);

  // EventStream<Event> get onVerticesMoved =>
  //     _verticesMovedEvent.forTarget(this);
  // EventStream<Event> get onVerticesChanged =>
  //     _verticesChangedEvent.forTarget(this);

  Container _graphicsContainer;
  Container get currentGraphics => _graphicsContainer;

  //temp layers are used for staging
  //i.e. for shapes that are being currently drawn
  //but are not yet complete
  Container _temporaryLayer;

  StageXLRenderer _renderer;

  Grid _grid;
  Grid get grid => _grid;

  CanvasMouseEventsController _canvasEvents;
  SelectionLayer _selectionLayer;

  Canvas() {
    _graphicsContainer = Container();

    _grid = Grid(this);
    this.addChild(grid);

    _renderer = StageXLRenderer();
    this.addChild(_renderer.canvas);

    _selectionLayer = SelectionLayer(this);
    addChild(_selectionLayer);

    _canvasEvents = CanvasMouseEventsController(this);
    _canvasEvents.detectMouseOverVertex = true;
    _canvasEvents.onMouseOverVertex.listen((_) => _refreshSelectedVertices());

    refreshCanvasBackground();
  }

  ///this represents the size that the program wants us to display the canvas at
  ///i am tracking these manually as i cant rely on the intrinsic width and height
  /// there might be shapes outside the bounds of the canvas which will throw off its size
  num _width = 0;
  num _height = 0;

  @override
  num get width => _width;

  @override
  num get height => _height;

  ///represents both the xScale and yScale that maps from drawing space (using canvasWidth and canvasHeight)
  ///into canvas space (using width and height)
  num _drawingSpaceToCanvasSpace = 0;
  num get drawingSpaceToCanvasSpace => _drawingSpaceToCanvasSpace;
  
  num _canvasSpaceToDrawingSpace = 0;
  num get canvasSpaceToDrawingSpace => _canvasSpaceToDrawingSpace;

  void _refreshSelectedVertices() {
    List<Vertex> vertices = List();

    if (_canvasEvents.currentMouseOverVertex != null) {
      vertices.add(_canvasEvents.currentMouseOverVertex);
    }
    
    _selectionLayer.deselectAllAndSelectVertices(vertices);
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
    graphics.clear();
    graphics.rect(0, 0, _width, _height);
    graphics.fillColor(backgroundColor);
  }

  void mergeInTemporaryLayer(Container layer) {
    assert(_temporaryLayer == layer);

    _graphicsContainer.addShape(layer, true);
    _temporaryLayer = null;
  }

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
  }

  void _renderGraphics() {
    _renderer.reset();
    _renderer.renderContainer(_graphicsContainer);

    if (_temporaryLayer != null) {
      _renderer.renderContainer(_temporaryLayer);
    }
  }

  @override
  void setSize(num width, num height) {
    this._width = width;
    this._height = height;

    _drawingSpaceToCanvasSpace = width / canvasWidth;
    _canvasSpaceToDrawingSpace = canvasWidth / width;
    
    _renderer.canvas
      ..scaleX = drawingSpaceToCanvasSpace
      ..scaleY = drawingSpaceToCanvasSpace;

    refreshCanvasBackground();

    grid.refresh();
  }
}
