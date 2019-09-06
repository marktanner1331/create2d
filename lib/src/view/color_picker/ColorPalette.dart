import 'package:stagexl/stagexl.dart';

import './ColorPickerTabMixin.dart';
import './ColorPicker.dart';
import './ColorHelper.dart';

class ColorPalette extends Sprite with ColorPickerTabMixin {
  num _preferredWidth;
  ColorPicker _colorPicker;

  BitmapData _bitmapData;
  Bitmap _bitmap;

  ColorPalette(ColorPicker colorPicker, num preferredWidth) {
    this._colorPicker = colorPicker;
    _preferredWidth = preferredWidth;

    var rm = new ResourceManager();
    rm.addBitmapData("PALETTE", "/img/palette.png");
    rm.addBitmapData("PALETTE_NO_BORDER", "/img/palette_no_border.png");
    rm.load().then(_onImagesLoaded);
  }

  void _onImagesLoaded(ResourceManager rm) {
    _bitmapData = rm.getBitmapData("PALETTE");
    _bitmap = Bitmap(_bitmapData);
    
    num ratio = _bitmapData.width / _bitmapData.height;

    _bitmap.width = _preferredWidth;
    _bitmap.height = _preferredWidth / ratio;

    addChild(_bitmap);

    onMouseMove.listen(_onMouseMove);
    onMouseClick.listen(_onMouseClick);

    _colorPicker.invalidateHeight();

    //we replace the original _bitmapData to one without borders
    //that way if a user clicks on the white border around the color box
    //they will still get the desired color
    _bitmapData = rm.getBitmapData("PALETTE_NO_BORDER");
  }

  void _onMouseClick(_) {
    Point p = mousePosition.clone();
    p.x /= _bitmap.scaleX;
    p.y /= _bitmap.scaleY;

    int pixel = _bitmapData.getPixel32(p.x, p.y);

    if(ColorHelper.isCompletelyTransparent(pixel) == false) {
      pixel = ColorHelper.removeTransparency(pixel);
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
          mouseCursor = MouseCursor.POINTER;
    } else {
      _colorPicker.setPreviewPixelColor(ColorPicker.currentColor);
          mouseCursor = MouseCursor.DEFAULT;
    }
  }

  @override
  String get displayName => "Palette";

  @override
  DisplayObject getDisplayObject() => this;

  @override
  String get modelName => "PALETTE";

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }
}