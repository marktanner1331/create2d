import 'package:stagexl/stagexl.dart';
import '../widgets/Checkbox.dart';

class CheckboxWithLabel extends Sprite {
  static const String CHECK_CHANGED = "CHECK_CHANGED";

  static const EventStreamProvider<Event> _checkChangedEvent =
      const EventStreamProvider<Event>(CHECK_CHANGED);

  EventStream<Event> get onCheckChanged =>
      _checkChangedEvent.forTarget(this);

  Checkbox _checkbox;
  TextField _label;

  bool get checked => _checkbox.checked;
  set checked(bool value) => _checkbox.checked = value;

  CheckboxWithLabel(String text) {
    _label = TextField()
      ..text = text
      ..autoSize = TextFieldAutoSize.LEFT;
    this.addChild(_label);

    _label
      ..x = _label.height + 2
      ..y = 0;

    _checkbox = Checkbox();
    _checkbox
      ..width = _label.height
      ..height = _label.height;
    addChild(_checkbox);

    this
      ..mouseCursor = MouseCursor.POINTER
      ..mouseChildren = false
      ..onMouseClick.listen(_onClick);
  }

  void _onClick(_) {
    checked = !checked;
    dispatchEvent(Event(CHECK_CHANGED));
  }
}