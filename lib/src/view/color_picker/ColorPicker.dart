import 'package:stagexl/stagexl.dart';

import './ColorPickerTabMixin.dart';
import './ColorWheel.dart';
import './ColorBox.dart';

import '../../Styles.dart';

import '../../widgets/CloseButton.dart';
import '../../widgets/TabButtonRow.dart';
import '../../helpers/DraggableController.dart';

class ColorPicker extends Sprite {
  static ColorPicker _instance;
  static ColorPicker get instance => _instance;

  Sprite _titleBar;
  DraggableController _draggableController;

  TextField _titleLabel;
  CloseButton _closeButton;
  TabButtonRow _tabButtons;

  Map<String, ColorPickerTabMixin> _tabs;

  Sprite _inner;

  ColorBox _previewBox;
  ColorBox _selectedBox;

  num get preferredWidth => 250;
  num get preferredHeight => 550;

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
    addChild(_closeButton);
    
    _tabButtons = TabButtonRow();
    _tabButtons.onTabChanged.listen(_onTabButtonChanged);
    addChild(_tabButtons);

    _tabs = Map();

    _inner = Sprite();
    addChild(_inner);

    addTab(ColorWheel(this, preferredWidth));
    switchToFirstTab();

    num deltaY = 300;

    _previewBox = ColorBox("Preview Color")
      ..setSize(preferredWidth / 2 - 10, 75)
      ..x = 5
      ..y = deltaY;

    addChild(_previewBox);

    _selectedBox = ColorBox("Selected Color")
      ..setSize(preferredWidth / 2 - 10, 75)
      ..x = preferredWidth / 2 + 5
      ..y = deltaY;

    addChild(_selectedBox);

    relayout();
  }

  void setPreviewPixelColor(int color) {
    _previewBox.color = color;
  }

  void setSelectedPixelColor(int color) {
    _selectedBox.color = color;
  }
  
  void _onTabButtonChanged(_) {
    switchToTab(_tabButtons.selectedTabModelName);
  }

  void switchToFirstTab() {
    switchToTab(_tabs[_tabs.keys.first].modelName);
  }

  void switchToTab(String modelName) {
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
  }

  void addTab(ColorPickerTabMixin tab) {
    _tabButtons.addTab(tab.modelName, tab.displayName);
    _tabs[tab.modelName] = tab;
  }

  void relayout() {
    num panelWidth = preferredWidth;
    graphics
      ..clear()
      ..beginPath()
      ..rect(0, 0, panelWidth, 400)
      ..fillColor(Styles.panelBG)
      ..closePath();
  
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

    deltaY = _tabButtons.y + _tabButtons.height + 5;
    _inner.y = deltaY;

    deltaY += 400;
  }
}