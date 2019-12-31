import 'package:stagexl/stagexl.dart';

mixin SetSizeMixin on DisplayObject {
  num _width = 0;
  num _height = 0;
  bool _isCached = false;

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

  @override
  void removeCache() {
    super.removeCache();
    _isCached = false;

    scaleX = 1;
    scaleY = 1;
    refresh();
  }

  @override
  void refreshCache() {
    refresh();
    super.refreshCache();
  }

  void applyCache(num x, num y, num width, num height,
      {bool debugBorder = false, num pixelRatio = 1.0}) {
    super.applyCache(x, y, width, height, debugBorder: debugBorder, pixelRatio: pixelRatio);
    _isCached = true;
  }

  void setSize(num width, num height) {
    _width = width;
    _height = height;
    
     if(cache == null) {
      refresh();
    } else {
      super.width = width;
      super.height = height;
    }
  }

  void refresh();
}