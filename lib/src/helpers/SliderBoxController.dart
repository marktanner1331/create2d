import 'dart:html';
import 'dart:async';
import 'package:stagexl/stagexl.dart' as stageXL;
import 'dart:math';

class SliderBoxController {
  DivElement _dot;
  HtmlElement _sliderBox;

  num _dragOffset;
  num _xOffset;
  num _max;

  final stageXL.EventDispatcher _dispatcher = stageXL.EventDispatcher();

  stageXL.EventStream<stageXL.Event> get onStartedDrag =>
      _dispatcher.on("STARTED_DRAG");
  stageXL.EventStream<stageXL.Event> get onPositionChanged =>
      _dispatcher.on("POSITION_CHANGED");
  stageXL.EventStream<stageXL.Event> get onFinishedDrag =>
      _dispatcher.on("FINISHED_DRAG");

  StreamSubscription<MouseEvent> _documentMoveSubscription;
  StreamSubscription<MouseEvent> _documentUpSubscription;

  bool get isDragging => _documentMoveSubscription != null;

  num get decimalX => _decimalX;
  void set decimalX(num value) {
    _decimalX = value;

    num x = _decimalX * _max;
    _dot.style.left = "${x}px";
  }

  num _decimalX = null;

  SliderBoxController(HtmlElement sliderBox) {
    this._sliderBox = sliderBox;
    _dot = _sliderBox.querySelector(".dot");

    _sliderBox.onMouseDown.listen(_sliderBoxMouseDown);

    Rectangle rect = _sliderBox.getBoundingClientRect();
    _xOffset = rect.left;
    
    _dot.style.position = "absolute";
    _dot.onMouseDown.listen(_onMouseDown);

    _max = _sliderBox.getBoundingClientRect().width - _dot.getBoundingClientRect().width;
  }

  void _sliderBoxMouseDown(MouseEvent e) {
    num x = e.page.x - _xOffset;
    _decimalX = x / _max;
    _dispatcher.dispatchEvent(stageXL.Event("POSITION_CHANGED"));
  }

  void _onMouseDown(MouseEvent e) {
    e.stopImmediatePropagation();

    if (_documentMoveSubscription == null) {
      Rectangle rect = _dot.getBoundingClientRect();
      _dragOffset = e.client.x - rect.left;

      _dispatcher.dispatchEvent(stageXL.Event("STARTED_DRAG"));

      _documentMoveSubscription = document.onMouseMove.listen(_onMouseMove);
      _documentUpSubscription = document.onMouseUp.listen(_onMouseUp);
    }
  }

  void _onMouseMove(MouseEvent e) {
    Point mousePos = e.page;

    num x = mousePos.x - _dragOffset - _xOffset;
    x = min(max(x, 0), _max);

    _dot.style.left = "${x}px";
    _decimalX = x / _max;

    _dispatcher.dispatchEvent(stageXL.Event("POSITION_CHANGED"));
  }

  void _onMouseUp(_) {
    _documentUpSubscription.cancel();
    _documentUpSubscription = null;

    _documentMoveSubscription.cancel();
    _documentMoveSubscription = null;

    _dragOffset = null;

    _dispatcher.dispatchEvent(stageXL.Event("FINISHED_DRAG"));
  }
}
