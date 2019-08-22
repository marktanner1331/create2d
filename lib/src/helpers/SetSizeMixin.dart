import 'package:stagexl/stagexl.dart';

mixin SetSizeMixin on DisplayObject {
  num _width = 0;
  num _height = 0;

  @override
  set width(num value) {
    throw Exception("use setSize() instead");
  }

  @override
  set height(num value) {
    throw Exception("use setSize() instead");
  }

  @override
  get width => _width;

  @override
  get height => _height;

  void setSize(num width, num height) {
    _width = width;
    _height = height;
    refresh();
  }

  void refresh();
}