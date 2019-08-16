import 'package:stagexl/stagexl.dart';

class DraggableController {
  Point _mouseOffset = Point(0, 0);

  EventStreamSubscription<MouseEvent> _objectDownSubscription;
  EventStreamSubscription<MouseEvent> _stageMoveSubscription;
  EventStreamSubscription<MouseEvent> _stageUpSubscription;

  DisplayObject _objectToDrag;
  InteractiveObject _objectToListenTo;

  ///objectToMove is the displayObject that will be dragged by the mouse
  ///objectToListenTo is the thing that raises the mouse events that should be captured
  DraggableController(DisplayObject objectToDrag, InteractiveObject objectToListenTo) {
    this._objectToDrag = objectToDrag;
    this._objectToListenTo = objectToListenTo;

   _objectDownSubscription =  objectToListenTo.onMouseDown.listen(_onMouseDown);
  }

  
  void _onMouseDown(_) {
    _mouseOffset = Point(_objectToDrag.parent.mouseX - _objectToDrag.x, _objectToDrag.parent.mouseY - _objectToDrag.y);
    _stageMoveSubscription = _objectToDrag.stage.onMouseMove.listen(stageMove);
    _stageUpSubscription = _objectToDrag.stage.onMouseUp.listen(stageUp);
  }

  void stageMove(_) {
    _objectToDrag.x = _objectToDrag.parent.mouseX - _mouseOffset.x;
    _objectToDrag.y =_objectToDrag. parent.mouseY - _mouseOffset.y;
  }

  void stageUp(_) {
    _stageUpSubscription.cancel();
    _stageUpSubscription = null;

    _stageMoveSubscription.cancel();
    _stageMoveSubscription = null;
  }

  void cancel() {
    _objectDownSubscription.cancel();

    if(_stageMoveSubscription != null) {
      _stageUpSubscription.cancel();
      _stageUpSubscription = null;

      _stageMoveSubscription.cancel();
      _stageMoveSubscription = null;
    }
  }
}