import 'package:stagexl/stagexl.dart';

import './Toolbox.dart';
import './Canvas.dart';
import '../stateful_graphics/Vertex.dart';

class CanvasMouseEventsController extends EventDispatcher {
  static const String MOUSE_OVER_VERTEX = "MOUSE_OVER_VERTEX";

  static const EventStreamProvider<Event> _mouseOverVertexEvent =
      const EventStreamProvider<Event>(MOUSE_OVER_VERTEX);

  //fires when the currentMouseOverVertex changes
  //including it being set to null
  EventStream<Event> get onMouseOverVertex =>
      _mouseOverVertexEvent.forTarget(this);

  bool _detectMouseOverVertex = false;
  bool get detectMouseOverVertex => _detectMouseOverVertex;
  void set detectMouseOverVertex(bool value) {
    _detectMouseOverVertex = value;
    if (value == false) {
      _detectMouseOverVertex = null;
    }
  }

  Vertex _currentMouseOverVertex;

  ///when set to true, this class will listen out for when the user mouse_over's or mouse_out's a vertex
  ///and will fire the onMouseOverVertex event
  Vertex get currentMouseOverVertex => _currentMouseOverVertex;

  Toolbox _toolbox;
  Canvas _canvas;

  CanvasMouseEventsController(Toolbox toolbox, Canvas canvas) {
    this._toolbox = toolbox;
    this._canvas = canvas;

    _canvas.onMouseDown.listen(_onMouseDown);
    _canvas.onMouseMove.listen(_onMouseMove);
    _canvas.onMouseUp.listen(_onMouseUp);
  }

  ///returns the current mouse point, with all the different snapping options applied to it
  Point _getSnappedMousePoint() {
    Point p = _canvas.mousePosition;

    if (_canvas.snapToGrid) {
      return _canvas.grid.getClosestPoint(p.x, p.y);
    }

    if (_canvas.snapToVertex) {
      Vertex v =
          _canvas.currentGraphics.getFirstVertexUnderPoint(Point(p.x, p.y), 100);
      if (v != null) {
        return v;
      }
    }

    return p;
  }

  void _onMouseDown(MouseEvent e) {
    Point p = _getSnappedMousePoint();
    _toolbox.currentTool.onMouseDown(p.x, p.y);
  }

  void _onMouseMove(MouseEvent e) {
    if (detectMouseOverVertex) {
      Vertex v = _canvas.currentGraphics
          .getFirstVertexUnderPoint(_canvas.mousePosition, 100);

      if (v != _currentMouseOverVertex) {
        _currentMouseOverVertex = v;
        dispatchEvent(Event(MOUSE_OVER_VERTEX));
      }
    }

    if (_toolbox.currentTool.isActive) {
      Point p = _getSnappedMousePoint();
      _toolbox.currentTool.onMouseMove(p.x, p.y);
    }
  }

  void _onMouseUp(MouseEvent e) {
    Point p = _getSnappedMousePoint();
    _toolbox.currentTool.onMouseUp(p.x, p.y);
  }
}
