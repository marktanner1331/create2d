import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';
import 'dart:html' as html;
import 'dart:math';

import './Canvas.dart';
import './KeyboardController.dart';
import './TooltipController.dart';
import './DialogLayer.dart';
import '../color_picker/ColorPicker.dart';
import '../file_menu/FileMenu.dart';
import '../property_windows/PropertyWindowController.dart';
import '../tools/ToolboxController.dart';
import '../helpers/DraggableController.dart';

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

  static KeyboardController _keyboardController;
  static KeyboardController get keyboardController => _keyboardController;

  static final PropertyWindowController propertyWindow =
      PropertyWindowController(html.querySelector("#properties"));
  static final ToolboxController toolbox =
      ToolboxController(html.querySelector("#toolbox"));
  static final ColorPicker colorPicker = ColorPicker();

  static FileMenu _fileMenu;

  //used when the canvas is being dragged
  //e.g. in calls to startPanningCanvas()
  DraggableController _panningController;

  static MainWindow _instance;
  static MainWindow get instance => _instance;

  MainWindow() {
    assert(_instance == null);
    _instance = this;

    _keyboardController = KeyboardController(this);

    //initialize the singletons
    TooltipController(html.document.querySelector("#tooltip"));
    DialogLayer();

    _fileMenu = FileMenu();

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
    p.x *= canvas.canvasSpaceToDrawingSpace;
    p.y *= canvas.canvasSpaceToDrawingSpace;

    p.x -= canvas.x;
    p.y -= canvas.y;
  }

  @override
  void refresh() {
    graphics.clear();
    graphics.rect(0, 0, width, height);
    graphics.fillColor(_backgroundColor);

    resetCanvasZoomAndPosition();

    propertyWindow
      ..x = width - propertyWindow.width - 5
      ..y = _fileMenu.height + 5;

    toolbox
      ..x = 5
      ..y = _fileMenu.height + 5;

    if (colorPicker.x == 0 && colorPicker.y == 0) {
      colorPicker
        ..x = propertyWindow.x - colorPicker.width - 5
        ..y = propertyWindow.y;
    }

    DialogLayer.relayout();
  }

  static void startPanningCanvas() {
    DraggableController dc = DraggableController(_canvas, _canvas);

    EventStreamSubscription<Event> onChangedSubscription = dc.onPositionChanged.listen((_) {
      //need to update selection layer maybe?
    });

    EventStreamSubscription<Event> onFinishedSubscription;
    onFinishedSubscription = dc.onFinishedDrag.listen((_) {
      onChangedSubscription.cancel();
      onFinishedSubscription.cancel();
    });
  }

  static void zoomInAtCenter(num zoom) {
    _canvasZoom = zoom;

    Point center = Point(
      _instance.width / 2,
      (_canvas.y + _canvas.y + _canvas.height) / 2
    );

    globalSpaceToDrawingSpace(center);

    _zoomInAtPoint(center, zoom);
  }

  //canvasPoint should be a point in drawing space
  static void zoomInAtPoint(Point canvasPoint) {
    num delta = 1 / zoomSteps;
    _canvasZoom += delta;

    if (_canvasZoom > 1) {
      resetCanvasZoomAndPosition();
    } else {
      _zoomInAtPoint(canvasPoint, _canvasZoom);
    }
  }

  static void _zoomInAtPoint(Point canvasPoint, num zoom) {
    num zoomMultiplier = pow(maxZoomMultiplier, _canvasZoom);

    Point global = canvasPoint.clone();
    drawingSpaceToGlobalSpace(global);

    Rectangle rect = aspectFitChildInsideParent(
        _instance.width,
        _instance.height - _fileMenu.height,
        canvas.canvasWidth,
        canvas.canvasHeight,
        padding: 20);

    canvas..setSize(rect.width * zoomMultiplier, rect.height * zoomMultiplier);

    Point newGlobal = canvasPoint.clone();
    drawingSpaceToGlobalSpace(newGlobal);

    canvas
      ..x += global.x - newGlobal.x
      ..y += global.y - newGlobal.y;
  }

  ///resets the canvas back to the default size and centers it
  static void resetCanvasZoomAndPosition() {
    _canvasZoom = 0;

    Rectangle rect = aspectFitChildInsideParent(
        _instance.width,
        _instance.height - _fileMenu.height,
        canvas.canvasWidth,
        canvas.canvasHeight,
        padding: 20);

    canvas
      ..x = rect.left
      ..y = rect.top + _fileMenu.height
      ..setSize(rect.width, rect.height);
  }
}
