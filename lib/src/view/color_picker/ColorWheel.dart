import 'package:stagexl/stagexl.dart';

import './ColorPickerTabMixin.dart';
import './ColorPicker.dart';

class ColorWheel extends Sprite with ColorPickerTabMixin {
  num _preferredWidth;
  ColorPicker _colorPicker;

  BitmapData _bitmapData;
  Bitmap _bitmap;

  ColorWheel(ColorPicker colorPicker, num preferredWidth) {
    this._colorPicker = colorPicker;
    _preferredWidth = preferredWidth;

    var rm = new ResourceManager();
    rm.addBitmapData("COLOR_WHEEL", "/img/color_wheel.png");
    rm.load().then(_onImageLoaded);
  }

  void _onImageLoaded(ResourceManager rm) {
    _bitmapData = rm.getBitmapData("COLOR_WHEEL");
    _bitmap = Bitmap(_bitmapData);

    num ratio = _bitmapData.width / _bitmapData.height;

    _bitmap.width = _preferredWidth;
    _bitmap.height = _preferredWidth / ratio;

    addChild(_bitmap);

    onMouseMove.listen(_onMouseMove);
    onMouseClick.listen(_onMouseClick);
  }

  void _onMouseClick(_) {
    Point p = mousePosition.clone();
    p.x /= _bitmap.scaleX;
    p.y /= _bitmap.scaleY;

    int pixel = _bitmapData.getPixel32(p.x, p.y);

    //make sure its not transparent
    if((pixel >> 24) != 0) {
      //remove any transparency
      pixel |= 0xff000000;

      _colorPicker.setSelectedPixelColor(pixel);
    }
  }

  void _onMouseMove(_) {
    Point p = mousePosition.clone();
    p.x /= _bitmap.scaleX;
    p.y /= _bitmap.scaleY;

    int pixel = _bitmapData.getPixel32(p.x, p.y);

    //make sure its not transparent
    if((pixel >> 24) != 0) {
      //remove any transparency
      pixel |= 0xff000000;

      _colorPicker.setPreviewPixelColor(pixel);
    }
  }

  @override
  String get displayName => "Wheel";

  @override
  DisplayObject getDisplayObject() => this;

  @override
  String get modelName => "WHEEL";

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }
}