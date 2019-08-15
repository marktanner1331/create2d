import 'package:stagexl/stagexl.dart';

import './Grid.dart';

import '../property_mixins/GridPropertiesMixin.dart';
import '../property_mixins/SnappingPropertiesMixin.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

import '../stateful_graphics/Container.dart';
import '../stateful_graphics/Vertex.dart';

import '../Renderers/StageXLRenderer.dart';

class Canvas extends Sprite
    with
        GridPropertiesMixin,
        SnappingPropertiesMixin,
        CanvasPropertiesMixin {
  static const String VERTICES_MOVED = "VERTICES_MOVED";
  static const String VERTICES_CHANGED = "VERTICES_CHANGED";

  static const EventStreamProvider<Event> _verticesMovedEvent =
      const EventStreamProvider<Event>(VERTICES_MOVED);
  static const EventStreamProvider<Event> _verticesChangedEvent =
      const EventStreamProvider<Event>(VERTICES_CHANGED);
    
  EventStream<Event> get onVerticesMoved =>
      _verticesMovedEvent.forTarget(this);
  EventStream<Event> get onVerticesChanged =>
      _verticesChangedEvent.forTarget(this);

  Container _graphicsContainer;
  Container get currentGraphics => _graphicsContainer;

  //temp layers are used for staging
  //i.e. for shapes that are being currently drawn
  //but are not yet complete
  Container _temporaryLayer;

  StageXLRenderer _renderer;

  Grid _grid;
  Grid get grid => _grid;

  Canvas() {
    _graphicsContainer = Container();
    
    _grid = Grid(this);
    this.addChild(grid);

    _renderer = StageXLRenderer();
    this.addChild(_renderer.canvas);
    
    refreshCanvasBackground();
  }

  Container generateTemporaryLayer() {
    if(_temporaryLayer == null) {
      _temporaryLayer = Container();
    }

    return _temporaryLayer;
  }

  void dispose() {
    grid.dispose();
  }

  Iterable<Vertex> getAllTemporaryVertices() {
    if(_temporaryLayer == null) {
      return [];
    } else {
      return _temporaryLayer.getVertices();
    }
  }

  void refreshCanvasBackground() {
    graphics.clear();
    graphics.rect(0, 0, canvasWidth, canvasHeight);
    graphics.fillColor(backgroundColor);

    grid.refresh();
  }

  void mergeInTemporaryLayer(Container layer) {
    assert(_temporaryLayer == layer);

    _graphicsContainer.addShape(layer, true);
    _temporaryLayer = null;
  }

  ///called when the caller believes the positons of the vertices have changed and the rest
  ///of the program should know about it
  void invalidateVertexPositions() {
    dispatchEvent(Event(VERTICES_MOVED));
    _renderGraphics();
  }

  ///called when the caller believes the amount of vertices have changed and the rest
  ///of the program should know about it
  void invalidateVertices() {
    dispatchEvent(Event(VERTICES_CHANGED));
    _renderGraphics();
  }

  void _renderGraphics() {
    _renderer.reset();
    _renderer.renderContainer(_graphicsContainer);

    if(_temporaryLayer != null) {
      _renderer.renderContainer(_temporaryLayer);
    }
  }
}
