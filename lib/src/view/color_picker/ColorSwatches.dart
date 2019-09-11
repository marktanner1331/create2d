import 'package:stagexl/stagexl.dart';

import './ColorSwatch.dart';
import './ColorPicker.dart';

import '../../widgets/TextButton.dart';
import '../../widgets/SelectableTextButton.dart';

import './ColorPickerTabMixin.dart';
import './EyeDropper.dart';

class ColorSwatches extends Sprite with ColorPickerTabMixin {
  ColorPicker _colorPicker;
  num _preferredWidth;

  TextField _eyeDropperlabel;
  SelectableTextButton _eyeDropper;

  TextField _label;
  TextButton _addSwatch;

  List<ColorSwatch> _swatches;

  //see _relayout() for why we have this
  num _mostRecentDeltaY = null;

  int _swatchesPerRow = 8;

  ColorSwatches(ColorPicker colorPicker, num preferredWidth) {
    this._colorPicker = colorPicker;
    this._preferredWidth = preferredWidth;

    _eyeDropperlabel = TextField("Eye Dropper");
    _eyeDropperlabel
      ..width = _eyeDropperlabel.textWidth
      ..height = _eyeDropperlabel.textHeight;
    addChild(_eyeDropperlabel);

    _eyeDropper = SelectableTextButton("Launch Eye Dropper");
    _eyeDropper.onSelectedChanged.listen(_onEyeDropperClick);
    addChild(_eyeDropper);

    _label = TextField("Swatches");
    _label
      ..width = _label.textWidth
      ..height = _label.textHeight;
    addChild(_label);

    _addSwatch = TextButton("Add Swatch");
    _addSwatch.onMouseClick.listen(_onAddSwatchClick);
    addChild(_addSwatch);

    _swatches = List();
  }

  void _onEyeDropperClick(_) {
    if(_eyeDropper.selected == false) {
      return;
    }

    EyeDropper dropper = EyeDropper(stage, _colorPicker);

    dropper.onFinished.listen((_) {
      dropper.dispose();
      _eyeDropper.selected = false;
    });

    dropper.start();
  }

  _onAddSwatchClick(_) {
    ColorSwatch swatch = ColorSwatch(ColorPicker.currentColor);

    swatch
      ..onMouseOver.listen(_onSwatchMouseOver)
      ..onMouseOut.listen(_onSwatchMouseOut)
      ..onMouseClick.listen(_onSwatchClick)
      ..onCloseClicked.listen(_onSwatchCloseClick);

    _swatches.add(swatch);
    addChild(swatch);

    _relayout(true);
  }

  void _onSwatchCloseClick(Event e) {
    ColorSwatch swatch = e.currentTarget as ColorSwatch;

    swatch
      ..onMouseClick.cancelSubscriptions()
      ..onMouseOver.cancelSubscriptions()
      ..onMouseOut.cancelSubscriptions()
      ..onCloseClicked.cancelSubscriptions();

    _swatches.remove(swatch);
    removeChild(swatch);

    _relayout(true);
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

  num _sizeOfSwatch(num panelWidth) {
    //account for padding
    panelWidth -= (_swatchesPerRow + 1) * 5;

    return panelWidth / _swatchesPerRow;
  }

  void _relayout(bool shouldInvalidateColorPickerHeight) {
    _label
      ..x = 5
      ..y = 5;

    num swatchSize = _sizeOfSwatch(_preferredWidth);
    num deltaX = 5;
    num deltaY = _label.y + _label.height + 5;

    for(ColorSwatch swatch in _swatches) {
      swatch
        ..x = deltaX
        ..y = deltaY
        ..setSize(swatchSize, swatchSize);

      deltaX += swatchSize + 5;
      if(deltaX >= _preferredWidth) {
        deltaX = 5;
        deltaY += swatchSize + 5;
      }
    }

    if(_swatches.length == 0) {
      deltaY += swatchSize + 5;
    }

    if(deltaX != 5) {
      deltaY += swatchSize + 5;
    }

    _addSwatch
      ..x = (_preferredWidth - _addSwatch.width) / 2
      ..y = deltaY;

    deltaY = _addSwatch.y + _addSwatch.height + 30;

    _eyeDropperlabel
      ..x = 5
      ..y = deltaY;

    deltaY = _eyeDropperlabel.y + _eyeDropperlabel.height + 5;
    
    _eyeDropper
      ..x = (_preferredWidth - _eyeDropper.width) / 2
      ..y = deltaY;

    deltaY = _eyeDropper.y + _eyeDropper.height + 5;

    //we check if the deltaY has changed since the last time we calculated it
    //if it has then we need to tell the _colorPicker
    if(_mostRecentDeltaY != deltaY) {
      _mostRecentDeltaY = deltaY;

      if(shouldInvalidateColorPickerHeight) {
        _colorPicker.invalidateHeight();
      }
    }
  }

  @override
  String get displayName => "Swatches";

  @override
  DisplayObject getDisplayObject() => this;

  @override
  // TODO: implement modelName
  String get modelName => "SWATCHES";

  @override
  void onEnter() {
    _relayout(false);
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }
}