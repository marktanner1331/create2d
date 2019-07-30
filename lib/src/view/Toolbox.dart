import 'package:stagexl/stagexl.dart';

import './Canvas.dart';
import '../tools/Tools.dart';

class Toolbox extends Sprite {
  LineTool _line;

  Toolbox(Canvas canvas) {
    _line = LineTool(canvas);
  }

  ITool get currentTool {
    return _line;
  }
}