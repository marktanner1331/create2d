import 'package:stagexl/stagexl.dart';

import 'dart:math' show min, max;

import '../../helpers/DraggableController.dart';
import '../../helpers/SetSizeMixin.dart';

class ColorGradientSlider extends Sprite with SetSizeMixin {
  static const String VALUE_CHANGED = "VALUE_CHANGED";
  static const String FINISHED_CHANGING = "FINISHED_CHANGING";

  static const EventStreamProvider<Event> _valueChangedEvent =
      const EventStreamProvider<Event>(VALUE_CHANGED);
  static const EventStreamProvider<Event> _finishedChangingEvent =
      const EventStreamProvider<Event>(FINISHED_CHANGING);
  
  EventStream<Event> get onValueChanged =>
      _valueChangedEvent.forTarget(this);
  EventStream<Event> get onFinishedChanging => 
      _finishedChangingEvent.forTarget(this);

  GraphicsGradient _gradient;

  Sprite _slider;
  DraggableController _sliderController;

  ColorGradientSlider() {
    _gradient = GraphicsGradient.linear(0, 0, 100, 0);
    
    _slider = Sprite()
      ..mouseCursor = MouseCursor.POINTER;
    
    _slider.graphics
      ..beginPath()
      ..moveTo(-5, 10)
      ..lineTo(0, 0)
      ..lineTo(5, 10)
      ..closePath()
      ..fillColor(0xff000000);

      addChild(_slider);

      _sliderController = DraggableController(_slider, _slider)
        ..horizontal = true
        ..vertical = false
        ..minX = 0
        ..onPositionChanged.listen(_onSliderChanged)
        ..onFinishedDrag.listen(_onSliderFinished);

      onMouseClick.listen(_onMouseClick);
  }

  void _onMouseClick(_) {
    _slider.x = min(max(0, mouseX), width);
    dispatchEvent(Event(FINISHED_CHANGING));
  }

  ///returns a value between 0 and 1
  num get value {
    return min(max(0, _slider.x / width), 1);
  }

  void set value(num value) {
    _slider.x = width * value;
  }

  void _onSliderFinished(_) {
    dispatchEvent(Event(FINISHED_CHANGING));
  }

  void _onSliderChanged(_) {
    dispatchEvent(Event(VALUE_CHANGED));
  }

  void setColors(int start, int end) {
    _gradient
      ..colorStops.clear()
      ..addColorStop(0, start)
      ..addColorStop(1, end);
    
    refresh();
  }

  void setColors2(List<GraphicsGradientColorStop> colorStops) {
    _gradient.colorStops = colorStops;
  }

  @override
  void refresh() {
    if(height == 0) {
      return;
    }

    _slider.y = height - 10;

    _sliderController.maxX = width;
    _gradient.endX = width;

    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, width, height - 10)
      ..fillColor(0xffffffff)
      ..closePath();
    
    graphics
      ..beginPath()
      ..rect(0.5, 0.5, width - 1, height - 11)
      ..fillGradient(_gradient)
      ..closePath();
  }
}