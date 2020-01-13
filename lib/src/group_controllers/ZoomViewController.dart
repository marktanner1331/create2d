import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL;

import './ContextController.dart';
import '../view/MainWindow.dart';
import '../helpers/Draggable.dart';
import '../helpers/SliderBoxController.dart';

class ZoomViewController extends ContextController {
  static ZoomViewController get instance =>
      _instance ?? (_instance = ZoomViewController());
  static ZoomViewController _instance;
  
  InputElement _steps;

  InputElement _max;
  num _currentZoomMultiplier;

  SliderBoxController _sliderBox;

  ButtonElement _zoomOut;

  stageXL.EventStreamSubscription<stageXL.Event> _onZoomChangedSubscription;
  Point zoomPoint;

  ZoomViewController() : super(document.querySelector("#contextTab #zoom")) {
    _steps = view.querySelector("#zoomSteps");
    _steps.onInput.listen(_onStepsChanged);

    _max = view.querySelector("#zoomMax");
    _max.onInput.listen(_onMaxChanged);
    _max.onFocus.listen(_onMaxFocus);

    _zoomOut = view.querySelector("#zoomOut");
    _zoomOut.onClick.listen(_onZoomOutClick);
  }

  void _onZoomOutClick(_) => MainWindow.resetCanvasZoomAndPosition();

  void _onDotChanged(_) {
    Point p = zoomPoint;
    if(p == null) {
      p = MainWindow.getGlobalCanvasCenter();
      MainWindow.globalSpaceToDrawingSpace(p);
    }

    MainWindow.zoomInAtPoint(p, _sliderBox.decimalX);
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
    if(_sliderBox.isDragging == false) {
      _sliderBox.decimalX = MainWindow.canvasZoom;
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

    _onZoomChangedSubscription = MainWindow.onZoomChanged.listen((_) {
      _resetDotPosition();
      refreshProperties();
    });
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
    _sliderBox = SliderBoxController(view.querySelector(".slider_box"));
 
    _sliderBox.onStartedDrag.listen(_onDotStarted);
    _sliderBox.onPositionChanged.listen(_onDotChanged);
    _sliderBox.onFinishedDrag.listen(_onDotFinished);
  }

  @override
  void refreshProperties() {
    _steps.value = MainWindow.zoomSteps.toString();
    _max.value = MainWindow.maxZoomMultiplier.toString();
    _sliderBox.decimalX = MainWindow.canvasZoom;
  }
}
