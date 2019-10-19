import 'dart:html';
import './Draggable.dart';

class ColorPicker {
  ColorPicker(Element view) {
    Draggable(view, view.querySelector(".title_bar"));
  }
}