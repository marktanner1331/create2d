import 'dart:html';
import 'dart:typed_data';
import '../property_windows/Tab.dart';
import '../helpers/ColorHelper.dart';
import '../view/MainWindow.dart';

class ColorPickerWheel extends Tab {
  ImageElement _hiddenWheel;
  CanvasElement _canvas;
  CanvasRenderingContext2D _canvasContext;

  ColorPickerWheel(Element view) : super(view) {
    _hiddenWheel = view.querySelector("#hiddenWheel") as ImageElement;
    _hiddenWheel.onLoad.listen(_onHiddenWheelLoad);
    _hiddenWheel.src = "img/color_wheel.png";
    
    _canvas = view.querySelector("#wheelCanvas");
  }

  void _onHiddenWheelLoad(_) {
    _canvas.width = _hiddenWheel.naturalWidth;
    _canvas.height = _hiddenWheel.naturalHeight;
    _canvas.onMouseMove.listen(_onWheelMouseMove);
    _canvas.onClick.listen(_onWheelClick);

    _canvasContext = _canvas.context2D;
    _canvasContext.drawImage(_hiddenWheel, 0, 0);
  }

  void _onWheelClick(MouseEvent e) {
    int x = (_canvas.width * e.offset.x) ~/ _canvas.clientWidth;
    int y = (_canvas.height * e.offset.y) ~/ _canvas.clientHeight;
    
    Uint8ClampedList rgba = _canvasContext.getImageData(x, y, 1, 1).data;
    
    if(rgba[3] != 0) {
      int color = ColorHelper.colorFromRGB(rgba[0], rgba[1], rgba[2]);
      MainWindow.colorPicker.setSelectedPixelColor(color);
    }
  }

  void _onWheelMouseMove(MouseEvent e) {
    int x = (_canvas.width * e.offset.x) ~/ _canvas.clientWidth;
    int y = (_canvas.height * e.offset.y) ~/ _canvas.clientHeight;
    
    Uint8ClampedList rgba = _canvasContext.getImageData(x, y, 1, 1).data;
    
    if(rgba[3] == 0) {
      MainWindow.colorPicker.setPreviewPixelColor(MainWindow.colorPicker.currentColor);
      
      _canvas.style.cursor = "";
    } else {
      int color = ColorHelper.colorFromRGB(rgba[0], rgba[1], rgba[2]);
      MainWindow.colorPicker.setPreviewPixelColor(color);

      _canvas.style.cursor = "pointer";
    }
  }

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }
}