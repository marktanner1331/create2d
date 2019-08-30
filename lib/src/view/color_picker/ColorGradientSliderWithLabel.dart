import 'package:stagexl/stagexl.dart';

import './ColorGradientSlider.dart';
import '../../helpers/SetSizeMixin.dart';

class ColorGradientSliderWithLabel extends Sprite with SetSizeMixin {
  static const String VALUE_CHANGED = ColorGradientSlider.VALUE_CHANGED;
  static const String FINISHED_CHANGING = ColorGradientSlider.FINISHED_CHANGING;

  EventStream<Event> get onValueChanged => _slider.onValueChanged;
  EventStream<Event> get onFinishedChanging => _slider.onFinishedChanging;

  TextField _label;
  ColorGradientSlider _slider;

  ColorGradientSliderWithLabel(String labelText) {
    _label = TextField(labelText);
    _label
      ..width = _label.textWidth
      ..height = _label.textHeight
      ..defaultTextFormat = TextFormat("monospace", 12, 0xff000000);
    addChild(_label);

    _slider = ColorGradientSlider()
      ..x = _label.width + 5
      ..y = 2;
    addChild(_slider);
  }

  ///returns a value between 0 and 1
  num get value => _slider.value;

  void set value(num value) => _slider.value = value;

  void setColors(int start, int end) {
    _slider.setColors(start, end);
  }

  void setColors2(List<GraphicsGradientColorStop> colorStops) {
    _slider.setColors2(colorStops);
  }

  @override
  void refresh() {
    if(height == 0) {
      return;
    }

    _slider.setSize(width - _slider.x, height);
  }
}