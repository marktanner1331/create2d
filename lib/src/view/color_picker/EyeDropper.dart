import 'package:stagexl/stagexl.dart';
import './ColorPicker.dart';
import './ColorHelper.dart';

class EyeDropper extends EventDispatcher {
  static const String FINISHED = "FINISHED";

  static const EventStreamProvider<Event> _finishedEvent =
      const EventStreamProvider<Event>(FINISHED);
  
  EventStream<Event> get onFinished =>
      _finishedEvent.forTarget(this);

  Stage _stage;
  ColorPicker _colorPicker;

  BitmapData _bitmapData;

  EventStreamSubscription<MouseEvent> _stageClickSubscription;
  EventStreamSubscription<MouseEvent> _stageMoveSubscription;
   EventStreamSubscription<Event> _stageResizeSubscription;

  Sprite _blocker;

  EyeDropper(Stage stage, ColorPicker colorPicker) {
    this._stage = stage;
    this._colorPicker = colorPicker;
  }

  void start() {
    _bitmapData = BitmapData(_stage.stageWidth, _stage.stageHeight);
    _bitmapData.draw(_stage);

    _blocker = Sprite();
    _blocker.mouseCursor = MouseCursor.POINTER;
    _stage.addChild(_blocker);
    
    _stageClickSubscription = _stage.onMouseClick.listen(_onMouseClick);
    _stageMoveSubscription = _stage.onMouseMove.listen(_onMouseMove);
    _stageResizeSubscription = _stage.onResize.listen((_) => _redrawBlocker());

    _redrawBlocker();
  }

  void _redrawBlocker() {
    _blocker.graphics
      ..clear()
      ..rect(0, 0, _stage.stageWidth, _stage.stageHeight)
      ..fillColor(0x00000000);
  }

  void _onMouseClick(_) {
    Point mousePos = _stage.mousePosition;

    int pixel = _bitmapData.getPixel(mousePos.x.toInt(), mousePos.y.toInt());
    pixel = ColorHelper.removeTransparency(pixel);

    _colorPicker.setSelectedPixelColor(pixel);

    _stageClickSubscription.cancel();
    _stageMoveSubscription.cancel();
    _stageResizeSubscription.cancel();

    _stage.removeChild(_blocker);
    _blocker = null;

    dispatchEvent(Event(FINISHED));
  }

  void _onMouseMove(_) {
    Point mousePos = _stage.mousePosition;

    int pixel = _bitmapData.getPixel(mousePos.x.toInt(), mousePos.y.toInt());
    pixel = ColorHelper.removeTransparency(pixel);

    _colorPicker.setPreviewPixelColor(pixel);
  }

  void dispose() {
    _stage = null;
    _bitmapData = null;
    onFinished.cancelSubscriptions();
  }
}