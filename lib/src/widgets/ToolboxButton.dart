import 'package:stagexl/stagexl.dart';
import '../helpers/SetSizeMixin.dart';
import '../Styles.dart';

class ToolboxButton extends Sprite with SetSizeMixin {
  DisplayObject _child;
  bool _isHovered = false;

  num _width;
  num _height;

  ToolboxButton(DisplayObject child) {
    this._child = child;
    addChild(_child);

    this.mouseChildren = false;
    this.mouseCursor = MouseCursor.POINTER;

    onMouseOver.listen((Event e) {
      _isHovered = true;
      _redrawBG();
    });

    onMouseOut.listen((Event e) {
      _isHovered = false;
      _redrawBG();
    });

    setSize(_child.width, _child.height);
  }

  void _redrawBG() {
    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, _width, _height)
      ..fillColor(
          _isHovered ? Styles.toolButtonHovered : Styles.toolButtonUnhovered)
      ..closePath()
      ..rect(0, 0, _width, _height)
      ..strokeColor(0xff000000, 2);
  }

  @override
  void setSize(num width, num height) {
    _width = width;
    _height = height;
    _redrawBG();

    num ratio1 = width / height;
    num ratio2 = _child.width / _child.height;

    if (ratio1 < ratio2) {
      _child.scaleX = _child.scaleY = (width / _child.width);
    } else {
      _child.scaleX = _child.scaleY = (height / _child.height);
    }

    _child.x = (width - _child.width) / 2;
    _child.y = (height - _child.height) / 2;
  }
}
