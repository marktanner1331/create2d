import 'package:stagexl/stagexl.dart';

class NumberFieldWithLabel extends Sprite {
  static const String VALUE_CHANGED = "VALUE_CHANGED";

  static const EventStreamProvider<Event> _valueChangedEvent =
      const EventStreamProvider<Event>(VALUE_CHANGED);

  EventStream<Event> get onValueChanged => _valueChangedEvent.forTarget(this);

  num _value = 0;
  num get value => _value;
  void set value(num value) {
    _value = value;
    _valueField.text = value.toString();
  }

  TextField _valueField;
  TextField _labelField;

  NumberFieldWithLabel(String labelText) {
    if(labelText.endsWith(":") == false) {
      labelText += ":";
    }

    _labelField = TextField(labelText);
    _labelField
      ..width = _labelField.textWidth
      ..height = _labelField.textHeight;
    addChild(_labelField);

    _valueField = TextField()
      ..textColor = 0xff000000
      ..onMouseClick.listen(_onClick)
      ..type = TextFieldType.INPUT
      ..text = "0000"
      ..backgroundColor = 0xffffffff
      ..background = true
      ..border = true
      ..borderColor = 0xff000000
      ..mouseCursor = MouseCursor.TEXT
      ..onTextInput.listen(_onTextInput);

    TextFormat tf = _valueField.defaultTextFormat
      ..align = TextFormatAlign.CENTER
      ..verticalAlign = TextFormatVerticalAlign.CENTER;
    
    _valueField
      ..defaultTextFormat = tf
      ..x = _labelField.width + 5
      ..width = _valueField.textWidth + 5
      ..height = _valueField.textHeight + 5;
    
    addChild(_valueField);
    
    _labelField.y = (_valueField.height - _labelField.height) / 2;
  }

  void _onClick(MouseEvent e) {
    stage.focus = _valueField;
  }

  void _onTextInput(TextEvent event) {
    _valueField.text = _valueField.text.replaceAll(new RegExp(r"[^\d]"), "");
    _value = num.parse(_valueField.text);

    dispatchEvent(Event(VALUE_CHANGED));
  }
}
