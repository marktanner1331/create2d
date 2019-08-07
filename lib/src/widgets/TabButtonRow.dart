import 'package:stagexl/stagexl.dart';
import './TabButton.dart';

class TabButtonRow extends Sprite {
  static const String TAB_CHANGED = "TAB_CHANGED";

  static const EventStreamProvider<Event> _tabChangedEvent =
      const EventStreamProvider<Event>(TAB_CHANGED);

  EventStream<Event> get onTabChanged =>
      _tabChangedEvent.forTarget(this);

  List<TabButton> _tabs;
  TabButton _selected;

  String get selectedTabModelName => _selected?.modelText;

  TabButtonRow() {
    _tabs = List();
  }

  ///does not fire any eeents
  void switchToTab(String modelName) {
    if(_selected != null) {
      if(_selected.modelText == modelName) {
        return;
      } else {
        _selected.isSelected = false;
      }
    }

    _selected = _tabs.firstWhere((tab) => tab.modelText == modelName);
    _selected.isSelected = true;
  }

  void addTab(String modelName, String displayName) {
    TabButton tab = TabButton(modelName, displayName);
    tab.onMouseClick.listen(_onTabButtonClick);

    _tabs.add(tab);
    addChild(tab);

    _refresh();
  }

  void _onTabButtonClick(MouseEvent e) {
    assert(e.currentTarget is TabButton);
    TabButton clickedTab = e.currentTarget as TabButton;

    if(_selected != null) {
      if(_selected == clickedTab) {
        return;
      } else {
        _selected.isSelected = false;
      }
    }

    _selected = clickedTab;
    _selected.isSelected = true;

    dispatchEvent(Event(TAB_CHANGED));
  }

  void _refresh() {
    num deltaX = 0;
    for(TabButton tab in _tabs) {
      tab.x = deltaX;
      deltaX += tab.width;
    }
  }
}