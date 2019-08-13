import 'package:stagexl/stagexl.dart';

import '../Styles.dart';

class Checkbox extends Sprite {
  bool _checked = false;
  bool get checked => _checked;
  void set checked(bool value) {
    _checked = value;
    _redraw();
  }

  Checkbox() {
    _redraw();
  }

  void _redraw() {
    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, 10, 10)
      ..closePath();

      graphics
        ..fillColor(Styles.checkboxBG)
        ..strokeColor(0xff000000, 1);
    
    if(_checked) {
      graphics
        ..beginPath()
        ..circle(5, 5, 4)
        ..closePath()
        ..fillColor(Styles.checkboxSelected);
    }
  }
}