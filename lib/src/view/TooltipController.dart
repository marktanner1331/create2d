import 'dart:html' as html;
import 'dart:async';

import 'package:stagexl/stagexl.dart';

class TooltipController {
  static html.Element _tooltip;
  static Map<InteractiveObject, String> _stageXLTooltipTextMap;
  static Map<html.Element, String> _htmlTooltipTextMap;

  static StreamSubscription<html.MouseEvent> _documentMoveSubscription;

  TooltipController(html.Element view) {
    _tooltip = view..style.display = "none";

    _stageXLTooltipTextMap = Map();
    _htmlTooltipTextMap = Map();
  }

  static void addHTMLTooltip(html.Element element, String tooltip) {
    _htmlTooltipTextMap[element] = tooltip;
    element.onMouseEnter.listen(_onHTMLMouseOver);
    element.onMouseLeave.listen(_onMouseOut);
  }

  static void addStageXLTooltip(InteractiveObject child, String tooltip) {
    _stageXLTooltipTextMap[child] = tooltip;
    child.onMouseOver.listen(_onStageXLMouseOver);
    child.onMouseOut.listen(_onMouseOut);
  }

  static void _onHTMLMouseOver(html.MouseEvent e) {
  _showTooltip(_htmlTooltipTextMap[e.currentTarget],
        Point(e.page.x, e.page.y + 20));
  }

  static void _onStageXLMouseOver(MouseEvent e) {
    _showTooltip(_stageXLTooltipTextMap[e.currentTarget],
        Point(e.stageX, e.stageY + 20));
  }

  static void _showTooltip(String text, Point position) {
    _tooltip..innerHtml = text;

    _tooltip.style
      ..left = "${position.x}px"
      ..top = "${position.y}px"
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
    html.Point mousePos = e.page;
    _tooltip.style.left = "${mousePos.x}px";
    _tooltip.style.top = "${mousePos.y + 20}px";
  }
}
