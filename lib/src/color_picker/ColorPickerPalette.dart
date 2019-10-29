import 'dart:html' as html;

import 'package:stagexl/stagexl.dart';
import '../property_windows/Tab.dart';
import '../helpers/ColorHelper.dart';
import '../view/MainWindow.dart';

class ColorPickerPalette extends Tab {
  RenderLoop _renderLoop;
  Stage _stage;
  
  num _preferredWidth = 250;
  BitmapData _bitmapData;
  Bitmap _bitmap;

  ColorPickerPalette(html.Element view) : super(view) {
    StageOptions options = StageOptions()
      ..backgroundColor = 0xff222222
      ..renderEngine = RenderEngine.WebGL
      ..stageAlign = StageAlign.TOP_LEFT
      ..stageScaleMode = StageScaleMode.NO_SCALE;

    html.CanvasElement canvas =
        view.querySelector('#paletteCanvas') as html.CanvasElement;

    canvas.width = _preferredWidth;
    canvas.height = 280;

    _stage = Stage(canvas, width: _preferredWidth, height: 280, options: options);
    _renderLoop = RenderLoop();

    var rm = new ResourceManager();
    rm.addBitmapData("PALETTE", "/img/palette.png");
    rm.addBitmapData("PALETTE_NO_BORDER", "/img/palette_no_border.png");
    rm.load().then(_onImagesLoaded);
  }

   void _onImagesLoaded(ResourceManager rm) {
    _bitmapData = rm.getBitmapData("PALETTE");
    _bitmap = Bitmap(_bitmapData);
    
    num ratio = _bitmapData.width / _bitmapData.height;

    //the image has a bit too much margin on the right, lets sort that here
    _bitmap.width = _preferredWidth + 4;
    _bitmap.height = _preferredWidth / ratio;

    _stage.addChild(_bitmap);

    _stage.onMouseMove.listen(_onMouseMove);
    _stage.onMouseClick.listen(_onMouseClick);

    //we replace the original _bitmapData to one without borders
    //that way if a user clicks on the white border around the color box
    //they will still get the desired color
    _bitmapData = rm.getBitmapData("PALETTE_NO_BORDER");
  }

  void _onMouseClick(_) {
    Point p = _stage.mousePosition.clone();
    p.x /= _bitmap.scaleX;
    p.y /= _bitmap.scaleY;

    int pixel = _bitmapData.getPixel32(p.x, p.y);

    if(ColorHelper.isCompletelyTransparent(pixel) == false) {
      pixel = ColorHelper.removeTransparency(pixel);
      MainWindow.colorPicker.setSelectedPixelColor(pixel);
    }
  }

  void _onMouseMove(_) {
    Point p = _stage.mousePosition.clone();
    p.x /= _bitmap.scaleX;
    p.y /= _bitmap.scaleY;

    int pixel = _bitmapData.getPixel32(p.x, p.y);

    //make sure its not transparent
    if((pixel >> 24) != 0) {
      //remove any transparency
      pixel |= 0xff000000;

      MainWindow.colorPicker.setPreviewPixelColor(pixel);
          _stage.mouseCursor = MouseCursor.POINTER;
    } else {
      MainWindow.colorPicker.setPreviewPixelColor(MainWindow.colorPicker.currentColor);
          _stage.mouseCursor = MouseCursor.DEFAULT;
    }
  }

  @override
  void onEnter() {
    if (_stage.renderLoop == null) {
      _renderLoop.addStage(_stage);
    }
  }

  @override
  void onExit() {
    _renderLoop.removeStage(_stage);
  }
}