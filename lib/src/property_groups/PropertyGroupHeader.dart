import 'package:stagexl/stagexl.dart';

import '../Styles.dart';
import './PropertyGroup.dart';

class PropertyGroupHeader extends Sprite {
  TextField _titleField;

  num get preferredHeight => _titleField.height;
  PropertyGroup _myGroup;

  bool _isHovered = false;

  PropertyGroupHeader(PropertyGroup group) {
    _myGroup = group;

    _titleField = TextField()
      ..textColor = Styles.groupHeadText
      ..text = group.title
      ..mouseEnabled = false
      ..autoSize = TextFieldAutoSize.NONE;

    _titleField
      ..x = _titleField.textHeight + 5
      ..width = _titleField.textWidth
      ..height = _titleField.textHeight;

    addChild(_titleField);

    mouseCursor = MouseCursor.POINTER;

    onMouseOver.listen((Event e) {
      _isHovered = true;
      redraw();
    });

    onMouseOut.listen((Event e) {
      _isHovered = false;
      redraw();
    });
  }

  void redraw() {
    num barHeight = preferredHeight;

    int bgColor;
    if (_myGroup.isOpen || _isHovered) {
      bgColor = Styles.groupHeadHovered;
    } else {
      bgColor = Styles.groupHeadUnhovered;
    }

    graphics
      ..beginPath()
      ..rectRound(0, 0, _myGroup.preferredWidth, barHeight, barHeight / 4,
          barHeight / 4)
      ..fillColor(bgColor)
      ..closePath();

    if (_myGroup.isOpen) {
      graphics
        ..beginPath()
        ..moveTo(0.33 * barHeight, 0.25 * barHeight)
        ..lineTo(1.00 * barHeight, 0.25 * barHeight)
        ..lineTo(0.67 * barHeight, 0.75 * barHeight)
        ..closePath()
        ..fillColor(Styles.groupHeadTriangle);
    } else {
      graphics
        ..beginPath()
        ..moveTo(0.50 * barHeight, 0.25 * barHeight)
        ..lineTo(1.00 * barHeight, 0.50 * barHeight)
        ..lineTo(0.50 * barHeight, 0.75 * barHeight)
        ..closePath()
        ..fillColor(Styles.groupHeadTriangle);
    }
  }
}
