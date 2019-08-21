import './PropertyWindow.dart';

import '../property_groups/PropertyGroup.dart';

import '../property_mixins/ContextPropertyMixin.dart';

class ContextPropertiesWindow extends PropertyWindow {
  static ContextPropertiesWindow _instance;

  static ContextPropertyMixin _currentObject;
  static void set currentObject(ContextPropertyMixin value) {
    if(_instance._isActive) {
      _instance.onExit();
      _currentObject = value;
      _instance.onEnter();
    } else {
      _currentObject = value;
    }
  }

  bool _isActive = false;
  
  ContextPropertiesWindow() {
    assert(_instance == null);
    _instance = this;
  }

  @override
  void onEnter() {
    _isActive = true;

    if(_currentObject == null) {
      return;
    }

    for(PropertyGroup propertyGroup in _currentObject.getPropertyGroups()) {
      addPropertyGroup(propertyGroup);
    }
  }

  @override
  void onExit() {
    _isActive = false;
    clearPropertyGroups();
  }

  @override
  String get displayName => "Properties";

  @override
  String get modelName => "CONTEXT_PROPERTIES";
}