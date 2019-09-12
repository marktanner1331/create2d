import 'package:stagexl/stagexl.dart';

import './ColorPickerTabMixin.dart';
import './ColorPicker.dart';

import './mixers/ColorMixerGroup.dart';
import './mixers/OppositeMixer.dart';
import './mixers/AnalogousMixer.dart';
import './mixers/TriadicMixer.dart';
import './mixers/SplitComplementaryMixer.dart';
import './mixers/TetradicMixer.dart';

class ColorMixer extends Sprite with ColorPickerTabMixin {
  EventStreamSubscription _currentColorChangedSubscription;

  List<ColorMixerGroup> _groups;
  num _preferredWidth;
  num _deltaY = 5;

  ColorMixer(ColorPicker colorPicker, num preferredWidth) {
    this._preferredWidth = preferredWidth;

    _groups = List();
    _addGroup(OppositeMixer(colorPicker));
    _addGroup(AnalogousMixer(colorPicker));
    _addGroup(TriadicMixer(colorPicker));
    _addGroup(SplitComplementaryMixer(colorPicker));
    _addGroup(TetradicMixer(colorPicker));
  }

  void _addGroup(ColorMixerGroup group) {
    num preferredHeight = group.preferredHeightForWidth(_preferredWidth);
    
    group
      ..setSize(_preferredWidth - 10, preferredHeight)
      ..x = 5
      ..y = _deltaY;
    _deltaY += preferredHeight;

    _groups.add(group);
    addChild(group);
  }

  @override
  String get displayName => "Mixer";

  @override
  DisplayObject getDisplayObject() {
    return this;
  }

  @override
  String get modelName => "MIXER";

  void _onCurrentColorChanged(_) {
    int color = ColorPicker.currentColor;

    for(ColorMixerGroup group in _groups) {
      group.refreshForColor(color);
    }
  }

  @override
  void onEnter() {
    _currentColorChangedSubscription = ColorPicker.onCurrentColorChanged.listen(_onCurrentColorChanged);
    _onCurrentColorChanged(null);
  }

  @override
  void onExit() {
    _currentColorChangedSubscription.cancel();
  }
}