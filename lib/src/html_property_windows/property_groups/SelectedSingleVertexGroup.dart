import 'dart:html';

import '../../property_mixins/SelectedSingleVertexMixin.dart';
import './ContextGroup.dart';

class SelectedSingleVertexGroup extends ContextGroup {
  static SelectedSingleVertexGroup get instance => _instance ?? (_instance = SelectedSingleVertexGroup(document.querySelector("#contextTab #selectedSingleVertex")));
  static SelectedSingleVertexGroup _instance;

  SelectedSingleVertexGroup(Element div) : super(div) {

  }

  void set properties(SelectedSingleVertexMixin value) {

  }

  @override
  void onEnter() {
  }

  @override
  void onExit() {
  }
}