import 'package:stagexl/stagexl.dart';

import '../../../helpers/SetSizeMixin.dart';
import '../ColorSwatch.dart';
import '../ColorPicker.dart';

abstract class ColorMixerGroup extends Sprite with SetSizeMixin {
  ColorPicker _colorPicker;

  TextField _titleLabel;
  List<ColorSwatch> _swatches;

  int _swatchesPerRow = 4;

  ColorMixerGroup(colorPicker, String title) {
    this._colorPicker = colorPicker;

    _titleLabel = TextField(title);
    _titleLabel
      ..width = _titleLabel.textWidth
      ..height = _titleLabel.textHeight;
    addChild(_titleLabel);

    _swatches = List();
  }

  ///the given color may have transparency
  ///it's up to the group to figure out if it needs it or not
  void refreshForColor(int color);

  ColorSwatch addSwatch() {
    ColorSwatch swatch = ColorSwatch(0xff000000, false);
    addChild(swatch);
    _swatches.add(swatch);

    swatch
      ..onMouseOver.listen(_onSwatchMouseOver)
      ..onMouseOut.listen(_onSwatchMouseOut)
      ..onMouseClick.listen(_onSwatchClick);

    return swatch;
  }
  
  void _onSwatchClick(MouseEvent e) {
    ColorSwatch swatch = e.currentTarget as ColorSwatch;
    _colorPicker.setSelectedPixelColor(swatch.color);
  }

  void _onSwatchMouseOver(MouseEvent e) {
    ColorSwatch swatch = e.currentTarget as ColorSwatch;
    _colorPicker.setPreviewPixelColor(swatch.color);
  }

  void _onSwatchMouseOut(_) {
    _colorPicker.setPreviewPixelColor(ColorPicker.currentColor);
  }

  @override
  void refresh() {
    _titleLabel
      ..x = 5
      ..y = 0;

    num swatchSize = _sizeOfSwatch(width);
    num deltaX = 5;
    num deltaY = _titleLabel.y + _titleLabel.height + 5;

    for(ColorSwatch swatch in _swatches) {
      swatch
        ..x = deltaX
        ..y = deltaY
        ..setSize(swatchSize, swatchSize);

      deltaX += swatchSize + 5;
      if(deltaX >= width) {
        deltaX = 5;
        deltaY += swatchSize + 5;
      }
    }
  }

  num _sizeOfSwatch(num panelWidth) {
    //account for padding
    panelWidth -= (_swatchesPerRow + 1) * 5;

    return panelWidth / _swatchesPerRow;
  }

  num preferredHeightForWidth(num width) {
    num swatchSize = _sizeOfSwatch(width);
    int rows = (_swatches.length / _swatchesPerRow).ceil();

    //account for padding
    return _titleLabel.y + _titleLabel.height + 5 + rows * (swatchSize + 5) + 5;
  }
}