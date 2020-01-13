import 'dart:html';

import 'package:stagexl/stagexl.dart' as stageXL;

import './ContextController.dart';
import '../view/MainWindow.dart';
import '../helpers/Draggable.dart';

class ZoomViewController extends ContextController {
  static ZoomViewController get instance =>
      _instance ?? (_instance = ZoomViewController());
  static ZoomViewController _instance;
  
  InputElement _steps;

  InputElement _max;
  num _currentZoomMultiplier;

  DivElement _dot;
  ButtonElement _zoomOut;
  Draggable _draggableDot;

  stageXL.EventStreamSubscription<stageXL.Event> _onZoomChangedSubscription;
  Point zoomPoint;

  ZoomViewController() : super(document.querySelector("#contextTab #zoom")) {
    _steps = view.querySelector("#zoomSteps");
    _steps.onInput.listen(_onStepsChanged);

    _max = view.querySelector("#zoomMax");
    _max.onInput.listen(_onMaxChanged);
    _max.onFocus.listen(_onMaxFocus);

    _dot = view.querySelector("#dot");

    _zoomOut = view.querySelector("#zoomOut");
    _zoomOut.onClick.listen(_onZoomOutClick);
  }

  void _onZoomOutClick(_) => MainWindow.resetCanvasZoomAndPosition();

  void _onDotChanged(_) {
    MainWindow.zoomInAtPoint(zoomPoint, _draggableDot.decimalX);
  }

  void _onDotStarted(_) {
    zoomPoint = MainWindow.getGlobalCanvasCenter();
    MainWindow.globalSpaceToDrawingSpace(zoomPoint);
    
    MainWindow.cacheCanvasAsBitmap = true;
  }

  void _onDotFinished(_) {
    MainWindow.cacheCanvasAsBitmap = false;
    zoomPoint = null;
  }

  void _resetDotPosition() {
    //when zoomPoint is null it means we are not currently dragging the dot
    //this means we are safe to update its position
    if(zoomPoint == null) {
      _draggableDot.decimalX = MainWindow.canvasZoom;
    }
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

    //we keep track of the current zoom multiplier
    //so that the canvasZoom can be adjusted to invert changes to the maxZoomMultiplier
    //this gives the effect of the magnification not changing as the max zoom is updated
    MainWindow.setCanvasZoomFromZoomMultiplier(_currentZoomMultiplier);

    dispatchChangeEvent();
  }

  void _onMaxFocus(_) {
    _currentZoomMultiplier = MainWindow.zoomMultiplier;
  }

  @override
  void onEnter() {
    super.onEnter();

    _onZoomChangedSubscription = MainWindow.onZoomChanged.listen((_) => _resetDotPosition());
  }

  @override
  void onExit() {
    super.onExit();
    if(_onZoomChangedSubscription != null) {
      _onZoomChangedSubscription.cancel();
      _onZoomChangedSubscription = null;
    }
  }

  void clearModels() {}

  @override
  void onEnterForFirstTime() {
    //we cant do this in the contructor as getBoundingClientRect returns 0 if the div isnt visible
    num max = _dot.parent.getBoundingClientRect().width -
        _dot.getBoundingClientRect().width;
    _draggableDot = Draggable(_dot, _dot, vertical: false, minX: 0, maxX: max);

    _draggableDot.onStartedDrag.listen(_onDotStarted);
    _draggableDot.onPositionChanged.listen(_onDotChanged);
    _draggableDot.onFinishedDrag.listen(_onDotFinished);
  }

  @override
  void refreshProperties() {
    _steps.value = MainWindow.zoomSteps.toString();
    _max.value = MainWindow.maxZoomMultiplier.toString();
  }
}
