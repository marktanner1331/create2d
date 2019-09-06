import 'package:stagexl/stagexl.dart';

import '../../helpers/SetSizeMixin.dart';

import './ColorSwatchCloseButton.dart';
import './ColorHelper.dart';

class ColorSwatch extends Sprite with SetSizeMixin  {
  static const String CLOSE_CLICKED = "CLOSE_CLICKED";

  static const EventStreamProvider<Event> _closeClickEvent =
      const EventStreamProvider<Event>(CLOSE_CLICKED);
  
  EventStream<Event> get onCloseClicked =>
      _closeClickEvent.forTarget(this);

  int _color = 0x00000000;
  int get color => _color;
  void set color(int value) {
    _color = value;
    refresh();
  }

  ColorSwatchCloseButton _closeButton;

  ColorSwatch(int color) {
    _color = color;
    mouseCursor = MouseCursor.POINTER;

    _closeButton = ColorSwatchCloseButton();
    _closeButton.visible = false;
    _closeButton.onMouseClick.listen(_onCloseClick);
    addChild(_closeButton);

    onMouseOver.listen((_) {
      _closeButton.visible = true;
    });

    onMouseOut.listen((_) {
      _closeButton.visible = false;
    });

    refresh();
  }

  void _onCloseClick(MouseEvent e) {
    e.stopImmediatePropagation();
    dispatchEvent(Event(CLOSE_CLICKED));
  }

  @override
  void refresh() {
    _closeButton.setSize(width / 3, width / 3);

    _closeButton
      ..x = width - _closeButton.width / 2
      ..y = -_closeButton.height / 2;

    int temp = ColorHelper.removeTransparency(color);

    graphics
      ..clear()
      ..rect(0, 0, width, height)
      ..fillColor(temp)
      ..strokeColor(0xffffffff, 1);
  }
}