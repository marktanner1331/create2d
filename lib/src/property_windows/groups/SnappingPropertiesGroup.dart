import './PropertyGroup.dart';
import '../../property_mixins/SnappingPropertiesMixin.dart';

import '../../widgets/CheckboxWithLabel.dart';

class SnappingPropertiesGroup extends PropertyGroup {
  SnappingPropertiesMixin _properties;

  CheckboxWithLabel _grid;

  SnappingPropertiesGroup(num preferredWidth) : super("Grid", preferredWidth) {
    _grid = CheckboxWithLabel("Snap to grid");
    _grid.onCheckChanged.listen(_onGridChanged);
    addChild(_grid);

    relayout();
  }

  void _onGridChanged(_) {
    _properties.snapToGrid = _grid.checked;
  }

  void set myGridProperties(SnappingPropertiesMixin properties) {
    _properties = properties;

    _grid.checked = _properties.snapToGrid;
  }

  @override
  void relayout() {
    _grid
      ..y = 5;
  }
}
