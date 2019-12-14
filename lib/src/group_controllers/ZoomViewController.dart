import 'dart:html';

import './ContextController.dart';
import '../view/MainWindow.dart';

class ZoomViewController extends ContextController {
  static ZoomViewController get instance =>
      _instance ?? (_instance = ZoomViewController());
  static ZoomViewController _instance;

  InputElement _steps;
  InputElement _max;

  ZoomViewController() : super(document.querySelector("#contextTab #zoom")) {
    _steps = view.querySelector("#zoomSteps");
    _steps.onInput.listen(_onStepsChanged);

    _max = view.querySelector("#zoomMax");
    _max.onInput.listen(_onMaxChanged);
  }

  void _onStepsChanged(_) {
    int newSteps = int.tryParse(_steps.value);
    
    if (newSteps == null || newSteps < 1) {
      return;
    }

    MainWindow.zoomSteps = newSteps;

    dispatchChangeEvent();
  }

  void _onMaxChanged(_) {
    num newMax = int.tryParse(_max.value);
    
    if (newMax == null || newMax < 1) {
      return;
    }
    
    MainWindow.maxZoomMultiplier = newMax;

    dispatchChangeEvent();
  }

  void clearModels() {}

  @override
  void refreshProperties() {
    _steps.value = MainWindow.zoomSteps.toString();
    _max.value = MainWindow.maxZoomMultiplier.toString();
  }
}