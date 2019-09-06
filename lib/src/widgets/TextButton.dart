import 'package:stagexl/stagexl.dart';
import '../Styles.dart';

class TextButton extends Sprite {
  bool _isHovered = false;

  TextField _label;

  TextButton(String text) {
    _label = TextField();

    TextFormat format = _label.defaultTextFormat
      ..align = TextFormatAlign.CENTER
      ..verticalAlign = TextFormatVerticalAlign.CENTER
      ..bold = true
      ..color = 0xffffffff;

    _label
      ..x = 5
      ..y = 2
      ..textColor = Styles.buttonText
      ..defaultTextFormat = format
      ..mouseEnabled = false
      ..text = text;
    _label
      ..width = _label.textWidth
      ..height = _label.textHeight;

    addChild(_label);

    mouseCursor = MouseCursor.POINTER;

    onMouseOver.listen((Event e) {
      _isHovered = true;
      _refresh();
    });

    onMouseOut.listen((Event e) {
      _isHovered = false;
      _refresh();
    });

    _refresh();
  }

  void _refresh() {
    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, _label.width + 10, height);

    if (_isHovered) {
      graphics.fillColor(Styles.buttonHovered);
    } else {
      graphics.fillColor(Styles.buttonUnhovered);
    }

    graphics.closePath();
  }
}
