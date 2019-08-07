import 'package:stagexl/stagexl.dart';
import '../Styles.dart';

class TabButton extends Sprite {
  bool _isHovered = false;

  bool _isSelected = false;
  bool get isSelected => _isSelected;
  void set isSelected(bool value) {
    _isSelected = value;
    _refresh();
  }

  TextField _label;
  final String modelText;

  TabButton(this.modelText, String text) {
    _label = TextField();

    TextFormat format = _label.defaultTextFormat
      ..align = TextFormatAlign.CENTER
      ..verticalAlign = TextFormatVerticalAlign.CENTER
      ..bold = true
      ..color = 0xffffffff;

    _label
      ..x = 2
      ..y = 2
      ..textColor = Styles.tabButtonText
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
      ..rect(0, 0, width, height);

    if (_isHovered || _isSelected) {
      graphics.fillColor(Styles.tabButtonHovered);
    } else {
      graphics.fillColor(Styles.tabButtonUnhovered);
    }

    graphics.closePath();
  }
}
