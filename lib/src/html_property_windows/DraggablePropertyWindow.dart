import 'dart:html';

import './Draggable.dart';

abstract class DraggablePropertyWindow {
  Element _div;

  DraggablePropertyWindow(Element div) {
    _div = div;
    Element titleBar = _div.querySelector(".title_bar");
    Draggable(_div, titleBar);
  }
}