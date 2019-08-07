import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';

import './Toolbox.dart';
import './Canvas.dart';
import '../property_windows/TabbedPropertyWindow.dart';

class MainWindow extends Sprite with RefreshMixin, SetSizeAndPositionMixin {
  int _backgroundColor = 0xff3333aa;

  static Canvas _canvas;
  static Canvas get currentCanvas => _canvas;

  Toolbox _toolbox;
  TabbedPropertyWindow _propertyWindow;

  static MainWindow _instance;

  MainWindow() {
    assert(_instance == null);
    _instance = this;

    _canvas = Canvas();
    addChild(_canvas);

    _toolbox = Toolbox();

    _propertyWindow = TabbedPropertyWindow();
    addChild(_propertyWindow);
  }

  @override
  void refresh() {
    graphics.clear();
    graphics.rect(0, 0, width, height);
    graphics.fillColor(_backgroundColor);
    _resetCanvasZoomAndPosition();
  }

  ///resets the canvas back to the default size and centers it
  void _resetCanvasZoomAndPosition() {
    num padding = 20;

    num ratioX = (width - 2 * padding) / currentCanvas.canvasWidth;
    num ratioY = (height - 2 * padding) / currentCanvas.canvasHeight;

    if(ratioX < ratioY) {
      currentCanvas.scaleX = ratioX;
      currentCanvas.scaleY = ratioX;
      currentCanvas.x = padding;
      currentCanvas.y = (height - currentCanvas.height) / 2;
    } else {
      currentCanvas.scaleX = ratioY;
      currentCanvas.scaleY = ratioY;
      currentCanvas.x = (width - currentCanvas.width) / 2;
      currentCanvas.y = padding;
    }
  }
}