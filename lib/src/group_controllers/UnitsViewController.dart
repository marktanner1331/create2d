import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL;

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

  InputElement _pixel;
  InputElement _mm;
  InputElement _cm;
  InputElement _m;
  InputElement _inch;
  InputElement _foot;
  InputElement _km;
  InputElement _mile;

  UnitsViewController(Element div) : super(div) {
    _ppu = div.querySelector("#ppu") as InputElement;
    _ppu.onInput.listen(_onPPUChange);

    _pixel = div.querySelector("#pixel") as InputElement;
    _pixel.onInput.listen(_onUnitTypeChange);

    _mm = div.querySelector("#mm") as InputElement;
    _mm.onInput.listen(_onUnitTypeChange);
    
    _cm = div.querySelector("#cm") as InputElement;
    _cm.onInput.listen(_onUnitTypeChange);
    
    _m = div.querySelector("#m") as InputElement;
    _m.onInput.listen(_onUnitTypeChange);
    
    _inch = div.querySelector("#inch") as InputElement;
    _inch.onInput.listen(_onUnitTypeChange);
    
    _foot = div.querySelector("#foot") as InputElement;
    _foot.onInput.listen(_onUnitTypeChange);
    
    _km = div.querySelector("#km") as InputElement;
    _km.onInput.listen(_onUnitTypeChange);
    
    _mile = div.querySelector("#mile") as InputElement;
    _mile.onInput.listen(_onUnitTypeChange);
  }

  void _onUnitTypeChange(_) {
    if(_pixel.checked) {
      _model.units = CanvasUnitType.PIXEL;
    } else if(_mm.checked) {
      _model.units = CanvasUnitType.MM;
    } else if(_cm.checked) {
      _model.units = CanvasUnitType.CM;
    } else if(_m.checked) {
      _model.units = CanvasUnitType.M;
    } else if(_inch.checked) {
      _model.units = CanvasUnitType.INCH;
    } else if(_foot.checked) {
      _model.units = CanvasUnitType.FOOT;
    } else if(_km.checked) {
      _model.units = CanvasUnitType.KM;
    } else if(_mile.checked) {
      _model.units = CanvasUnitType.MILE;
    } else {
      throw Error();
    }

    _dispatcher.dispatchEvent(stageXL.Event(UNITS_CHANGED));
  }

  void _onPPUChange(_) {
    num newPPU = num.tryParse(_ppu.value);
    if(newPPU == null) {
      return;
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
    
    switch(_model.units) {
      case CanvasUnitType.PIXEL:
        _pixel.checked = true;
        break;
      case CanvasUnitType.MM:
        _mm.checked = true;
        break;
      case CanvasUnitType.CM:
        _cm.checked = true;
        break;
      case CanvasUnitType.M:
        _m.checked = true;
        break;
      case CanvasUnitType.INCH:
        _inch.checked = true;
        break;
      case CanvasUnitType.FOOT:
        _foot.checked = true;
        break;
      case CanvasUnitType.KM:
        _km.checked = true;
        break;
      case CanvasUnitType.MILE:
        _mile.checked = true;
        break;
    }
  }
}