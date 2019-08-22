import 'package:stagexl/stagexl.dart';

import '../../helpers/SetSizeMixin.dart';
import '../../Styles.dart';

class ColorBox extends Sprite with SetSizeMixin {
  TextField _label;

  int _color = 0xff000000;
  int get color => _color;
  void set color(int value) {
    _color = value;
    refresh();
  }

  ColorBox(String title) {
    _label = TextField()
      ..text = title
      ..textColor = Styles.panelText
      ..mouseEnabled = false
      ..autoSize = TextFieldAutoSize.NONE;
    
    _label
      ..width = _label.textWidth
      ..height = _label.textHeight;

    addChild(_label);
  }

  @override
  void refresh() {
    num deltaY = _label.height;

    graphics
      ..clear();
    
    graphics
      ..beginPath()
      ..rect(0, deltaY, width, height - deltaY)
      ..fillColor(0xffffffff)
      ..closePath();
    
    graphics
      ..beginPath()
      ..rect(2, deltaY + 2, width - 4, height - 4 - deltaY)
      ..fillColor(color)
      ..closePath();
  }
}