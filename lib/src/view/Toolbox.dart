import 'package:stagexl/stagexl.dart';

import '../tools/LineTool.dart';
import '../tools/ITool.dart';

class Toolbox extends Sprite {
 LineTool _line;
  
  Toolbox() {
    _line = LineTool();
  }

  ITool get currentTool {
    return _line;
  }
}