import 'package:stagexl/stagexl.dart';
import 'package:meta/meta.dart';

import './PropertyGroupHeader.dart';

abstract class PropertyGroup extends Sprite {
  static const String IS_OPEN_CHANGED = "IS_OPEN_CHANGED";

  static const EventStreamProvider<Event> _isOpenChangedEvent =
      const EventStreamProvider<Event>(IS_OPEN_CHANGED);

  EventStream<Event> get onIsOpenChanged =>
      _isOpenChangedEvent.forTarget(this);

  bool _isOpen = false;
  bool get isOpen => _isOpen;
  void set isOpen(bool value) {
    _isOpen = value;
    _isOpenChanged();
  }

  String _title;
  String get title => _title;

  PropertyGroupHeader _header;
  Sprite _inner;

  num _preferredWidth;
  num get preferredWidth => _preferredWidth;
  void set preferredWidth(num value) {
    _preferredWidth = value;
    _redraw();
  }

  PropertyGroup(String title, num preferredWidth) {
    _title = title;
    _preferredWidth = preferredWidth;

    _header = PropertyGroupHeader(this);
    _header.onMouseClick.listen(_onHeaderClick);
    super.addChild(_header);
     _header.redraw();

    _inner = Sprite();
    _inner.y = _header.preferredHeight;
  }

  void _onHeaderClick(_) {
    isOpen = !isOpen;
  }

  @override
  void addChild(DisplayObject child) {
    _inner.addChild(child);
  }

  void _isOpenChanged() {
    _header.redraw();
    
    if(isOpen) {
      super.addChild(_inner);
    } else {
      if(_inner.parent != null) {
        super.removeChild(_inner);
      }
    }

    dispatchEvent(Event(IS_OPEN_CHANGED));
  }

  void _redraw() {
    relayout();
  }

  @protected
  void relayout();
}