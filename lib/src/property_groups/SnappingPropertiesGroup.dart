import './PropertyGroup.dart';
import '../property_mixins/SnappingPropertiesMixin.dart';

import '../widgets/CheckboxWithLabel.dart';

class SnappingPropertiesGroup extends PropertyGroup {
  SnappingPropertiesMixin _properties;

  CheckboxWithLabel _grid;
  CheckboxWithLabel _vertex;

  SnappingPropertiesGroup() : super("Snapping") {
    _grid = CheckboxWithLabel("Snap to grid");
    _grid.onCheckChanged.listen(_onGridChanged);
    addChild(_grid);

    _vertex = CheckboxWithLabel("Snap to vertices");
    _vertex.onCheckChanged.listen(_onVertexChanged);
    addChild(_vertex);

    relayout();
  }

  void _onVertexChanged(_) {
    _properties.snapToVertex = _vertex.checked;
  }

  void _onGridChanged(_) {
    _properties.snapToGrid = _grid.checked;
  }

  void set myGridProperties(SnappingPropertiesMixin properties) {
    _properties = properties;

    _grid.checked = _properties.snapToGrid;
    _vertex.checked = _properties.snapToVertex;
  }

  @override
  void relayout() {
    _grid
      ..y = 5;

    _vertex
      ..y = _grid.y + _grid.height + 5;
  }
}
