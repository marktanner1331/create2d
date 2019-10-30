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

    _tabController = TabController()
      ..addTab(view.querySelector("#canvasTabButton"), view.querySelector("#canvasTab"))
      ..addTab(view.querySelector("#contextTabButton"), view.querySelector("#contextTab"))
      ..onTabChangedChanged.listen(_onTabChanged);

    _tabs = List();
    _tabs.add(CanvasTab(view.querySelector("#canvasTab")));
    _tabs.add(ContextTab(view.querySelector("#contextTab")));

    _tabController.switchToFirstTab();
  }

  void _onTabChanged(_) {
    _currentTab?.onExit();
    _currentTab = _tabs.firstWhere((tab) => tab.view == _tabController.currentTab);
    _currentTab.onEnter();
  }
}