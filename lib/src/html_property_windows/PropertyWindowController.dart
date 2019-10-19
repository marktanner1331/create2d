import 'dart:html';

import './CanvasTab.dart';
import './ContextTab.dart';
import './Draggable.dart';
import './TabController.dart';

class PropertyWindowController {
  Element _view;

  PropertyWindowController(Element view) {
    _view = view;

    Draggable(_view, _view.querySelector(".title_bar"));

    TabController()
      ..addTab(_view.querySelector("#canvasTabButton"), _view.querySelector("#canvasTab"))
      ..addTab(_view.querySelector("#contextTabButton"), _view.querySelector("#contextTab"));

    CanvasTab(_view.querySelector("#canvasTab"));
    ContextTab(_view.querySelector("#contextTab"));
  }

  int get x {
    String s = _view.style.left;
    s = s.substring(0, s.length - 2);
    return int.parse(s);
  }

  void set x(int value) {
    _view.style.left = "${value}px";
  }

  int get y {
    String s = _view.style.top;
    s = s.substring(0, s.length - 2);
    return int.parse(s);
  }

  void set y(int value) {
    _view.style.top = "${value}px";
  }

  int get width => _view.clientWidth;

  bool get visible => _view.style.display == "block";
  void set visible(bool value) => _view.style.display = value ? "block" : "none";
}