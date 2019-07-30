import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';

import '../tools/ITool.dart';
import './Toolbox.dart';
import './Canvas.dart';

class MainWindow extends Sprite with RefreshMixin, SetSizeAndPositionMixin {
  Toolbox _toolbox;
  Canvas _canvas;

  MainWindow() {
    _canvas = Canvas(this);
    addChild(_canvas);

    _toolbox = Toolbox(_canvas);
  }

  ITool get currentTool => _toolbox.currentTool;

  @override
  void refresh() {
    _canvas.setSize(width - 20, height - 20);
    _canvas.setPosition(10, 10);
  }
}