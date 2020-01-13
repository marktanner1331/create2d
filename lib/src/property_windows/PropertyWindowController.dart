import 'dart:html';

import './CanvasTab.dart';
import './ContextTab.dart';
import './Tab.dart';

import '../helpers/Draggable.dart';
import './TabController.dart';
import '../helpers/HTMLViewController.dart';

class PropertyWindowController with HTMLViewController {
  final Element view;
  List<Tab> _tabs;

  Tab _currentTab;
  TabController _tabController;

  PropertyWindowController(this.view) {
    Draggable(view, view.querySelector(".title_bar"));

    Element closeButton = view.querySelector(".close_button");
    closeButton.onClick.listen(_onCloseButtonClick);

    _tabController = TabController()
      ..addTab(view.querySelector("#canvasTabButton"), view.querySelector("#canvasTab"))
      ..addTab(view.querySelector("#contextTabButton"), view.querySelector("#contextTab"))
      ..onTabChangedChanged.listen(_onTabChanged);

    _tabs = List();
    _tabs.add(CanvasTab(view.querySelector("#canvasTab")));
    _tabs.add(ContextTab(view.querySelector("#contextTab")));

    _tabController.switchToFirstTab();
  }

  void _onCloseButtonClick(_) {
    view.style.display = "none";
  }

  void refreshCurrentTab() {
    _currentTab?.onExit();
    _currentTab?.onEnter();
  }

  void _onTabChanged(_) {
    _currentTab?.onExit();
    _currentTab = _tabs.firstWhere((tab) => tab.view == _tabController.currentTab);
    _currentTab.onEnter();
  }
}