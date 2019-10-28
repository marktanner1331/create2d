import 'dart:async';
import 'dart:html';

class Draggable {
  StreamSubscription<MouseEvent> _documentMoveSubscription;
  StreamSubscription<MouseEvent> _documentUpSubscription;

  HtmlElement _objectToDrag;
  Point _originalOffset;

  Draggable(HtmlElement objectToDrag, HtmlElement objectToListenTo) {
    _objectToDrag = objectToDrag;
    
    objectToListenTo.onMouseDown.listen(_onMouseDown);
  }

  void _onMouseDown(MouseEvent e) {
    if(_documentMoveSubscription == null) {
      Rectangle rect = _objectToDrag.getBoundingClientRect();
      Point mousePos = e.page;
      _originalOffset = Point(mousePos.x - rect.left, mousePos.y - rect.top);

      _documentMoveSubscription = document.onMouseMove.listen(_onMouseMove);
      _documentUpSubscription = document.onMouseUp.listen(_onMouseUp);
    }
  }

  void _onMouseMove(MouseEvent e) {
    Point mousePos = e.page;
    _objectToDrag.style.left = "${mousePos.x - _originalOffset.x}px";
    _objectToDrag.style.top = "${mousePos.y - _originalOffset.y}px";
  }

  void _onMouseUp(_) {
    _documentUpSubscription.cancel();
    _documentUpSubscription = null;

    _documentMoveSubscription.cancel();
    _documentMoveSubscription = null;

    _originalOffset = null;
  }
}