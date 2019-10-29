import 'package:stagexl/stagexl.dart';
import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:async';

class DraggableController extends EventDispatcher {
  static const String POSITION_CHANGED = "POSITION_CHANGED";
  static const String FINISHED_DRAG = "FINISHED_DRAG";

  EventStream<Event> get onPositionChanged =>
      this.on(POSITION_CHANGED);
  EventStream<Event> get onFinishedDrag =>
      this.on(FINISHED_DRAG);

  Point _mouseOffset = Point(0, 0);

  EventStreamSubscription<MouseEvent> _objectDownSubscription;
  EventStreamSubscription<MouseEvent> _stageMoveSubscription;
  EventStreamSubscription<MouseEvent> _stageUpSubscription;
  StreamSubscription<html.MouseEvent> _documentUpSubscription;

  DisplayObject _objectToDrag;
  InteractiveObject _objectToListenTo;
  
  bool horizontal;
  bool vertical;

  num minX = null;
  num maxX = null;
  num minY = null;
  num maxY = null;

  ///objectToMove is the displayObject that will be dragged by the mouse
  ///objectToListenTo is the thing that raises the mouse events that should be captured
  DraggableController(
      DisplayObject objectToDrag, InteractiveObject objectToListenTo,
      {this.horizontal = true,
      this.vertical = true,
      this.minX = null,
      this.maxX = null,
      this.minY = null,
      this.maxY = null}) {
    this._objectToDrag = objectToDrag;
    this._objectToListenTo = objectToListenTo;

    _objectDownSubscription = objectToListenTo.onMouseDown.listen(_onMouseDown);
  }

  void _onMouseDown(_) {
    _mouseOffset = Point(_objectToDrag.parent.mouseX - _objectToDrag.x,
        _objectToDrag.parent.mouseY - _objectToDrag.y);

    //make sure we don't add them twice accidentally
    if(_stageMoveSubscription == null) {
      _stageMoveSubscription = _objectToDrag.stage.onMouseMove.listen(stageMove);
      _stageUpSubscription = _objectToDrag.stage.onMouseUp.listen(stageUp);
      _documentUpSubscription = html.document.onMouseUp.listen(stageUp);
    }
  }

  void stageMove(_) {
    if (horizontal) {
      num x = _objectToDrag.parent.mouseX - _mouseOffset.x;

      if (minX != null) {
        x = math.max(x, minX);
      }

      if (maxX != null) {
        x = math.min(x, maxX);
      }

      _objectToDrag.x = x;
    }

    if (vertical) {
      num y = _objectToDrag.parent.mouseY - _mouseOffset.y;

      if (minY != null) {
        y = math.max(y, minY);
      }

      if (maxY != null) {
        y = math.min(y, maxY);
      }

      _objectToDrag.y = y;
    }

    dispatchEvent(Event(POSITION_CHANGED));
  }

  void stageUp(_) {
    _stageUpSubscription.cancel();
    _stageUpSubscription = null;

    _stageMoveSubscription.cancel();
    _stageMoveSubscription = null;

    _documentUpSubscription.cancel();
    _documentUpSubscription = null;

    dispatchEvent(Event(FINISHED_DRAG));
  }

  void cancel() {
    _objectDownSubscription.cancel();

    if (_stageMoveSubscription != null) {
      _stageUpSubscription.cancel();
      _stageUpSubscription = null;

      _stageMoveSubscription.cancel();
      _stageMoveSubscription = null;

      dispatchEvent(Event(FINISHED_DRAG));
    }
  }
}
