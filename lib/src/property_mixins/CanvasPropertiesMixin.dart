import '../view/MainWindow.dart';
import '../view/Canvas.dart';
import '../helpers/UnitsHelper.dart';
import '../model/CanvasUnitType.dart';

mixin CanvasPropertiesMixin {
  Canvas get myCanvas;

  UnitsHelper _helper = UnitsHelper.getUnitsHelper(CanvasUnitType.PIXEL);

  num pixelsPerUnit = 1;

  int _backgroundColor = 0xffffffff;
  int get backgroundColor => _backgroundColor;
  set backgroundColor(int value) {
    _backgroundColor = value;

    myCanvas.refreshCanvasBackground();
  }

  num _canvasWidth = 1000;
  num get canvasWidth => _canvasWidth;
  
  num _canvasHeight = 1000;
  num get canvasHeight => _canvasHeight;

  CanvasUnitType get units => _helper.type;
  void set units(CanvasUnitType value) {
    if(_helper.type == value) {
      return;
    }

    _helper = UnitsHelper.getUnitsHelper(value);
  }

  //given a measurement in pixels, this method will return its value in units using the current unit type and the current pixels per unit value
  String pixelsToUnits(num pixels) {
    //if we have 1000 pixels, and 100 pixels per unit, we want 10 units
    pixels /= pixelsPerUnit;

    return _helper.pixelsToUnits(pixels);
  }

  //given a string representing a unit in the current unit type, e.g. feet: 5'5" this method will return its value in pixels using the current pixels per unit
  num unitsToPixels(String units) {
    if(units == null || units == "") {
      return null;
    }
    
    num pixels = _helper.unitsToPixels(units);
    if(pixels == null) {
      return null;
    }
    
    //if we have 10 units and 100 pixels per unit, then we want 1000 pixels
    return pixels * pixelsPerUnit;
  }
  
  void setCanvasSize(num unitWidth, num unitHeight) {
    _canvasWidth = canvasWidth;
    _canvasHeight = canvasHeight;

    MainWindow.resetCanvasZoomAndPosition();
  }
}
