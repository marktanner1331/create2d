import 'dart:html';

import './GroupController.dart';
import '../property_mixins/SnappingPropertiesMixin.dart';

class SnappingViewController extends GroupController {
  SnappingPropertiesMixin _model;
  InputElement _grid;

  //TODO: when snapping to vertices is false, we probably shouldnt do the red dot overlays
  //when hovering over a vertex while drawing
  InputElement _vertices;

  SnappingViewController(Element div) : super(div) {
    _grid = div.querySelector("#snapToGrid") as InputElement;
    _grid.onInput.listen(_onGridChanged);

    _vertices = div.querySelector("#snapToVertices") as InputElement;
    _vertices.onInput.listen(_onVerticesChanged);
  }

  void _onGridChanged(_) {
    _model.snapToGrid = _grid.checked;
  }

  void _onVerticesChanged(_) {
    _model.snapToVertex = _vertices.checked;
  }

  void set model(SnappingPropertiesMixin value) {
    _model = value;
    refreshProperties();
  }

  @override
  void refreshProperties() {
    _grid.checked = _model.snapToGrid;
    _vertices.checked = _model.snapToVertex;
  }
}