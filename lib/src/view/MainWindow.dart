import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';
import 'dart:html' as html;

import './Canvas.dart';
import './KeyboardController.dart';
import './TooltipController.dart';
import './DialogLayer.dart';
import '../color_picker/ColorPicker.dart';
import '../file_menu/FileMenu.dart';
import '../property_windows/PropertyWindowController.dart';
import '../tools/ToolboxController.dart';

import '../helpers/AspectFit.dart';

class MainWindow extends Sprite with RefreshMixin, SetSizeAndPositionMixin {
  int _backgroundColor = 0xff6D8FA6;

  static Canvas _canvas;
  static Canvas get canvas => _canvas;

  static KeyboardController _keyboardController;
  static KeyboardController get keyboardController => _keyboardController;

  static final PropertyWindowController propertyWindow = PropertyWindowController(html.querySelector("#properties"));
  static final ToolboxController toolbox = ToolboxController(html.querySelector("#toolbox"));
  static final ColorPicker colorPicker = ColorPicker(html.querySelector("#colorPicker"));

  static FileMenu _fileMenu;

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

    if(colorPicker.x == 0 && colorPicker.y == 0) {
      colorPicker
        ..x = propertyWindow.x - colorPicker.width - 5
        ..y = propertyWindow.y;
    }

    DialogLayer.relayout();
  }

  ///resets the canvas back to the default size and centers it
  static void resetCanvasZoomAndPosition() {
    Rectangle rect = aspectFitChildInsideParent(_instance.width, _instance.height - _fileMenu.height, canvas.canvasWidth, canvas.canvasHeight, padding: 20);
    
    canvas
      ..x = rect.left
      ..y = rect.top + _fileMenu.height
      ..setSize(rect.width, rect.height); 
  }
}
