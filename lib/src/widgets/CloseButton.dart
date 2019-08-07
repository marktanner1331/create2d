import 'package:stagexl/stagexl.dart';
import 'package:stagexl_ui_components/ui_components.dart';

import '../Styles.dart';

class CloseButton extends GraphicsButton {
  CloseButton() : super(redraw) {
    unhoveredColor = Styles.closeButtonUnhovered;
    hoveredColor = Styles.closeButtonHovered;
    padding = 5;
    setSize(25, 25);
  }

  static void redraw(Graphics graphics, num width, num height) {
    graphics.clear();
    graphics.moveTo(0, 0);
    graphics.lineTo(width, height);

    graphics.moveTo(0, height);
    graphics.lineTo(width, 0);

    graphics.strokeColor(Styles.closeButtonGraphics, 3);
  }
}