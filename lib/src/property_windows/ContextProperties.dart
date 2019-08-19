import './PropertyWindow.dart';

class ContextPropertiesWindow extends PropertyWindow {
  static ContextPropertiesWindow _instance;

  static Object _currentObject;
  static void set currentObject(Object value) {
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
  }

  @override
  void onExit() {
    _isActive = false;
  }

  @override
  String get displayName => "Properties";

  @override
  String get modelName => "CONTEXT_PROPERTIES";
}