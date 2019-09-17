import 'package:stagexl/stagexl.dart';

import './ColorPickerTabMixin.dart';
import './ColorWheel.dart';
import './ColorComponents.dart';
import './Color3D.dart';
import './ColorBox.dart';
import './ColorPalette.dart';
import './ColorSwatches.dart';
import './ColorMixer.dart';

import '../../Styles.dart';

import '../../widgets/CloseButton.dart';
import '../../widgets/TabButtonRow.dart';
import '../../helpers/DraggableController.dart';

class ColorPicker extends Sprite {
  static ColorPicker _instance;
  static ColorPicker get instance => _instance;

  static int get currentColor => _instance._selectedBox.color;

  static const String CURRENT_COLOR_CHANGED = "CURRENT_COLOR_CHANGED";
  static const String CLOSED = "COLOR_PICKER_CLOSED";

  static const EventStreamProvider<Event> _currentColorChangedEvent =
      const EventStreamProvider<Event>(CURRENT_COLOR_CHANGED);
  static const EventStreamProvider<Event> _closedEvent =
      const EventStreamProvider<Event>(CLOSED);

  static EventStream<Event> get onCurrentColorChanged => _currentColorChangedEvent.forTarget(_instance);
  static EventStream<Event> get onClosed => _closedEvent.forTarget(_instance);
  
  static void hide()
  {
    _instance.dispatchEvent(Event(CLOSED));
    _instance.visible = false;
  }

  static void show() => _instance.visible = true;

  Sprite _titleBar;
  DraggableController _draggableController;

  TextField _titleLabel;
  CloseButton _closeButton;
  TabButtonRow _tabButtons;

  Map<String, ColorPickerTabMixin> _tabs;

  Sprite _inner;

  ColorBox _previewBox;
  ColorBox _selectedBox;

  num get preferredWidth => 275;
  num get preferredHeight => 500;

  ColorPicker() {
    assert(_instance == null);
    _instance = this;

    _titleBar = Sprite()
      ..mouseCursor = MouseCursor.POINTER;
    addChild(_titleBar);

    _draggableController = DraggableController(this, _titleBar);

    _titleLabel = TextField()
      ..x = 5
      ..y = 2
      ..text = "Color Picker"
      ..textColor = Styles.panelHeadText
      ..mouseEnabled = false
      ..autoSize = TextFieldAutoSize.NONE;
    
    _titleLabel
      ..width = _titleLabel.textWidth
      ..height = _titleLabel.textHeight;
    
    addChild(_titleLabel);

    _closeButton = CloseButton();
    _closeButton.onMouseClick.listen((_) => dispatchEvent(Event(CLOSED)));
    addChild(_closeButton);
    
    _tabButtons = TabButtonRow();
    _tabButtons
      ..x = 1
      ..onTabChanged.listen(_onTabButtonChanged);
    addChild(_tabButtons);

    _tabs = Map();

    _inner = Sprite();
    addChild(_inner);

    addTab(ColorWheel(this, preferredWidth));
    addTab(ColorComponents(this, preferredWidth));
    addTab(Color3D(this, preferredWidth));
    addTab(ColorPalette(this, preferredWidth));
    addTab(ColorSwatches(this, preferredWidth));
    addTab(ColorMixer(this, preferredWidth));

    num deltaY = 400;

    _previewBox = ColorBox("Preview Color")
      ..setSize(preferredWidth / 2 - 10, 75)
      ..x = 5;

    addChild(_previewBox);

    _selectedBox = ColorBox("Selected Color")
      ..setSize(preferredWidth / 2 - 10, 75)
      ..x = preferredWidth / 2 + 5;

    addChild(_selectedBox);

    relayout();
    switchToFirstTab();
  }

  void _resetHeight() {
    num deltaY = _inner.y + _inner.height + 25;

    _previewBox.y = deltaY;
    _selectedBox.y = deltaY;

    deltaY = _previewBox.y + _previewBox.height + 10;

    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, preferredWidth, deltaY)
      ..fillColor(Styles.panelBG)
      ..strokeColor(0xff000000, 0.5)
      ..closePath();
  }

  void setPreviewPixelColor(int color) {
    _previewBox.color = color;
  }

  void setSelectedPixelColor(int color) {
    _previewBox.color = color;
    _selectedBox.color = color;
    dispatchEvent(Event(CURRENT_COLOR_CHANGED));
  }
  
  void _onTabButtonChanged(_) {
    switchToTab(_tabButtons.selectedTabModelName);
  }

  void switchToFirstTab() {
    switchToTab(_tabs[_tabs.keys.first].modelName);
  }

  void invalidateHeight() {
    _resetHeight();
  }

  void switchToTab(String modelName) {
    _previewBox.color = _selectedBox.color;

    if(_inner.numChildren == 1) {
      DisplayObject child = _inner.getChildAt(0);
      assert(child is ColorPickerTabMixin);
      (child as ColorPickerTabMixin).onExit();
    }

    _inner.removeChildren();
    
    ColorPickerTabMixin tab = _tabs[modelName];
    _inner.addChild(tab.getDisplayObject());
    tab.onEnter();

    _tabButtons.switchToTab(modelName);
    _resetHeight();
  }

  void addTab(ColorPickerTabMixin tab) {
    _tabButtons.addTab(tab.modelName, tab.displayName);
    _tabs[tab.modelName] = tab;
  }

  void relayout() {
    num panelWidth = preferredWidth;
  
    num deltaY = _titleLabel.height + 5;

    _closeButton.setSize(deltaY, deltaY);
    _closeButton.setPosition(panelWidth - _closeButton.width, 0);

    _titleBar.graphics
      ..beginPath()
      ..rect(0, 0, panelWidth, deltaY)
      ..fillColor(Styles.panelHeadBG)
      ..closePath();

    deltaY += 5;
    _tabButtons.y = deltaY;

    deltaY = _tabButtons.y + _tabButtons.height + 10;
    _inner.y = deltaY;

    _resetHeight();
  }
}