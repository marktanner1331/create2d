import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';

import './Toolbox.dart';
import './Canvas.dart';

import '../property_windows/TabbedPropertyWindow.dart';
import '../helpers/AspectFit.dart';

import '../property_windows/CanvasPropertiesWindow.dart';
import '../property_windows/ContextProperties.dart';

import './color_picker/ColorPicker.dart';

class MainWindow extends Sprite with RefreshMixin, SetSizeAndPositionMixin {
  int _backgroundColor = 0xff7ab1e3;

  static Canvas _canvas;
  static Canvas get canvas => _canvas;

  TabbedPropertyWindow _propertyWindow;

  static MainWindow _instance;

  MainWindow() {
    assert(_instance == null);
    _instance = this;

    _canvas = Canvas();
    addChild(_canvas);

    Toolbox();
    addChild(Toolbox.instance);

    _propertyWindow = TabbedPropertyWindow("Properties")
      ..addTab(CanvasPropertiesWindow())
      ..addTab(ContextPropertiesWindow())
      ..relayout()
      ..switchToFirstTab();
    addChild(_propertyWindow);

    ColorPicker();
    addChild(ColorPicker.instance);
    ColorPicker.hide();

    Toolbox.selectFirstTool();
  }

  @override
  void refresh() {
    graphics.clear();
    graphics.rect(0, 0, width, height);
    graphics.fillColor(_backgroundColor);

    _resetCanvasZoomAndPosition();

    _propertyWindow
      ..x = width - _propertyWindow.width - 5
      ..y = 5;

    Toolbox.instance
      ..x = 5
      ..y = 5;
  }

  ///resets the canvas back to the default size and centers it
  void _resetCanvasZoomAndPosition() {
    Rectangle rect = aspectFitChildInsideParent(width, height, canvas.canvasWidth, canvas.canvasHeight, padding: 20);
    
    canvas
      ..x = rect.left
      ..y = rect.top
      ..setSize(rect.width, rect.height); 
  }
}
