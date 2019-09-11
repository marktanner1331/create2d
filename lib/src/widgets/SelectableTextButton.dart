import 'package:stagexl/stagexl.dart';
import '../Styles.dart';

class SelectableTextButton extends Sprite {
  static const String SELECTED_CHANGED = "SELECTED_CHANGED";

  static const EventStreamProvider<Event> _selectedChangedEvent =
      const EventStreamProvider<Event>(SELECTED_CHANGED);

  EventStream<Event> get onSelectedChanged => _selectedChangedEvent.forTarget(this);

  bool _isHovered = false;

  bool _selected = false;
  bool get selected => _selected;
  void set selected(bool value) {
    _selected = value;
    _refresh();
  }

  TextField _label;

  SelectableTextButton(String text) {
    _label = TextField();

    TextFormat format = _label.defaultTextFormat
      ..align = TextFormatAlign.CENTER
      ..verticalAlign = TextFormatVerticalAlign.CENTER
      ..bold = true
      ..color = 0xffffffff;

    _label
      ..x = 5
      ..y = 2
      ..textColor = Styles.buttonText
      ..defaultTextFormat = format
      ..mouseEnabled = false
      ..text = text;
    _label
      ..width = _label.textWidth
      ..height = _label.textHeight;

    addChild(_label);

    mouseCursor = MouseCursor.POINTER;

    onMouseOver.listen((Event e) {
      _isHovered = true;
      _refresh();
    });

    onMouseOut.listen((Event e) {
      _isHovered = false;
      _refresh();
    });

    onMouseClick.listen((MouseEvent e) {
      e.stopImmediatePropagation();
      
      _selected = ! _selected;
      _refresh();
      dispatchEvent(Event(SELECTED_CHANGED));
    });

    _refresh();
  }

  void _refresh() {
    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, _label.width + 10, height);

    if (_isHovered || _selected) {
      graphics.fillColor(Styles.buttonHovered);
    } else {
      graphics.fillColor(Styles.buttonUnhovered);
    }

    graphics.closePath();
  }
}
