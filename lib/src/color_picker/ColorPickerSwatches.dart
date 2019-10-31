import 'dart:html';

import '../property_windows/Tab.dart';
import '../helpers/ColorHelper.dart';
import '../view/MainWindow.dart';
import './EyeDropper.dart';

class ColorPickerSwatches extends Tab {
  Element _eyeDropperButton;
  bool _eyeDropperActive = false;
  EyeDropper _dropper;

  ColorPickerSwatches(Element view) : super(view) {
    _eyeDropperButton = view.querySelector("#eyeDropper");
    _eyeDropperButton.onClick.listen(_onEyeDropperClick);
  }

  void _onEyeDropperClick(_) {
    _toggleEyeDropper(!_eyeDropperActive);
  }

  void _toggleEyeDropper(bool active) {
    if(active == _eyeDropperActive) {
      return;
    }

    if(active) {
      _eyeDropperButton.classes.add("color_picker_button_selected");

      _dropper = EyeDropper(MainWindow.instance.stage);
      _dropper.onFinished.listen((_) {
        _toggleEyeDropper(false);
      });

      _dropper.start();
    } else {
       _eyeDropperButton.classes.remove("color_picker_button_selected");
       _dropper.dispose();
       _dropper = null;
       MainWindow.colorPicker.resetPreviewColor();
    }

    _eyeDropperActive = active;
  }

  @override
  void onEnter() {
  }

  @override
  void onExit() {
    if(_eyeDropperActive) {
      _toggleEyeDropper(false);
    }
  }
}