import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';

import '../Styles.dart';

class CloseButton extends GraphicsButton {
  CloseButton() : super(redraw) {
    backgroundColor = Styles.button;
    hoveredColor = Styles.buttonHover;
    padding = 5;
    setSize(25, 25);
  }

  static void redraw(Graphics graphics, num width, num height) {
    graphics.clear();
    graphics.moveTo(0, 0);
    graphics.lineTo(width, height);

    graphics.moveTo(0, height);
    graphics.moveTo(width, 0);

    graphics.strokeColor(0xff000000);
  }
}