import 'package:stagexl/stagexl.dart';

import './ColorPickerTabMixin.dart';
import './ColorPicker.dart';
import './ColorHelper.dart';
import './ColorGradientSliderWithLabel.dart';

class ColorComponents extends Sprite with ColorPickerTabMixin {
  num _preferredWidth;
  ColorPicker _colorPicker;

  TextField _hexLabel;
  TextField _hashLabel;
  TextField _hexBox;

  TextField _rgbLabel;
  ColorGradientSliderWithLabel _rSlider;
  ColorGradientSliderWithLabel _gSlider;
  ColorGradientSliderWithLabel _bSlider;

  TextField _hsvLabel;
  ColorGradientSliderWithLabel _hSlider;
  ColorGradientSliderWithLabel _sSlider;
  ColorGradientSliderWithLabel _vSlider;

  TextField _alphaLabel;
  ColorGradientSliderWithLabel _aSlider;

  ColorComponents(ColorPicker colorPicker, num preferredWidth) {
    this._colorPicker = colorPicker;
    _preferredWidth = preferredWidth;

    num deltaY = 5;

    _hexLabel = TextField("Hex Code:");
    _hexLabel
      ..x = 10
      ..width = _hexLabel.textWidth
      ..height = _hexLabel.textHeight;
    addChild(_hexLabel);

    _hashLabel = TextField("#");
    _hashLabel
      ..width = _hashLabel.textWidth
      ..height = _hashLabel.textHeight;
    addChild(_hashLabel);

    _hexBox = TextField()
      ..textColor = 0xff000000
      ..onMouseClick.listen(_onClick)
      ..type = TextFieldType.INPUT
      ..text = "00000000"
      ..backgroundColor = 0xffffffff
      ..background = true
      ..border = true
      ..borderColor = 0xff000000
      ..mouseCursor = MouseCursor.TEXT
      ..onTextInput.listen(_onTextInput);

    TextFormat tf = _hexBox.defaultTextFormat
      ..align = TextFormatAlign.CENTER
      ..verticalAlign = TextFormatVerticalAlign.CENTER;

    _hexBox
      ..defaultTextFormat = tf
      ..y = deltaY
      ..width = _hexBox.textWidth + 5
      ..height = _hexBox.textHeight + 5;

    addChild(_hexBox);

    _hashLabel.y = _hexBox.y + (_hexBox.height - _hashLabel.height) / 2;
    _hexLabel.y = _hexBox.y + (_hexBox.height - _hexLabel.height) / 2;

    _hexBox.x = preferredWidth - _hexBox.width - 10;
    _hashLabel.x = _hexBox.x - _hashLabel.width - 3;

    deltaY = _hexBox.y + _hexBox.height + 15;

    _rgbLabel = TextField("RGB");
    _rgbLabel
      ..x = 10
      ..y = deltaY
      ..width = _rgbLabel.textWidth
      ..height = _rgbLabel.textHeight;
    addChild(_rgbLabel);

    deltaY = _rgbLabel.y + _rgbLabel.height + 5;

    _rSlider = ColorGradientSliderWithLabel("R:")
      ..x = 10
      ..y = deltaY
      ..setSize(preferredWidth - 20, 22)
      ..onValueChanged.listen(_rgbSlidersChanged)
      ..onFinishedChanging.listen(_rgbSlidersFinished);
    addChild(_rSlider);

    deltaY = _rSlider.y + _rSlider.height + 10;

    _gSlider = ColorGradientSliderWithLabel("G:")
      ..x = 10
      ..y = deltaY
      ..setSize(preferredWidth - 20, 22)
      ..onValueChanged.listen(_rgbSlidersChanged)
      ..onFinishedChanging.listen(_rgbSlidersFinished);
    addChild(_gSlider);

    deltaY = _gSlider.y + _gSlider.height + 10;

    _bSlider = ColorGradientSliderWithLabel("B:")
      ..x = 10
      ..y = deltaY
      ..setSize(preferredWidth - 20, 22)
      ..onValueChanged.listen(_rgbSlidersChanged)
      ..onFinishedChanging.listen(_rgbSlidersFinished);
    addChild(_bSlider);

    deltaY = _bSlider.y + _bSlider.height + 5;
    deltaY += 15;

    _hsvLabel = TextField("HSV");
    _hsvLabel
      ..x = 10
      ..y = deltaY
      ..width = _hsvLabel.textWidth
      ..height = _hsvLabel.textHeight;
    addChild(_hsvLabel);

    deltaY = _hsvLabel.y + _hsvLabel.height + 5;

    _hSlider = ColorGradientSliderWithLabel("H:")
      ..x = 10
      ..y = deltaY
      ..setSize(preferredWidth - 20, 22)
      ..onValueChanged.listen(_hsvSlidersChanged)
      ..onFinishedChanging.listen(_hsvSlidersFinished)
      ..setColors2([
        GraphicsGradientColorStop(0, 0xffff0000),
        GraphicsGradientColorStop(1 / 6, 0xffffff00),
        GraphicsGradientColorStop(1 / 3, 0xff00ff00),
        GraphicsGradientColorStop(1 / 2, 0xff00ffff),
        GraphicsGradientColorStop(2 / 3, 0xff0000ff),
        GraphicsGradientColorStop(5 / 6, 0xffff00ff),
        GraphicsGradientColorStop(1, 0xffff0000),
      ]);
    addChild(_hSlider);

    deltaY = _hSlider.y + _hSlider.height + 10;

    _sSlider = ColorGradientSliderWithLabel("S:")
      ..x = 10
      ..y = deltaY
      ..setSize(preferredWidth - 20, 22)
      ..onValueChanged.listen(_hsvSlidersChanged)
      ..onFinishedChanging.listen(_hsvSlidersFinished);
    addChild(_sSlider);

    deltaY = _sSlider.y + _sSlider.height + 10;

    _vSlider = ColorGradientSliderWithLabel("V:")
      ..x = 10
      ..y = deltaY
      ..setSize(preferredWidth - 20, 22)
      ..onValueChanged.listen(_hsvSlidersChanged)
      ..onFinishedChanging.listen(_hsvSlidersFinished);
    addChild(_vSlider);

    deltaY = _vSlider.y + _vSlider.height + 5;
    deltaY += 15;

    _alphaLabel = TextField("Alpha/Opacity");
    _alphaLabel
      ..x = 10
      ..y = deltaY
      ..width = _alphaLabel.textWidth
      ..height = _alphaLabel.textHeight;
    addChild(_alphaLabel);

    deltaY = _alphaLabel.y + _alphaLabel.height + 5;

    _aSlider = ColorGradientSliderWithLabel("A:")
      ..x = 10
      ..y = deltaY
      ..setSize(preferredWidth - 20, 22)
      ..onValueChanged.listen(_aSliderChanged)
      ..onFinishedChanging.listen(_aSliderFinished);
    addChild(_aSlider);
  }

  void _aSliderFinished(_) {
    int color = _getColorFromRGBASliders();
    _colorPicker.setSelectedPixelColor(color);
  }

  void _rgbSlidersFinished(_) {
    int color = _getColorFromRGBASliders();
    _colorPicker.setSelectedPixelColor(color);
    _resetRGBGradients(color);
    _resetAGradient(color);
    _resetHSVSliders(color);
  }

  void _hsvSlidersFinished(_) {
    int color = _getColorFromHSVSliders();
    _colorPicker.setSelectedPixelColor(color);
    _resetRGBSliders(color);
    _resetAGradient(color);
    _resetHSVGradients(color);
  }

  void _aSliderChanged(_) {
    int alpha = (_aSlider.value * 0xff).toInt();

    int color = ColorPicker.currentColor;
    color = ColorHelper.setAlpha(color, alpha);

    _colorPicker.setPreviewPixelColor(color);
    _hexBox.text = ColorHelper.colorToHex(color);
  }

  void _hsvSlidersChanged(_) {
    int color = _getColorFromHSVSliders();
    _colorPicker.setPreviewPixelColor(color);
    _hexBox.text = ColorHelper.colorToHex(color);

    _resetRGBSliders(color);
    _resetAGradient(color);
    _resetHSVGradients(color);
  }

  void _rgbSlidersChanged(_) {
    int color = _getColorFromRGBASliders();

    _colorPicker.setPreviewPixelColor(color);
    _hexBox.text = ColorHelper.colorToHex(color);
    _resetRGBGradients(color);
    _resetAGradient(color);
    _resetHSVSliders(color);
  }

  int _getColorFromHSVSliders() {
    return ColorHelper.HSVtoRGB(_hSlider.value, _sSlider.value, _vSlider.value);
  }

  int _getColorFromRGBASliders() {
    int color = 0x00;

    color += (_aSlider.value * 0xff).toInt();
    color <<= 8;

    color += (_rSlider.value * 0xff).toInt();
    color <<= 8;

    color += (_gSlider.value * 0xff).toInt();
    color <<= 8;

    color += (_bSlider.value * 0xff).toInt();

    return color;
  }

  void _resetRGBGradients(int color) {
    color = ColorHelper.removeTransparency(color);

    _rSlider.setColors(color & 0xff00ffff, color | 0xffff0000);
    _gSlider.setColors(color & 0xffff00ff, color | 0xff00ff00);
    _bSlider.setColors(color & 0xffffff00, color | 0xff0000ff);
  }

  void _resetHSVGradients(int color) {
    List<num> hsv = ColorHelper.colorToHSVDecimals(color);

    //annoyingly we have to depend on the hSlider here
    //as a 'color' with no saturation will always have a hue of 0
    //even if its set differently in the slider
    //we therefore need to ensure that _resetHSVGradients() is never called before _resetHSVValues()
    if(hsv[0] == 0) {
      hsv[0] = _hSlider.value;
    }

    int minS = ColorHelper.HSVtoRGB(hsv[0], 0, hsv[2]);
    int maxS = ColorHelper.HSVtoRGB(hsv[0], 1, hsv[2]);
    _sSlider.setColors(minS, maxS);

    int minV = ColorHelper.HSVtoRGB(hsv[0], hsv[1], 0);
    int maxV = ColorHelper.HSVtoRGB(hsv[0], hsv[1], 1);
    _vSlider.setColors(minV, maxV);
  }

  void _resetHSVValues(int color) {
    List<num> hsv = ColorHelper.colorToHSVDecimals(color);

    _hSlider.value = hsv[0];
    _sSlider.value = hsv[1];
    _vSlider.value = hsv[2];
  }

  void _resetHSVSliders(int color) {
    _resetHSVValues(color);
    _resetHSVGradients(color);
  }

  void _resetRGBValues(int color) {
    _rSlider.value = ((color >> 16) & 0xff) / 0xff;
    _gSlider.value = ((color >> 8) & 0xff) / 0xff;
    _bSlider.value = (color & 0xff) / 0xff;
  }

  void _resetRGBSliders(int color) {
    _resetRGBGradients(color);
    _resetRGBValues(color);
  }

  void _resetAGradient(int color) {
    int low = ColorHelper.setAlpha(color, 0);
    int high = ColorHelper.setAlpha(color, 0xff);
    _aSlider.setColors(low, high);
  }

  void _resetAValue() {
    int current = ColorPicker.currentColor;

    _aSlider.value = ((current >> 24) & 0xff) / 0xff;
  }

  void _resetASlider(int color) {
    _resetAGradient(color);
    _resetAValue();
  }

  void _onClick(MouseEvent e) {
    stage.focus = _hexBox;
  }

  void _onTextInput(TextEvent event) {
    String text = _hexBox.text;
    text = text.replaceAll(new RegExp(r"[^0-9a-fA-F]"), "");

    _hexBox.text = text;

    if (text.length != 6 && text.length != 8) {
      return; //not finished writing hex value
    }

    if (text.length == 6) {
      text = "ff" + text;
    }

    int color = int.tryParse(text, radix: 16);
    if (color == null) {
      return;
    }

    _colorPicker.setSelectedPixelColor(color);
    onEnter();
  }

  @override
  String get displayName => "RGB";

  @override
  DisplayObject getDisplayObject() {
    return this;
  }

  @override
  String get modelName => "COMPONENTS";

  @override
  void onEnter() {
    int color = ColorPicker.currentColor;
    _hexBox.text = ColorHelper.colorToHex(color);
    _resetRGBSliders(color);
    _resetASlider(color);
    _resetHSVSliders(color);
  }

  @override
  void onExit() {}
}
