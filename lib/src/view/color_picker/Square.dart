import 'package:stagexl/stagexl.dart';
import 'dart:math';

import './ColorHelper.dart';

class Square extends Sprite {
  final int index;
  final num hue;

  num _width = 100;
  num _margin = 3;

  Square(this.index, this.hue) {
    graphics.clear();

    graphics
      ..beginPath()
      ..rect(0, 0, _width, _width)
      ..fillColor(0xff000000)
      ..closePath();

    graphics
      ..beginPath()
      ..rect(1, 1, _width - 2, _width - 2)
      ..fillColor(0xffffffff)
      ..closePath();

    num tileCount = 50;

    num innerWidth = _width - 2 * _margin;
    num step = 1 / tileCount;
    num tileWidth = innerWidth / tileCount;

    for (num j = 0; j < 1; j += step) {
      for (num i = 0; i < 1; i += step) {
        graphics
          ..beginPath()
          ..rect(_margin + i * innerWidth, _margin + j * innerWidth, tileWidth, tileWidth)
          ..fillColor(ColorHelper.HSVtoRGB(hue, j, 1 - i))
          ..closePath();
      }
    }
  }

  ///returns the current color under the mouse, or null if the mouse is outside the bounds of the array
  int getColorUnderMouse() {
    Point mousePos = mousePosition;

    if(mousePos.x < 0 || mousePos.x > _width) {
      return null;
    } else if(mousePos.y < 0 || mousePos.y > _width) {
      return null;
    }

    //we clamp it to the colored area
    //so that a user can click on the white border, and still get a valid color
    mousePos.x = max(min(_width - _margin, mousePos.x), _margin);
    mousePos.y = max(min(_width - _margin, mousePos.y), _margin);

    num deltaX = (mousePos.x - _margin) / (_width - 2 * _margin);
    num deltaY = (mousePos.y - _margin) / (_width - 2 * _margin);

    return ColorHelper.HSVtoRGB(hue, deltaY, 1 - deltaX);
  }
}
