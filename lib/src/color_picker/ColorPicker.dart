import 'dart:html';
import 'package:design2D/src/view/MainWindow.dart';
import 'package:stagexl/stagexl.dart' as stageXL;

import '../helpers/HTMLViewController.dart';
import '../helpers/Draggable.dart';
import '../property_windows/Tab.dart';
import '../property_windows/TabController.dart';

import './ColorPickerComponents.dart';
import './ColorPicker3D.dart';
import './ColorPickerPalette.dart';
import './ColorBox.dart';
import './ColorPickerMixer.dart';
import './ColorPickerSwatches.dart';

class ColorPicker with HTMLViewController {
  int get currentColor => _initialized ? _selectedBox.color : 0xff000000;

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

  final Element view;
  List<Tab> _tabs;

  Tab _currentTab;
  TabController _tabController;

  ColorBox _previewBox;
  ColorBox _selectedBox;

  bool _initialized = false;

  //this class is lazy initialized
  //everything is set up the first time it is shown
  ColorPicker(this.view) {
    
  }

  void initialize() {
    Draggable(view, view.querySelector(".title_bar"));

    _tabController = TabController()
      ..addTab(view.querySelector("#paletteButton"),
          view.querySelector("#paletteTab"))
      ..addTab(view.querySelector("#componentsButton"),
          view.querySelector("#componentsTab"))
      ..addTab(
          view.querySelector("#_3DButton"), view.querySelector("#_3DTab"))
      ..addTab(
          view.querySelector("#mixerButton"), view.querySelector("#mixerTab"))
      ..addTab(view.querySelector("#swatchesButton"),
          view.querySelector("#swatchesTab"))
      ..onTabChangedChanged.listen(_onTabChanged);

    _tabs = List();
    _tabs.add(ColorPickerComponents(view.querySelector("#componentsTab")));
    _tabs.add(ColorPicker3D(view.querySelector("#_3DTab")));
    _tabs.add(ColorPickerPalette(view.querySelector("#paletteTab")));
    _tabs.add(ColorPickerMixer(view.querySelector("#mixerTab")));
    _tabs.add(ColorPickerSwatches(view.querySelector("#swatchesTab")));

    _tabController.switchToFirstTab();

    _previewBox = ColorBox(view.querySelector("#previewBox"));
    _selectedBox = ColorBox(view.querySelector("#selectedBox"));

    //magic number here isn't great
    //but the color picker hasnt initialized enough to have
    //a real width yet
    x = MainWindow.propertyWindow.x - 275;
    y = MainWindow.propertyWindow.y;

    _initialized = true;
  }

  void _onTabChanged(_) {
    _currentTab?.onExit();
    _currentTab =
        _tabs.firstWhere((tab) => tab.view == _tabController.currentTab);
    _currentTab.onEnter();
  }

  void hide() {
    view.style.display = "none";
  }

  void show() {
    if (_initialized == false) {
      initialize();
    }

    view.style.display = "block";
  }

  void resetPreviewColor() {
    _previewBox.color = _selectedBox.color;
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
