import 'package:stagexl/stagexl.dart';

import '../view/color_picker/ColorSwatch.dart';
import '../view/color_picker/ColorPicker.dart';
import '../helpers/IOnEnterExit.dart';

class ColorSwatchWithLabel extends Sprite implements IOnEnterExit {
  static const String COLOR_CHANGED = "COLOR_CHANGED";

  static const EventStreamProvider<Event> _colorChangedEvent =
      const EventStreamProvider<Event>(COLOR_CHANGED);

  EventStream<Event> get onColorChanged =>
      _colorChangedEvent.forTarget(this);

  EventStreamSubscription<Event> _colorPickerChangedSubscription;
  EventStreamSubscription<Event> _colorPickerClosedSubscription;

  ColorSwatch _swatch;
  TextField _label;

  int get color => _swatch.color;
  set color(int value) => _swatch.color = value;

  ColorSwatchWithLabel(String text) {
    _label = TextField()
      ..text = text;
    this.addChild(_label);

    _label
      ..width = _label.textWidth
      ..height = _label.textHeight;

    _swatch = ColorSwatch(0xff000000, false);
    _swatch
      ..setSize(20, 15)
      ..onMouseClick.listen(_onClick);
    addChild(_swatch);

    _label
      ..x = _swatch.width + 5
      ..y = 0;
  }

  void _onColorPickerChanged(_) {
    _swatch.color = ColorPicker.currentColor;
    dispatchEvent(Event(COLOR_CHANGED));
  }

  void _onColorPickerClosed(_) {
    _colorPickerChangedSubscription.cancel();
    _colorPickerClosedSubscription.cancel();
  }

  void _onClick(_) {
    //we hide it to begin with in case anything else is listening out for updates
    //we want to steal it completely, so we give them a chance to cancel themselves
    ColorPicker.hide();

    _colorPickerChangedSubscription = ColorPicker.onCurrentColorChanged.listen(_onColorPickerChanged);
    _colorPickerClosedSubscription = ColorPicker.onClosed.listen(_onColorPickerClosed);

    ColorPicker.show();
  }

  @override
  void onEnter() {
    
  }

  @override
  void onExit() {
    if(_colorPickerChangedSubscription != null) {
      ColorPicker.hide();
    }
  }
}