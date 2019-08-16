import 'package:stagexl/stagexl.dart';

mixin SetSizeMixin on DisplayObject {
  num _width = 0;
  num _height = 0;

  void refresh();

  @override
  get width => _width;

  @override
  get height => _height;

    @override
  set width(num value) {
    throw Exception("use setSize() instead");
  }

  @override
  set height(num value) {
    throw Exception("use setSize() instead");
  }

  void setSize(num width, num height) {
    _width = width;
    _height = height;

    refresh();
  }
}