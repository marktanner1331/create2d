import 'dart:html';

abstract class HTMLViewController {
  Element get view;

  int get x {
    String s = view.style.left;
    if(s == "") {
      return 0;
    }
    
    s = s.substring(0, s.length - 2);
    return int.parse(s);
  }

  void set x(int value) {
    view.style.left = "${value}px";
  }

  int get y {
    String s = view.style.top;
    if(s == "") {
      return 0;
    }

    s = s.substring(0, s.length - 2);
    return int.parse(s);
  }

  void set y(int value) {
    view.style.top = "${value}px";
  }

  int get width => view.clientWidth;

  bool get visible => view.style.display == "block";
  void set visible(bool value) => view.style.display = value ? "block" : "none";
}