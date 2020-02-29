import 'dart:html';
import 'dart:js';
import 'package:stagexl/stagexl.dart' as stageXL;

import '../view/MainWindow.dart';
import './GroupController.dart';
import '../model/CanvasUnitType.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

class UnitsViewController extends GroupController {
  stageXL.EventDispatcher _dispatcher = stageXL.EventDispatcher();

  static const String UNITS_CHANGED = "UNITS_CHANGED";

  static const stageXL.EventStreamProvider<stageXL.Event> _unitsChangedEvent =
      const stageXL.EventStreamProvider<stageXL.Event>(UNITS_CHANGED);

  stageXL.EventStream<stageXL.Event> get onUnitsChanged =>
      _unitsChangedEvent.forTarget(_dispatcher);

  CanvasPropertiesMixin _model;

  InputElement _ppu;
  SelectElement _displayUnits;

  UnitsViewController(Element div) : super(div) {
    _ppu = div.querySelector("#ppu") as InputElement;
    _ppu.onInput.listen(_onPPUChange);

    _displayUnits = div.querySelector("#displayUnits") as SelectElement;
    _displayUnits.onChange.listen(_onUnitTypeChange);
  }

  static void setPixelsPerUnitCommand(num value) {
    MainWindow.canvas.pixelsPerUnit = value;
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  static void setDisplayUnitsCommand(String value) {
    MainWindow.canvas.units = _parseCanvasUnitType(value);
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  static String getDisplayUnitsCommand() => _canvasUnitTypeToString(MainWindow.canvas.units);

  void _onUnitTypeChange(_) {
    String selectedOption = _displayUnits.selectedOptions.first.text;
    _model.units = _parseCanvasUnitType(selectedOption);

    _dispatcher.dispatchEvent(stageXL.Event(UNITS_CHANGED));
  }

  static String _canvasUnitTypeToString(CanvasUnitType value) {
    switch (value) {
      case CanvasUnitType.PIXEL:
        return "Pixels";
        break;
      case CanvasUnitType.MM:
        return "Millimeters";
        break;
      case CanvasUnitType.CM:
        return "Centimeters";
        break;
      case CanvasUnitType.M:
        return "Meters";
        break;
      case CanvasUnitType.INCH:
        return "Inches";
        break;
      case CanvasUnitType.FOOT:
        return "Feet";
        break;
      case CanvasUnitType.KM:
        return "Kilometers";
        break;
      case CanvasUnitType.MILE:
        return "Miles";
        break;
      default:
        throw Exception("Unknown canvas unit type: $value");
    }
  }

  static CanvasUnitType _parseCanvasUnitType(String value) {
    switch (value) {
      case "Pixels":
        return CanvasUnitType.PIXEL;
        break;
      case "Millimeters":
        return CanvasUnitType.MM;
        break;
      case "Centimeters":
        return CanvasUnitType.CM;
        break;
      case "Meters":
        return CanvasUnitType.M;
        break;
      case "Inches":
        return CanvasUnitType.INCH;
        break;
      case "Feet":
        return CanvasUnitType.FOOT;
        break;
      case "Kilometers":
        return CanvasUnitType.KM;
        break;
      case "Miles":
        return CanvasUnitType.MILE;
        break;
      default:
        throw Exception("Unknown canvas unit type: $value");
    }
  }

  void _onPPUChange(_) {
    num newPPU = num.tryParse(_ppu.value);

    if (newPPU == null) {
      //if we can't parse it as a number
      //see if its an expression that evaluates to a number
      dynamic temp = context.callMethod("eval", [_ppu.value]);

      if(temp is num) {
        newPPU = temp;
      } else {
        return;
      }
    }

    _model.pixelsPerUnit = newPPU;
    _dispatcher.dispatchEvent(stageXL.Event(UNITS_CHANGED));
  }

  void set model(CanvasPropertiesMixin value) {
    _model = value;
    refreshProperties();
  }

  @override
  void refreshProperties() {
    _ppu.value = _model.pixelsPerUnit.toString();

    switch (_model.units) {
      case CanvasUnitType.PIXEL:
        _displayUnits.selectedIndex = 0;
        break;
      case CanvasUnitType.MM:
        _displayUnits.selectedIndex = 1;
        break;
      case CanvasUnitType.CM:
        _displayUnits.selectedIndex = 2;
        break;
      case CanvasUnitType.M:
        _displayUnits.selectedIndex = 3;
        break;
      case CanvasUnitType.INCH:
        _displayUnits.selectedIndex = 4;
        break;
      case CanvasUnitType.FOOT:
        _displayUnits.selectedIndex = 5;
        break;
      case CanvasUnitType.KM:
        _displayUnits.selectedIndex = 6;
        break;
      case CanvasUnitType.MILE:
        _displayUnits.selectedIndex = 7;
        break;
    }
  }
}
