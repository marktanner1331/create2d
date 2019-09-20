import '../property_groups/PropertyGroup.dart';
import '../property_groups/SelectedSingleVertexGroup.dart';
import './ContextPropertyMixin.dart';
import '../stateful_graphics/Vertex.dart';

mixin SelectedSingleVertexMixin on ContextPropertyMixin {
  List<Vertex> get selectedVertices;
  void invalidateVertexPositions();

  @override
  List<PropertyGroup> getPropertyGroups() {
    if(selectedVertices.length == 1) {
      return super.getPropertyGroups()
        ..add(SelectedSingleVertexGroup(this));
    } else {
      return super.getPropertyGroups();
    }
  }

  num get x => selectedVertices.first.x;
  void set x(num value) {
    selectedVertices.first.x = value;
    invalidateVertexPositions();
  }

  num get y => selectedVertices.first.y;
  void set y(num value) {
    selectedVertices.first.y = value;
    invalidateVertexPositions();
  }
}