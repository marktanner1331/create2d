import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';
import 'dart:html' as html;
import 'dart:math';
import 'dart:async';

import './Canvas.dart';
import './ShortcutController.dart';
import './TooltipController.dart';
import './DialogLayer.dart';
import '../color_picker/ColorPicker.dart';
import '../main_menu/MainMenu.dart';
import '../property_windows/PropertyWindowController.dart';
import '../tools/ToolboxController.dart';
import '../helpers/DraggableController.dart';
import './CommandPalette.dart';

import '../helpers/AspectFit.dart';

class MainWindow extends Sprite with RefreshMixin, SetSizeAndPositionMixin {
  static int _backgroundColor = 0xff6D8FA6;

  static Canvas _canvas;
  static Canvas get canvas => _canvas;

  //the total magnification when fully zoomed in
  static num maxZoomMultiplier = 5;
  
  //how many times the user can click before returning back to the original zoom level
  static int zoomSteps = 2;

  //represents how much the canvas is zoomed in
  //0 >= _canvasZoom  <= 1
  static num _canvasZoom = 0;
  static num get canvasZoom => _canvasZoom;

  static EventStream<Event> get onZoomChanged => _instance.on("ZOOM_CHANGED");

  static ShortcutController _shortcutController;
  static ShortcutController get shortcutController => _shortcutController;

  static final PropertyWindowController propertyWindow =
      PropertyWindowController(html.querySelector("#properties"));
  static final ToolboxController toolbox =
      ToolboxController(html.querySelector("#toolbox"));
  static final ColorPicker colorPicker = ColorPicker();

  static MainMenu _mainMenu;

  static CommandPalette _commandPalette;

  //used when the canvas is being dragged
  //e.g. in calls to startPanningCanvas()
  static DraggableController _panningController;
  static StreamSubscription<html.KeyboardEvent> _onKeyDownForPanningCanvasSubscription;

  static num panStep = 5;
  static bool reversePanDirection  = false;

  static MainWindow _instance;
  static MainWindow get instance => _instance;

  MainWindow() {
    assert(_instance == null);
    _instance = this;

    _shortcutController = ShortcutController();

    //initialize the singletons
    TooltipController(html.document.querySelector("#tooltip"));
    DialogLayer();

    _mainMenu = MainMenu();

    _commandPalette = CommandPalette();

    _canvas = Canvas();
    addChild(_canvas);

    addChild(DialogLayer.instance);

    toolbox.selectFirstTool();
    colorPicker.hide();
  }

  static void drawingSpaceToGlobalSpace(Point p) {
    p.x *= canvas.drawingSpaceToCanvasSpace;
    p.y *= canvas.drawingSpaceToCanvasSpace;

    p.x += canvas.x;
    p.y += canvas.y;
  }

  static void globalSpaceToDrawingSpace(Point p) {
    p.x -= canvas.x;
    p.y -= canvas.y;

    p.x *= canvas.canvasSpaceToDrawingSpace;
    p.y *= canvas.canvasSpaceToDrawingSpace;
  }

  @override
  void refresh() {
    graphics.clear();
    graphics.rect(0, 0, width, height);
    graphics.fillColor(_backgroundColor);

    this.mask = Mask.rectangle(0, 0, width, height);

    resetCanvasZoomAndPosition();

    propertyWindow
      ..x = width - propertyWindow.width - 5
      ..y = _mainMenu.height + 5;

    toolbox
      ..x = 5
      ..y = _mainMenu.height + 5;

    if (colorPicker.x == 0 && colorPicker.y == 0) {
      colorPicker
        ..x = propertyWindow.x - colorPicker.width - 5
        ..y = propertyWindow.y;
    }

    DialogLayer.relayout();
  }

  static void startPanningCanvas() {
    if(_panningController != null) {
      return;
    }

    _panningController = DraggableController(_canvas, _canvas);

    _panningController.onPositionChanged.listen((_) {
      //need to update selection layer maybe?
    });
    
    _panningController.onFinishedDrag.listen((_) {
      
    });

    _onKeyDownForPanningCanvasSubscription = html.document.body.onKeyDown.listen(_onKeyDownForPanningCanvas);
  }

  static void stopPanningCanvas() {
    if(_panningController == null) {
      return;
    }

    _panningController.cancel();
    _panningController.onPositionChanged.cancelSubscriptions();
    _panningController.onFinishedDrag.cancelSubscriptions();
    _panningController = null;

    _onKeyDownForPanningCanvasSubscription.cancel();
    _onKeyDownForPanningCanvasSubscription = null;
  }

  //adjusts the position of the canvas by the given offset
  static void panCanvasWithOffset(num offsetX, num offsetY) {
    _canvas.x += offsetX;
    _canvas.y += offsetY;
  }

  static void _onKeyDownForPanningCanvas(html.KeyboardEvent e) {
    if(e.target is html.TextInputElement) {
      return;
    }

    switch(e.keyCode) {
      case html.KeyCode.UP:
        _canvas.y -= panStep * (reversePanDirection ? -1 : 1);
        break;
      case html.KeyCode.DOWN:
        _canvas.y += panStep * (reversePanDirection ? -1 : 1);
        break;
      case html.KeyCode.LEFT:
        _canvas.x -= panStep * (reversePanDirection ? -1 : 1);
        break;
      case html.KeyCode.RIGHT:
        _canvas.x += panStep * (reversePanDirection ? -1 : 1);
        break;
    }
  }

  static void zoomInAtCenter(num zoom) {
    Point center = getGlobalCanvasCenter();
    globalSpaceToDrawingSpace(center);

    zoomInAtPoint(center, zoom);
  }

  ///returns the center of the canvas area in global space
  ///useful for zooming in
  static Point getGlobalCanvasCenter() =>
      Point(instance.width / 2, (_instance.height + _mainMenu.height) / 2);

  //will not revert back to 0 if greater than 1
  static void zoomStepOutAtCenter() {
    Point center = getGlobalCanvasCenter();
    globalSpaceToDrawingSpace(center);

    num delta = 1 / zoomSteps;
    _canvasZoom -= delta;

    _canvasZoom = max(0, _canvasZoom);

    if (_canvasZoom == 0) {
      resetCanvasZoomAndPosition();
    } else {
      zoomInAtPoint(center, _canvasZoom);
    }
  }

  //will not revert back to 0 if greater than 1
  static void zoomStepInAtCenter() {
    Point center = getGlobalCanvasCenter();
    globalSpaceToDrawingSpace(center);

    zoomStepInAtPoint(center);
  }

  //canvasPoint should be a point in drawing space
  static void zoomStepInAtPoint(Point canvasPoint) {
    num delta = 1 / zoomSteps;
    _canvasZoom += delta;

    _canvasZoom = min(1, _canvasZoom);

    if (_canvasZoom == 0) {
      resetCanvasZoomAndPosition();
    } else {
      zoomInAtPoint(canvasPoint, _canvasZoom);
    }
  }

  ///point should be in drawing space
  static void zoomInAtPoint(Point drawingPoint, num zoom) {
    _canvasZoom = zoom;

    num zoomMultiplier = pow(maxZoomMultiplier, _canvasZoom);
    
    Point global = drawingPoint.clone();
    drawingSpaceToGlobalSpace(global);

    Rectangle rect = aspectFitChildInsideParent(
        _instance.width,
        _instance.height - _mainMenu.height,
        canvas.canvasWidth,
        canvas.canvasHeight,
        padding: 20);

    canvas..setSize(rect.width * zoomMultiplier, rect.height * zoomMultiplier);

    Point newGlobal = drawingPoint.clone();
    drawingSpaceToGlobalSpace(newGlobal);

    canvas
      ..x += global.x - newGlobal.x
      ..y += global.y - newGlobal.y;

    _instance.dispatchEvent(Event("ZOOM_CHANGED"));
  }

  //the zoom multiplier is a function of the current canvasZoom and the maxZoomMultiplier
  //it can be useful for comparing situations which depend on both of these
  static num get zoomMultiplier => pow(maxZoomMultiplier, _canvasZoom);
  
  //updates the _canvas zoom using the given zoomMultiplier and set maxZoomMultiplier
  //useful for when you want to set the maxZoomMultiplier first and make sure 
  //the _canvasZoom is adjusted accordingly
  static void setCanvasZoomFromZoomMultiplier(num zoomMultiplier) {
    _canvasZoom = log(zoomMultiplier) / log(maxZoomMultiplier);
    _canvasZoom = min(_canvasZoom, 1);
    
    _instance.dispatchEvent(Event("ZOOM_CHANGED"));
  }

  static void set cacheCanvasAsBitmap(bool value) {
    if (value) {
      canvas.applyCache(0, 0, canvas.width, canvas.height);
    } else {
      canvas.removeCache();
    }
  }

  ///resets the canvas back to the default size and centers it
  static void resetCanvasZoomAndPosition() {
    _canvasZoom = 0;

    Rectangle rect = aspectFitChildInsideParent(
        _instance.width,
        _instance.height - _mainMenu.height,
        canvas.canvasWidth,
        canvas.canvasHeight,
        padding: 20);

    canvas
      ..x = rect.left
      ..y = rect.top + _mainMenu.height
      ..setSize(rect.width, rect.height);

    _instance.dispatchEvent(Event("ZOOM_CHANGED"));
  }
}
