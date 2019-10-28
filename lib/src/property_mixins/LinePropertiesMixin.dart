import '../group_controllers/ContextController.dart';
import '../group_controllers/LineViewController.dart';

import './ContextPropertyMixin.dart';

mixin LinePropertiesMixin on ContextPropertyMixin {
  num _thickness = 5;
  num get thickness => _thickness;
  void set thickness(num value) {
    _thickness = value;
    invalidateProperties();
  }

  int _strokeColor = 0xff000000;
  num get strokeColor => _strokeColor;
  void set strokeColor(num value) {
    _strokeColor = value;
    invalidateProperties();
  }

  @override
  List<ContextController> getPropertyGroups() {
    return super.getPropertyGroups()
      ..add(LineViewController.instance..properties = this);
  }

  void fromLinePropertiesMixin(LinePropertiesMixin other) {
    this._thickness = other._thickness;
    this._strokeColor = other._strokeColor;
    invalidateProperties();
  }
}
