import '../html_property_windows/property_groups/ContextGroup.dart';
import '../html_property_windows/property_groups/LineGroup.dart';

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
  List<ContextGroup> getPropertyGroups() {
    return super.getPropertyGroups()
      ..add(LineGroup.instance..properties = this);
  }

  void fromLinePropertiesMixin(LinePropertiesMixin other) {
    this._thickness = other._thickness;
    this._strokeColor = other._strokeColor;
    invalidateProperties();
  }
}
