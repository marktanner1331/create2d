import 'dart:html';

import './GroupController.dart';
import '../model/CanvasUnitType.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';

class UnitsController extends GroupController {
  CanvasPropertiesMixin _properties;
  
  InputElement _ppu;

  InputElement _pixel;
  InputElement _mm;
  InputElement _cm;
  InputElement _m;
  InputElement _inch;
  InputElement _foot;
  InputElement _km;
  InputElement _mile;

  UnitsController(Element div) : super(div) {
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
      _properties.units = CanvasUnitType.PIXEL;
    } else if(_mm.checked) {
      _properties.units = CanvasUnitType.MM;
    } else if(_cm.checked) {
      _properties.units = CanvasUnitType.CM;
    } else if(_m.checked) {
      _properties.units = CanvasUnitType.M;
    } else if(_inch.checked) {
      _properties.units = CanvasUnitType.INCH;
    } else if(_foot.checked) {
      _properties.units = CanvasUnitType.FOOT;
    } else if(_km.checked) {
      _properties.units = CanvasUnitType.KM;
    } else if(_mile.checked) {
      _properties.units = CanvasUnitType.MILE;
    } else {
      throw Error();
    }
  }

  void _onPPUChange(_) {
    num newPPU = num.tryParse(_ppu.value);
    if(newPPU == null) {
      return;
    }

    _properties.pixelsPerUnit = newPPU;
  }

  void set myCanvasProperties(CanvasPropertiesMixin properties) {
    _properties = properties;

    _ppu.value = _properties.pixelsPerUnit.toString();
    
    switch(_properties.units) {
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