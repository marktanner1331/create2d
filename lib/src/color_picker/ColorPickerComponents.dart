import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import '../property_windows/Tab.dart';
import './ColorGradientSliderWithLabel.dart';
import '../helpers/ColorHelper.dart';
import '../view/MainWindow.dart';

class ColorPickerComponents extends Tab {
  html.InputElement _hexBox;
  RenderLoop _renderLoop;
  Stage _stage;

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

  ColorPickerComponents(html.Element view) : super(view) {
    
  }

  @override
  void initialize() {
    _hexBox = view.querySelector("#hexBox") as html.InputElement;
    _hexBox.onInput.listen(_onTextInput);

    StageOptions options = StageOptions()
      ..backgroundColor = 0xff222222
      ..renderEngine = RenderEngine.WebGL
      ..stageAlign = StageAlign.TOP_LEFT
      ..stageScaleMode = StageScaleMode.NO_SCALE;

    html.CanvasElement canvas =
        view.querySelector('#componentsCanvas') as html.CanvasElement;

    canvas.width = 250;
    canvas.height = 300;

    _stage = Stage(canvas, width: 250, height: 300, options: options);
    _renderLoop = RenderLoop();
    
    num deltaY = 0;

    _rgbLabel = TextField("RGB");
    _rgbLabel
      ..x = 5
      ..y = deltaY
      ..textColor = 0xffffffff
      ..width = _rgbLabel.textWidth
      ..height = _rgbLabel.textHeight;
    _stage.addChild(_rgbLabel);

    deltaY = _rgbLabel.y + _rgbLabel.height + 5;

    _rSlider = ColorGradientSliderWithLabel("R:")
      ..x = 5
      ..y = deltaY
      ..setSize(240, 22)
      ..onValueChanged.listen(_rgbSlidersChanged)
      ..onFinishedChanging.listen(_rgbSlidersFinished);
    _stage.addChild(_rSlider);

    deltaY = _rSlider.y + _rSlider.height + 10;

    _gSlider = ColorGradientSliderWithLabel("G:")
      ..x = 5
      ..y = deltaY
      ..setSize(240, 22)
      ..onValueChanged.listen(_rgbSlidersChanged)
      ..onFinishedChanging.listen(_rgbSlidersFinished);
    _stage.addChild(_gSlider);

    deltaY = _gSlider.y + _gSlider.height + 10;

    _bSlider = ColorGradientSliderWithLabel("B:")
      ..x = 5
      ..y = deltaY
      ..setSize(240, 22)
      ..onValueChanged.listen(_rgbSlidersChanged)
      ..onFinishedChanging.listen(_rgbSlidersFinished);
    _stage.addChild(_bSlider);

    deltaY = _bSlider.y + _bSlider.height + 5;
    deltaY += 15;

    _hsvLabel = TextField("HSV");
    _hsvLabel
      ..x = 5
      ..y = deltaY
      ..textColor = 0xffffffff
      ..width = _hsvLabel.textWidth
      ..height = _hsvLabel.textHeight;
    _stage.addChild(_hsvLabel);

    deltaY = _hsvLabel.y + _hsvLabel.height + 5;

    _hSlider = ColorGradientSliderWithLabel("H:")
      ..x = 5
      ..y = deltaY
      ..setSize(240, 22)
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
    _stage.addChild(_hSlider);

    deltaY = _hSlider.y + _hSlider.height + 10;

    _sSlider = ColorGradientSliderWithLabel("S:")
      ..x = 5
      ..y = deltaY
      ..setSize(240, 22)
      ..onValueChanged.listen(_hsvSlidersChanged)
      ..onFinishedChanging.listen(_hsvSlidersFinished);
    _stage.addChild(_sSlider);

    deltaY = _sSlider.y + _sSlider.height + 10;

    _vSlider = ColorGradientSliderWithLabel("V:")
      ..x = 5
      ..y = deltaY
      ..setSize(240, 22)
      ..onValueChanged.listen(_hsvSlidersChanged)
      ..onFinishedChanging.listen(_hsvSlidersFinished);
    _stage.addChild(_vSlider);

    deltaY = _vSlider.y + _vSlider.height + 5;
    deltaY += 15;

    _alphaLabel = TextField("Alpha/Opacity");
    _alphaLabel
      ..x = 5
      ..y = deltaY
      ..textColor = 0xffffffff
      ..width = _alphaLabel.textWidth
      ..height = _alphaLabel.textHeight;
    _stage.addChild(_alphaLabel);

    deltaY = _alphaLabel.y + _alphaLabel.height + 5;

    _aSlider = ColorGradientSliderWithLabel("A:")
      ..x = 5
      ..y = deltaY
      ..setSize(240, 22)
      ..onValueChanged.listen(_aSliderChanged)
      ..onFinishedChanging.listen(_aSliderFinished);
    _stage.addChild(_aSlider);
  }

  void _onTextInput(_) {
    int color = ColorHelper.parseHexColor(_hexBox.value);
    if(color == null) {
      return;
    }

    MainWindow.colorPicker.setSelectedPixelColor(color);
    onEnter();
  }

  void _aSliderFinished(_) {
    int color = _getColorFromRGBASliders();
    MainWindow.colorPicker.setSelectedPixelColor(color);
    _hexBox.value = ColorHelper.colorToHex(color);
  }

  void _rgbSlidersFinished(_) {
    int color = _getColorFromRGBASliders();
    MainWindow.colorPicker.setSelectedPixelColor(color);
    _hexBox.value = ColorHelper.colorToHex(color);
    _resetRGBGradients(color);
    _resetAGradient(color);
    _resetHSVSliders(color);
  }

  void _hsvSlidersFinished(_) {
    int color = _getColorFromHSVSliders();
    _hexBox.value = ColorHelper.colorToHex(color);
    MainWindow.colorPicker.setSelectedPixelColor(color);
    _resetRGBSliders(color);
    _resetAGradient(color);
    _resetHSVGradients(color);
  }

  void _aSliderChanged(_) {
    int alpha = (_aSlider.value * 0xff).toInt();

    int color = MainWindow.colorPicker.currentColor;
    color = ColorHelper.setAlpha(color, alpha);

    MainWindow.colorPicker.setPreviewPixelColor(color);
    _hexBox.value = ColorHelper.colorToHex(color);
  }

  void _hsvSlidersChanged(_) {
    int color = _getColorFromHSVSliders();
    MainWindow.colorPicker.setPreviewPixelColor(color);
    _hexBox.value = ColorHelper.colorToHex(color);

    _resetRGBSliders(color);
    _resetAGradient(color);
    _resetHSVGradients(color);
  }

  void _rgbSlidersChanged(_) {
    int color = _getColorFromRGBASliders();

    MainWindow.colorPicker.setPreviewPixelColor(color);
    _hexBox.value = ColorHelper.colorToHex(color);
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
    if (hsv[0] == 0) {
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
    int current = MainWindow.colorPicker.currentColor;

    _aSlider.value = ((current >> 24) & 0xff) / 0xff;
  }

  void _resetASlider(int color) {
    _resetAGradient(color);
    _resetAValue();
  }

  @override
  void onEnter() {
    super.onEnter();
    int color = MainWindow.colorPicker.currentColor;
    _hexBox.value = ColorHelper.colorToHex(color);
    _resetRGBSliders(color);
    _resetASlider(color);
    _resetHSVSliders(color);

    if(_stage.renderLoop == null) {
      _renderLoop.addStage(_stage);
    }
  }

  @override
  void onExit() {
    _renderLoop.removeStage(_stage);
  }
}
