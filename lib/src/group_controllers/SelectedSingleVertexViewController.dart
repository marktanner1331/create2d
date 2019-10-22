import 'dart:html';

import './ContextController.dart';
import '../property_mixins/SelectedSingleVertexMixin.dart';

class SelectedSingleVertexViewController extends ContextController {
  static SelectedSingleVertexViewController get instance => _instance ?? (_instance = SelectedSingleVertexViewController(document.querySelector("#contextTab #selectedSingleVertex")));
  static SelectedSingleVertexViewController _instance;

  SelectedSingleVertexViewController(Element div) : super(div) {

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