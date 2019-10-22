import 'dart:html';

class TabController {
  List<MapEntry<Element, Element>> _tabs;

  TabController() {
    _tabs = List();
  }

  void addTab(Element tabButton, Element tabContent) {
    tabButton.onClick.listen(_onTabButtonClick);
    
    _tabs.add(MapEntry(tabButton, tabContent));

    //show the first tab
    if(_tabs.length == 1) {
      tabContent.style.display = "block";
    } else {
      tabContent.style.display = "none";
    }
  }

  void _onTabButtonClick(MouseEvent e) {
    Element tabButton = e.currentTarget as Element;

    for(MapEntry<Element, Element> tab in _tabs) {
      if(tabButton == tab.key) {
        tab.value.style.display = "block";
      }else {
        tab.value.style.display = "none";
      }
    }
  }
}