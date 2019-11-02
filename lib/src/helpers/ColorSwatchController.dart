import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL;

import '../view/MainWindow.dart';
import './ColorHelper.dart';
import './IOnEnterExit.dart';

class ColorSwatchController implements IOnEnterExit {
  static const String COLOR_CHANGED = "COLOR_CHANGED";

  static stageXL.EventDispatcher _dispatcher = stageXL.EventDispatcher();
  stageXL.EventStream<stageXL.Event> get onColorChanged => _dispatcher.on(COLOR_CHANGED);

  Element _view;

  stageXL.EventStreamSubscription<stageXL.Event> _colorPickerChangedSubscription;
  stageXL.EventStreamSubscription<stageXL.Event> _colorPickerClosedSubscription;

  int get color => ColorHelper.parseCssColor(_view.style.backgroundColor);
  set color(int value) => _view.style.backgroundColor = "#" + ColorHelper.colorToHex(value);

  ColorSwatchController(Element view) {
    this._view = view;
    _view.onClick.listen(_onClick);
  }

  void _onColorPickerChanged(_) {
    this.color = MainWindow.colorPicker.currentColor;
    _dispatcher.dispatchEvent(stageXL.Event(COLOR_CHANGED));
  }

  void _onColorPickerClosed(_) {
    _colorPickerChangedSubscription.cancel();
    _colorPickerClosedSubscription.cancel();
  }

  void _onClick(_) {
    //we hide it to begin with in case anything else is listening out for updates
    //we want to steal it completely, so we give them a chance to cancel themselves
    MainWindow.colorPicker.hide();

    _colorPickerChangedSubscription = MainWindow.colorPicker.onCurrentColorChanged.listen(_onColorPickerChanged);
    _colorPickerClosedSubscription = MainWindow.colorPicker.onClosed.listen(_onColorPickerClosed);

    MainWindow.colorPicker.show();
  }

  @override
  void onEnter() {
    
  }

  @override
  void onExit() {
    if(_colorPickerChangedSubscription != null) {
      MainWindow.colorPicker.hide();
    }
  }
}