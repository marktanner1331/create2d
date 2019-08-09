import 'package:stagexl/stagexl.dart';

import '../Styles.dart';

class RadioButton extends Sprite {
  bool _selected = false;
  bool get selected => _selected;
  void set selected(bool value) {
    _selected = value;
    _redraw();
  }

  RadioButton() {
    _redraw();
  }

  void _redraw() {
    graphics
      ..clear()
      ..circle(10, 10, 10)
      ..closePath();

    if(_selected) {
      graphics
        ..fillColor(Styles.radioButtonSelected);
    } else {
      graphics
        ..fillColor(Styles.radioButtonUnselected);
    }

    graphics
      ..strokeColor(0xff000000, 1);
  }
}