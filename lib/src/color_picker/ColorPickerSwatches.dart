import 'dart:html';

import '../property_windows/Tab.dart';
import '../helpers/ColorHelper.dart';
import '../view/MainWindow.dart';
import './EyeDropper.dart';

class ColorPickerSwatches extends Tab {
  Element _eyeDropperButton;
  bool _eyeDropperActive = false;
  EyeDropper _dropper;
  Element _swatches;

  int _swatchCounter = 0;

  ColorPickerSwatches(Element view) : super(view) {
    _eyeDropperButton = view.querySelector("#eyeDropper");
    _eyeDropperButton.onClick.listen(_onEyeDropperClick);

    Element _addSwatch = view.querySelector("#swatchButton");
    _addSwatch.onClick.listen(_onAddSwatchClick);

    _swatches = view.querySelector("#swatches");
  }

  void _onAddSwatchClick(_) {
    _swatches.insertAdjacentHtml("beforeEnd", "<div class=\"swatch\" id=\"swatch_$_swatchCounter\"></div>");

    String color = ColorHelper.colorToHex(MainWindow.colorPicker.currentColor);
    
    Element swatch = view.querySelector("#swatch_$_swatchCounter")
      ..style.backgroundColor = color
      ..onClick.listen(_onSwatchClick)
      ..onMouseOver.listen(_onSwatchMouseOver)
      ..onMouseOut.listen(_onSwatchMouseOut);

    _swatchCounter++;
  }

  void _onSwatchMouseOut(_) {
    MainWindow.colorPicker.setPreviewPixelColor(MainWindow.colorPicker.currentColor);
  }

  void _onSwatchMouseOver(MouseEvent e) {
    Element swatch = e.currentTarget as Element;
    int color = ColorHelper.parseCssColor(swatch.style.backgroundColor);
    MainWindow.colorPicker.setPreviewPixelColor(color);
  }

  void _onSwatchClick(MouseEvent e) {
    Element swatch = e.currentTarget as Element;
    int color = ColorHelper.parseCssColor(swatch.style.backgroundColor);
    MainWindow.colorPicker.setSelectedPixelColor(color);
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