import '../group_controllers/ContextController.dart';
import '../group_controllers/SelectedSingleVertexViewController.dart';
import './ContextPropertyMixin.dart';
import '../stateful_graphics/Vertex.dart';

mixin SelectedSingleVertexMixin on ContextPropertyMixin {
  List<Vertex> get selectedVertices;

  @override
  List<ContextController> getPropertyGroups() {
    if(selectedVertices.length == 1) {
      return super.getPropertyGroups()
        ..add(SelectedSingleVertexViewController.instance..properties = this);
    } else {
      return super.getPropertyGroups();
    }
  }

  num get x => selectedVertices.first.x;
  void set x(num value) {
    if((selectedVertices.first.x - value).abs() > 0.01) {
      selectedVertices.first.x = value;
      invalidateProperties();
    }
  }

  num get y => selectedVertices.first.y;
  void set y(num value) {
    if((selectedVertices.first.y - value).abs() > 0.01) {
      selectedVertices.first.y = value;
      invalidateProperties();
    }
  }
}