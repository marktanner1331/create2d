import 'package:stagexl/stagexl.dart';
import 'dart:math';

import '../view/MainWindow.dart';
import '../view/Canvas.dart';
import '../helpers/UnitsHelper.dart';
import '../model/CanvasUnitType.dart';
import '../model/PaperSize.dart';
import '../model/Orientation.dart';

mixin CanvasPropertiesMixin {
  Canvas get myCanvas;

  EventDispatcher _dispatcher = EventDispatcher();
  EventStream<Event> get numVerticesChanged => _dispatcher.on("PROPERTY_CHANGED");

  void dispatchNumVerticesChangedEvent() {
    _dispatcher.dispatchEvent(Event("PROPERTY_CHANGED"));
  }

  int get numVertices => myCanvas.currentGraphics.numVertices;

  UnitsHelper _helper = UnitsHelper.getUnitsHelper(CanvasUnitType.PIXEL);

  Orientation get paperOrientation {
    if(_canvasWidth < _canvasHeight) {
      return Orientation.Portrait;
    } else {
      return Orientation.Landscape;
    }
  }
  void set paperOrientation(Orientation value) {
    if(value == Orientation.Portrait) {
      setCanvasSize(min(_canvasWidth, _canvasHeight), max(_canvasWidth, _canvasHeight));
    } else {
      setCanvasSize(max(_canvasWidth, _canvasHeight), min(_canvasWidth, _canvasHeight));
    }
  }

  //only used to keep track of it for the view
  //the actual size is stored in _canvasWidth and _canvasHeight
  PaperSize _paperSize = PaperSize.Custom;
  PaperSize get paperSize => _paperSize;
  void set paperSize(PaperSize value) {
    _paperSize = value;

    if(value == PaperSize.Custom) {
      return;
    }

    num width;
    num height;
    switch(value) {
      case PaperSize.A0:
        width = 2384;
        height = 3370;
        break;
      case PaperSize.A1:
        width = 1684;
        height = 2384;
        break;
      case PaperSize.A2:
        width = 1191;
        height = 1684;
        break;
      case PaperSize.A3:
        width = 842;
        height = 1191;
        break;
      case PaperSize.A4:
        width = 595;
        height = 842;
        break;
      case PaperSize.A5:
        width = 420;
        height = 595;
        break;
      case PaperSize.A6:
        width = 298;
        height = 420;
        break;
      default:
        return;
    }

    if(paperOrientation == Orientation.Portrait) {
      setCanvasSize(min(width, height), max(width, height));
    } else {
      setCanvasSize(max(width, height), min(width, height));
    }
  }

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
  
  void setCanvasSize(num width, num height) {
    _canvasWidth = width;
    _canvasHeight = height;
    MainWindow.resetCanvasZoomAndPosition();
  }
}
