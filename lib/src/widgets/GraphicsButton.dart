import 'package:stagexl/stagexl.dart';
import '../helpers/SetSizeMixin.dart';

class GraphicsButton extends Sprite with SetSizeMixin {
  num _padding = 5;
  num get padding => _padding;
  void set padding(num value) {
    _padding = value;

    _inner.x = padding;
    _inner.y = padding;

    refresh();
  }

  int _unhoveredColor = 0xff000000;
  int get unhoveredColor => _unhoveredColor;
  set unhoveredColor(int value) {
    _unhoveredColor = value;
    refresh();
  }

  int _hoveredColor = 0xff333333;
  int get hoveredColor => _hoveredColor;
  set hoveredColor(int value) {
    _hoveredColor = value;
  }

  bool _isHovered = false;
  bool get isHovered => _isHovered;
  void set isHovered(bool value) {
    _isHovered = value;
    refresh();
  }

  Sprite _inner;

  void Function(Graphics graphics, num width, num height) draw;

  GraphicsButton(void Function(Graphics graphics, num width, num height) draw) {
    this.draw = draw;

    _inner = Sprite()
      ..x = padding
      ..y = padding
      ..mouseEnabled = false;
    addChild(_inner);

    onMouseOver.listen((Event e) {
      isHovered = true;
    });

    onMouseOut.listen((Event e) {
      isHovered = false;
    });

    mouseCursor = MouseCursor.POINTER;
    refresh();
  }

  @override
  void refresh() {
    _inner.graphics.clear();
    draw(_inner.graphics, width - 2 * padding, height - 2 * padding);
  }
}
