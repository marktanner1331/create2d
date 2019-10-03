import '../property_groups/ContextPropertyGroup.dart';
import '../property_groups/SelectedSingleVertexGroup.dart';
import './ContextPropertyMixin.dart';
import '../stateful_graphics/Vertex.dart';

mixin SelectedSingleVertexMixin on ContextPropertyMixin {
  List<Vertex> get selectedVertices;

  @override
  List<ContextPropertyGroup> getPropertyGroups() {
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
    invalidateProperties();
  }

  num get y => selectedVertices.first.y;
  void set y(num value) {
    selectedVertices.first.y = value;
    invalidateProperties();
  }
}