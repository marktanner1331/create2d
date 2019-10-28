import 'dart:html';

import './GroupController.dart';
import '../property_mixins/SnappingPropertiesMixin.dart';

class SnappingViewController extends GroupController {
  SnappingPropertiesMixin _properties;
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
    _properties.snapToGrid = _grid.checked;
  }

  void _onVerticesChanged(_) {
    _properties.snapToVertex = _vertices.checked;
  }

  void set mySnappingProperties(SnappingPropertiesMixin properties) {
    _properties = properties;
    
    _grid.checked = _properties.snapToGrid;
    _vertices.checked = _properties.snapToVertex;
  }
}