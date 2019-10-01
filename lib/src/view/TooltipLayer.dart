import 'package:stagexl/stagexl.dart';

class TooltipLayer extends Sprite {
  static TooltipLayer _instance;
  static TooltipLayer get instance => _instance;

  static Map<InteractiveObject, String> _tooltipTextMap;
  static TextField _tooltip;

  static EventStreamSubscription<MouseEvent> _mouseMoveSubscription;

  TooltipLayer() {
    assert(_instance == null);
    _instance = this;

    _tooltipTextMap = Map();
    _tooltip = TextField();
    
      TextFormat format = _tooltip.defaultTextFormat
      ..align = TextFormatAlign.CENTER
      ..verticalAlign = TextFormatVerticalAlign.CENTER
      ..bold = true
      ..leftMargin = 3
      ..rightMargin = 3
      ..color = 0xffffffff;

    _tooltip
      ..x = 5
      ..y = 2
      ..autoSize = TextFieldAutoSize.CENTER
      ..background = true
      ..backgroundColor = 0xaa000000
      ..border = true
      ..borderColor = 0xffffffff
      ..textColor = 0xffffffff
      ..defaultTextFormat = format
      ..mouseEnabled = false;

    addChild(_tooltip);
    _tooltip.visible = false;
  }

  static void addTooltip(InteractiveObject child, String tooltip) {
    _tooltipTextMap[child] = tooltip;
    child.onMouseOver.listen(_onMouseOver);
    child.onMouseOut.listen(_onMouseOut);
  }

  static void _onMouseOver(MouseEvent e) {
    _tooltip
      ..text = _tooltipTextMap[e.currentTarget]
      ..x = e.stageX
      ..y = e.stageY + 20
      ..visible = true;

    //just in case of some random race condition
    _mouseMoveSubscription?.cancel();
    _mouseMoveSubscription = _instance.stage.onMouseMove.listen(_onMouseMove);
  }

  static void _onMouseOut(_) {
    _tooltip
      ..visible = false;

    _mouseMoveSubscription?.cancel();
    _mouseMoveSubscription = null;
  }

  static _onMouseMove(MouseEvent e) {
    _tooltip
      ..x = e.stageX
      ..y = e.stageY + 20;
  }
}