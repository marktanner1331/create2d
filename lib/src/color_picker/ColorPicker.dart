import 'dart:html';
import '../helpers/Draggable.dart';

class ColorPicker {
  ColorPicker(Element view) {
    Draggable(view, view.querySelector(".title_bar"));
  }
}