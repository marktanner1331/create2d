import 'package:stagexl/stagexl.dart';
import 'package:meta/meta.dart';

import './groups/PropertyGroup.dart';

abstract class PropertyWindow extends Sprite {
  String get displayName;
  String get modelName;

  List<PropertyGroup> _groups;
  num _preferredWidth = 244;
  num get preferredWidth => _preferredWidth;

  PropertyWindow() {
    _groups = List();
  }

  @protected
  void clearPropertyGroups() {
    for(PropertyGroup group in _groups) {
      group.onIsOpenChanged.cancelSubscriptions();
    }

    _groups.clear();
    removeChildren();
  }

  void onEnter();

  void onExit();

  @protected
  void addPropertyGroup(PropertyGroup group) {
    group
      ..x = 3
      ..isOpen = true;
    _groups.add(group);
    addChild(group);

    _relayoutGroups();
  }

  void _relayoutGroups() {
    num deltaY = 0;
    for(PropertyGroup group in _groups) {
      group.y = deltaY;
      deltaY += group.height;
    }
  }

  void _isOpenChanged(Event event) {
    _relayoutGroups();
  }

  num get preferredHeight => height;
}