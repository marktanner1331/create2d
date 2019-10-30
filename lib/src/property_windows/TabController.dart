import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL;

class TabController extends stageXL.EventDispatcher {
  List<MapEntry<Element, Element>> _tabs;

  static const String TAB_CHANGED = "TAB_CHANGED";

  final stageXL.EventStreamProvider<stageXL.Event> _tabChangedEvent =
      const stageXL.EventStreamProvider<stageXL.Event>(TAB_CHANGED);

  stageXL.EventStream<stageXL.Event> get onTabChangedChanged => _tabChangedEvent.forTarget(this);

  Element _currentTab;
  Element get currentTab => _currentTab;

  TabController() {
    _tabs = List();
  }

  void addTab(Element tabButton, Element tabContent) {
    tabButton.onClick.listen(_onTabButtonClick);
    
    _tabs.add(MapEntry(tabButton, tabContent));

    //show the first tab
    if(_tabs.length == 1) {
      _currentTab = tabContent;
      tabContent.style.display = "block";
    } else {
      tabContent.style.display = "none";
    }
  }

  void switchToFirstTab() => _tabs.first.key.click();

  void _onTabButtonClick(MouseEvent e) {
    Element tabButton = e.currentTarget as Element;

    for(MapEntry<Element, Element> tab in _tabs) {
      if(tabButton == tab.key) {
        tab.key.classes.add("tab_button_selected");
        tab.value.style.display = "block";
        _currentTab = tab.value;
      }else {
        tab.key.classes.remove("tab_button_selected");
        tab.value.style.display = "none";
      }
    }

    dispatchEvent(stageXL.Event(TAB_CHANGED));
  }
}