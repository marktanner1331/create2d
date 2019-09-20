import 'package:stagexl/stagexl.dart';
import '../helpers/SetSizeMixin.dart';
import '../Styles.dart';

class ToolboxButton extends Sprite with SetSizeMixin {
  DisplayObject _child;

  bool _isHovered = false;
  bool _isSelected = false;

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

  void set isSelected(bool value) {
    _isSelected = value;
    _redrawBG();
  }

  void _redrawBG() {
    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, width, height)
      ..fillColor(
          _isHovered || _isSelected ? Styles.toolButtonHovered : Styles.toolButtonUnhovered)
      ..closePath()
      ..rect(1, 1, width - 2, height - 2)
      ..strokeColor(0xff000000, 1);
  }

  @override
  void refresh() {
    _redrawBG();

    num paddedWidth = width - 2;
    num paddedHeight = height - 2;

    num ratio1 = paddedWidth / paddedHeight;
    num ratio2 = _child.width / _child.height;

    if (ratio1 < ratio2) {
      _child.scaleX = _child.scaleY = (paddedWidth / _child.width);
    } else {
      _child.scaleX = _child.scaleY = (paddedHeight / _child.height);
    }

    _child.x = (width - _child.width * _child.scaleX) / 2;
    _child.y = (height - _child.height * _child.scaleY) / 2;
  }
}
