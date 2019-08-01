import 'package:stagexl/stagexl.dart';

import './Canvas.dart';
import '../tools/Tools.dart';

class Toolbox extends Sprite {
  static LineTool _line;

  static Toolbox _instance;
  
  Toolbox() {
    assert(_instance == null);
    _instance = this;

    _line = LineTool();
  }

  static ITool get currentTool {
    return _line;
  }
}