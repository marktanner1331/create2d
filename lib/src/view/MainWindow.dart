import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';
import 'dart:html' as html;

import './Canvas.dart';
import './KeyboardController.dart';
import './TooltipController.dart';
import './DialogLayer.dart';
import './MainMenu.dart';
import './color_picker/ColorPicker.dart' as cp;
import '../color_picker/ColorPicker.dart';

import '../property_windows/PropertyWindowController.dart';
import '../tools/ToolboxController.dart';

import '../helpers/AspectFit.dart';

class MainWindow extends Sprite with RefreshMixin, SetSizeAndPositionMixin {
  int _backgroundColor = 0xff7ab1e3;

  static Canvas _canvas;
  static Canvas get canvas => _canvas;

  static KeyboardController _keyboardController;
  static KeyboardController get keyboardController => _keyboardController;

  static MainMenu _menu;

  static final PropertyWindowController propertyWindow = PropertyWindowController(html.querySelector("#properties"));
  static final ToolboxController toolbox = ToolboxController(html.querySelector("#toolbox"));
  static final ColorPicker colorPicker = ColorPicker(html.querySelector("#colorPicker"));

  static MainWindow _instance;

  MainWindow() {
    assert(_instance == null);
    _instance = this;
    
    _keyboardController = KeyboardController(this);

    //initialize the singletons
    TooltipController(html.document.querySelector("#tooltip"));
    DialogLayer();

    _canvas = Canvas();
    addChild(_canvas);

    addChild(cp.ColorPicker());

    _menu = MainMenu();
    addChild(_menu);

    addChild(DialogLayer.instance);

    toolbox.selectFirstTool();
    colorPicker.show();
  }

  @override
  void refresh() {
    graphics.clear();
    graphics.rect(0, 0, width, height);
    graphics.fillColor(_backgroundColor);

    _menu.width = width;

    resetCanvasZoomAndPosition();

    propertyWindow
      ..x = width - propertyWindow.width - 5
      ..y = _menu.height + 5;

    toolbox
      ..x = 5
      ..y = _menu.height + 5;

    // if(ColorPicker.instance.x == 0 && ColorPicker.instance.y == 0) {
    //   ColorPicker.instance
    //     ..x = propertyWindow.x - ColorPicker.instance.width - 5
    //     ..y = propertyWindow.y;
    // }

    DialogLayer.relayout();
  }

  ///resets the canvas back to the default size and centers it
  static void resetCanvasZoomAndPosition() {
    Rectangle rect = aspectFitChildInsideParent(_instance.width, _instance.height - _menu.height, canvas.canvasWidth, canvas.canvasHeight, padding: 20);
    
    canvas
      ..x = rect.left
      ..y = rect.top + _menu.height
      ..setSize(rect.width, rect.height); 
  }
}
