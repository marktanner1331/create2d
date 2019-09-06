import 'package:stagexl/stagexl.dart';

import '../../helpers/SetSizeMixin.dart';
import '../../Styles.dart';

class ColorSwatchCloseButton extends Sprite with SetSizeMixin {
  ColorSwatchCloseButton() {
    mouseCursor = MouseCursor.POINTER;
  }

  @override
  void refresh() {
    graphics
      ..clear();

    graphics
      ..beginPath()
      ..rect(0, 0, width, height)
      ..closePath()
      ..fillColor(Styles.colorPickerCloseButtonUnhovered);

    graphics
      ..beginPath()
      ..moveTo(0, 0)
      ..lineTo(width, height)
      ..moveTo(0, height)
      ..lineTo(width, 0)
      ..closePath()
      ..strokeColor(Styles.colorPickerCloseButtonGraphics, 1);
  }
}