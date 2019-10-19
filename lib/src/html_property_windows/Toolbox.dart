import 'dart:html';

import './Draggable.dart';

class Toolbox {
  Toolbox(Element view) {
    Draggable(view, view.querySelector(".title_bar"));
  }
}