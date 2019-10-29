import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL;

import '../helpers/Draggable.dart';
import '../property_windows/Tab.dart';
import '../property_windows/TabController.dart';

import './CollorPickerWheel.dart';
import './ColorPickerComponents.dart';
import './ColorPicker3D.dart';
import './ColorBox.dart';

class ColorPicker {
  int get currentColor => _initialized ? _selectedBox.color : 0;

  stageXL.EventDispatcher _dispatcher = stageXL.EventDispatcher();
  
  static const String CURRENT_COLOR_CHANGED = "CURRENT_COLOR_CHANGED";
  static const String CLOSED = "COLOR_PICKER_CLOSED";

  final stageXL.EventStreamProvider<stageXL.Event> _currentColorChangedEvent =
      const stageXL.EventStreamProvider<stageXL.Event>(CURRENT_COLOR_CHANGED);
  final stageXL.EventStreamProvider<stageXL.Event> _closedEvent =
      const stageXL.EventStreamProvider<stageXL.Event>(CLOSED);

  stageXL.EventStream<stageXL.Event> get onCurrentColorChanged =>
      _currentColorChangedEvent.forTarget(_dispatcher);

  stageXL.EventStream<stageXL.Event> get onClosed =>
      _closedEvent.forTarget(_dispatcher);

  Element _view;
  List<Tab> _tabs;

  Tab _currentTab;
  TabController _tabController;

  ColorBox _previewBox;
  ColorBox _selectedBox;

  bool _initialized = false;

  //this class is lazy initialized
  //everything is set up the first time it is shown
  ColorPicker(Element view) {
    _view = view;
    hide();
  }

  void initialize() {
    _initialized = true;
    Draggable(_view, _view.querySelector(".title_bar"));

    _tabController = TabController()
      ..addTab(
          _view.querySelector("#wheelButton"), _view.querySelector("#wheelTab"))
      ..addTab(_view.querySelector("#componentsButton"),
          _view.querySelector("#componentsTab"))
      ..addTab(_view.querySelector("#_3DButton"),
          _view.querySelector("#_3DTab"))
      ..onTabChangedChanged.listen(_onTabChanged);

    _tabs = List();
    _tabs.add(ColorPickerWheel(_view.querySelector("#wheelTab")));
    _tabs.add(ColorPickerComponents(_view.querySelector("#componentsTab")));
    _tabs.add(ColorPicker3D(_view.querySelector("#_3DTab")));

    _currentTab = _tabs.first;
    _currentTab.onEnter();

    _previewBox = ColorBox(_view.querySelector("#previewBox"));
    _selectedBox = ColorBox(_view.querySelector("#selectedBox"));
  }

  void _onTabChanged(_) {
    _currentTab.onExit();
    _currentTab =
        _tabs.firstWhere((tab) => tab.view == _tabController.currentTab);
    _currentTab.onEnter();
  }

  void hide() {
    _view.style.display = "none";
  }

  void show() {
    if (_initialized == false) {
      initialize();
    }

    _view.style.display = "block";
  }

  void setPreviewPixelColor(int color) {
    _previewBox.color = color;
  }

  void setSelectedPixelColor(int color) {
    _previewBox.color = color;
    _selectedBox.color = color;
    _dispatcher.dispatchEvent(stageXL.Event(CURRENT_COLOR_CHANGED));
  }
}
