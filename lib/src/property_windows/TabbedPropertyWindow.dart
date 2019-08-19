import 'package:stagexl/stagexl.dart';

import '../Styles.dart';

import '../widgets/CloseButton.dart';
import '../widgets/TabButtonRow.dart';
import '../helpers/DraggableController.dart';

import './PropertyWindow.dart';
import './CanvasPropertiesWindow.dart';
import './ContextProperties.dart';

class TabbedPropertyWindow extends Sprite {
  Sprite _titleBar;
  DraggableController _draggableController;

  TextField _titleLabel;
  CloseButton _closeButton;
  TabButtonRow _tabButtons;

  Sprite _inner;

  Map<String, PropertyWindow> _tabs;

  num get preferredWidth => 250;
  num get preferredHeight => 500;

  TabbedPropertyWindow() {
    _titleBar = Sprite()
      ..mouseCursor = MouseCursor.POINTER;
    addChild(_titleBar);

    _draggableController = DraggableController(this, _titleBar);

    _titleLabel = TextField()
      ..x = 5
      ..y = 2
      ..text = "Properties"
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
    
    addTab(CanvasPropertiesWindow());
    addTab(ContextPropertiesWindow());
    switchToTab(_tabs[_tabs.keys.first].modelName);

    _refresh();
  }

  void _onTabButtonChanged(_) {
    switchToTab(_tabButtons.selectedTabModelName);
  }

  void switchToTab(String modelName) {
    if(numChildren == 1) {
      DisplayObject child = _inner.getChildAt(0);
      assert(child is PropertyWindow);
      (child as PropertyWindow).onExit();
    }

    _inner.removeChildren();
    
    PropertyWindow window = _tabs[modelName];
    _inner.addChild(window);
    window.onEnter();

    _tabButtons.switchToTab(modelName);
  }

  void addTab(PropertyWindow propertyWindow) {
    _tabButtons.addTab(propertyWindow.modelName, propertyWindow.displayName);
    _tabs[propertyWindow.modelName] = propertyWindow;
  }

  void _refresh() {
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