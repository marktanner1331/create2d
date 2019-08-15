import 'package:stagexl/stagexl.dart';

import '../Styles.dart';

import '../widgets/CloseButton.dart';
import '../widgets/TabButtonRow.dart';

import './PropertyWindow.dart';
import './CanvasPropertiesWindow.dart';

class TabbedPropertyWindow extends Sprite {
  TabbedPropertyWindow _instance;

  Sprite _titleBar;
  Point _titleBarMouseOffset = Point(0, 0);
  EventStreamSubscription<MouseEvent> _stageMoveSubscription;
  EventStreamSubscription<MouseEvent> _stageUpSubscription;

  TextField _titleLabel;
  CloseButton _closeButton;
  TabButtonRow _tabButtons;

  Sprite _inner;

  Map<String, PropertyWindow> _tabs;

  num get preferredWidth => 250;
  num get preferredHeight => 500;

  TabbedPropertyWindow() {
    assert(_instance == null);
    _instance = this;
    
    _titleBar = Sprite()
      ..mouseCursor = MouseCursor.POINTER
      ..onMouseDown.listen(_onTitleMouseDown);
    addChild(_titleBar);

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

  void _onTitleMouseDown(_) {
    _titleBarMouseOffset = Point(parent.mouseX - x, parent.mouseY - y);
    _stageMoveSubscription = stage.onMouseMove.listen(stageMove);
    _stageUpSubscription = stage.onMouseUp.listen(stageUp);
  }

  void stageMove(_) {
    x = parent.mouseX - _titleBarMouseOffset.x;
    y = parent.mouseY - _titleBarMouseOffset.y;
  }

  void stageUp(_) {
    _stageUpSubscription.cancel();
    _stageUpSubscription = null;

    _stageMoveSubscription.cancel();
    _stageMoveSubscription = null;
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