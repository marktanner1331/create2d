import 'package:stagexl/stagexl.dart';

import './RadioButtonRow.dart';
import '../Styles.dart';

class RadioButtonGroup extends Sprite {
  static const String SELECTION_CHANGED = "SELECTION_CHANGED";

  static const EventStreamProvider<Event> _selectionChangedEvent =
      const EventStreamProvider<Event>(SELECTION_CHANGED);

  EventStream<Event> get onSelectionChanged =>
      _selectionChangedEvent.forTarget(this);

  List<RadioButtonRow> _rows;
  TextField _titleField;

  RadioButtonRow _selected = null;

  Object get selectedModelValue => _selected?.modelValue;

  RadioButtonGroup(String title) {
    _rows = List();

    _titleField = TextField(title)
      ..textColor = Styles.panelText
      ..autoSize = TextFieldAutoSize.LEFT;
    addChild(_titleField);
  }

  void switchToRow(Object modelValue) {
    if(_selected != null) {
      if(_selected.modelValue == modelValue) {
        return;
      } else {
        _selected.selected = false;
      }
    }

    for(RadioButtonRow row in _rows) {
      if(row.modelValue == modelValue) {
        _selected = row;
        _selected.selected = true;
        break;
      }
    }
  }

  void addRow(Object modelValue, String displayText) {
    RadioButtonRow row = RadioButtonRow(modelValue, displayText)
      ..onMouseClick.listen(_onRowClick);

    if(_rows.isEmpty) {
      row.y = _titleField.height;
    } else {
      row.y = _rows.last.y + _rows.last.height;
    }

    _rows.add(row);
    addChild(row);
  }

  void _onRowClick(MouseEvent e) {
    assert(e.currentTarget is RadioButtonRow);

    if(_selected != null) {
      _selected.selected = false;
    }

    _selected = e.currentTarget as RadioButtonRow;
    _selected.selected = true;

    dispatchEvent(Event(SELECTION_CHANGED));
  }
}