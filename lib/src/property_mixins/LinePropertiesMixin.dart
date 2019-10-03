import '../property_groups/ContextPropertyGroup.dart';
import '../property_groups/LinePropertiesGroup.dart';
import './ContextPropertyMixin.dart';

mixin LinePropertiesMixin on ContextPropertyMixin {
  num thickness = 5;
  int strokeColor = 0xff000000;

  @override
  List<ContextPropertyGroup> getPropertyGroups() {
    return super.getPropertyGroups()
      ..add(LinePropertiesGroup(this));
  }

  void fromLinePropertiesMixin(LinePropertiesMixin other) {
    this.thickness = other.thickness;
    this.strokeColor = other.strokeColor;
  }
}