import 'package:stagexl/stagexl.dart';

mixin SetSizeMixin on DisplayObject {
  @override
  set width(num value) {
    throw Exception("use setSize() instead");
  }

  @override
  set height(num value) {
    throw Exception("use setSize() instead");
  }

  void setSize(num width, num height);
}