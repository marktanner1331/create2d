import 'dart:async';
import 'dart:html';
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart' as stageXL;

class Draggable {
  static const String POSITION_CHANGED = "POSITION_CHANGED";
  static const String FINISHED_DRAG = "FINISHED_DRAG";

  final stageXL.EventDispatcher _dispatcher = stageXL.EventDispatcher();

  stageXL.EventStream<stageXL.Event> get onPositionChanged =>
      _dispatcher.on(POSITION_CHANGED);
  stageXL.EventStream<stageXL.Event> get onFinishedDrag =>
      _dispatcher.on(FINISHED_DRAG);

  StreamSubscription<MouseEvent> _documentMoveSubscription;
  StreamSubscription<MouseEvent> _documentUpSubscription;

  HtmlElement _objectToDrag;
  Point _originalOffset;

  bool horizontal;
  bool vertical;

  num minX = null;
  num maxX = null;
  num minY = null;
  num maxY = null;

  Draggable(HtmlElement objectToDrag, HtmlElement objectToListenTo,
      {this.horizontal = true,
      this.vertical = true,
      this.minX = null,
      this.maxX = null,
      this.minY = null,
      this.maxY = null}) {
    _objectToDrag = objectToDrag;

    objectToListenTo.onMouseDown.listen(_onMouseDown);
  }

  void _onMouseDown(MouseEvent e) {
    if (_documentMoveSubscription == null) {
      Rectangle rect = _objectToDrag.getBoundingClientRect();
      
      Point mousePos = e.page;
      _originalOffset = Point(mousePos.x - rect.left, mousePos.y - rect.top);
      
      _documentMoveSubscription = document.onMouseMove.listen(_onMouseMove);
      _documentUpSubscription = document.onMouseUp.listen(_onMouseUp);
    }
  }

  void _onMouseMove(MouseEvent e) {
    Rectangle rect = _objectToDrag.parent.getBoundingClientRect();
    Point mousePos = e.page;
    
    if(horizontal) {
      num x = mousePos.x - _originalOffset.x - rect.left;
      
      if (minX != null) {
        x = math.max(x, minX);
      }

      if (maxX != null) {
        x = math.min(x, maxX);
      }

      _objectToDrag.style.left = "${x}px";
    }
    
    if(vertical) {
      num y = mousePos.y - _originalOffset.y;

      if (minY != null) {
        y = math.max(y, minY);
      }

      if (maxY != null) {
        y = math.min(y, maxY);
      }

      _objectToDrag.style.top = "${y}px";
    }

    _dispatcher.dispatchEvent(stageXL.Event(POSITION_CHANGED));
  }

  void _onMouseUp(_) {
    _documentUpSubscription.cancel();
    _documentUpSubscription = null;

    _documentMoveSubscription.cancel();
    _documentMoveSubscription = null;

    _originalOffset = null;

    _dispatcher.dispatchEvent(stageXL.Event(FINISHED_DRAG));
  }
}
