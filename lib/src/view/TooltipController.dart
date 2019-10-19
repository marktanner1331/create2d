import 'dart:html' as html;
import 'dart:async';

import 'package:stagexl/stagexl.dart';

class TooltipController {
  static html.Element _tooltip;
  static Map<InteractiveObject, String> _tooltipTextMap;

  static StreamSubscription<html.MouseEvent> _documentMoveSubscription;

  TooltipController() {
    _tooltip = html.document.querySelector("#tooltip")
      ..style.display = "none";
    
    _tooltipTextMap = Map();
  }

  static void addTooltip(InteractiveObject child, String tooltip) {
    _tooltipTextMap[child] = tooltip;
    child.onMouseOver.listen(_onMouseOver);
    child.onMouseOut.listen(_onMouseOut);
  }

  static void _onMouseOver(MouseEvent e) {
    _tooltip
      ..innerHtml = _tooltipTextMap[e.currentTarget];

    _tooltip.style
      ..left = "${e.stageX}px"
      ..top = "${e.stageY + 20}px"
      ..display = "block";

    //just in case of some random race condition
    _documentMoveSubscription?.cancel();
    
    _documentMoveSubscription = html.document.onMouseMove.listen(_onMouseMove);
  }

  static void _onMouseOut(_) {
    _tooltip.style.display = "none";

    _documentMoveSubscription?.cancel();
    _documentMoveSubscription = null;
  }

  static _onMouseMove(html.MouseEvent e) {
    Point mousePos = e.page;
      _tooltip.style.left = "${mousePos.x}px";
      _tooltip.style.top = "${mousePos.y}px";
  }
}