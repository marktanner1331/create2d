import 'package:stagexl/stagexl.dart';

import '../Styles.dart';

abstract class PropertyWindow extends Sprite {
  Sprite _inner;
  Sprite get inner => _inner;

  TextField _titleLabel;

  PropertyWindow(String title) {
    _titleLabel = TextField()
      ..text = title
      ..autoSize = TextFieldAutoSize.NONE;
    
    _titleLabel
      ..width = _titleLabel.textWidth
      ..height = _titleLabel.textHeight;
    
    addChild(_titleLabel);
    
    _inner = Sprite();
    addChild(_inner);

    _refresh();
  }

  void _refresh() {
    graphics.clear();
    graphics.rect(0, 0, preferredWidth, _titleLabel.height);
    graphics.fillColor(Styles.panelHeadBG);
  }

  num get preferredWidth;
  num get preferredHeight;
}