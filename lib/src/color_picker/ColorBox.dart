import 'dart:html';
import '../helpers/ColorHelper.dart';

class ColorBox {
  int _color = 0xff000000;
  int get color => _color;
  void set color(int value) {
    _color = value;
    _view.style.backgroundColor = "#" + ColorHelper.colorToHex(value);
  }

  Element _view;

  ColorBox(Element view) {
    this._view = view;
  }
}