import 'dart:html';
import './TabbedPropertyWindow.dart';
import './CanvasTab.dart';
import './ContextTab.dart';

class PropertyWindow extends TabbedPropertyWindow {
  PropertyWindow(Element div) : super(div) {
     CanvasTab(div.querySelector("#canvasTab"));
    ContextTab(div.querySelector("#contextTab"));
  }
}