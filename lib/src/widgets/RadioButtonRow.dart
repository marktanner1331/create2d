import 'package:stagexl/stagexl.dart';

import 'RadioButton.dart';
import '../Styles.dart';

class RadioButtonRow extends Sprite {
  RadioButton _radioButton;
  TextField _label;

  bool get selected => _radioButton.selected;
  void set selected(bool value) => _radioButton.selected = value;

  final Object modelValue;

  RadioButtonRow(Object this.modelValue, String displayText) {
    mouseCursor = MouseCursor.POINTER;
    mouseChildren = false;
    
    _label = TextField(displayText)
      ..textColor = Styles.panelText
      ..autoSize = TextFieldAutoSize.LEFT;
    addChild(_label);

    _radioButton = RadioButton()
      ..width = _label.height - 2
      ..height = _label.height - 2;
    addChild(_radioButton);

    _label
      ..x = _radioButton.width + 2;
  }
}