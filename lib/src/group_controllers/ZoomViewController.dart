import 'dart:html';

import './ContextController.dart';
import '../view/MainWindow.dart';
import '../helpers/Draggable.dart';

class ZoomViewController extends ContextController {
  static ZoomViewController get instance =>
      _instance ?? (_instance = ZoomViewController());
  static ZoomViewController _instance;

  InputElement _steps;
  InputElement _max;
  DivElement _dot;

  ZoomViewController() : super(document.querySelector("#contextTab #zoom")) {
    _steps = view.querySelector("#zoomSteps");
    _steps.onInput.listen(_onStepsChanged);

    _max = view.querySelector("#zoomMax");
    _max.onInput.listen(_onMaxChanged);

    _dot = view.querySelector("#dot");
  }

  void _onDotChanged(_) {
    print(_dot.style.left);
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
  void onEnterForFirstTime() {
    //we cant do this in the contructor as getBoundingClientRect returns 0 if the div isnt visible
    num max = _dot.parent.getBoundingClientRect().width;
    print(max);
    Draggable(_dot, _dot, vertical: false, minX: 0, maxX: max).onPositionChanged.listen(_onDotChanged);
  }

  @override
  void refreshProperties() {
    _steps.value = MainWindow.zoomSteps.toString();
    _max.value = MainWindow.maxZoomMultiplier.toString();
  }
}