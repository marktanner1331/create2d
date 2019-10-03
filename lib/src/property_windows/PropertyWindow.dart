import 'package:stagexl/stagexl.dart';
import 'package:meta/meta.dart';

import '../property_groups/PropertyGroup.dart';
import '../helpers/IOnEnterExit.dart';

abstract class PropertyWindow extends Sprite implements IOnEnterExit {
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
      group.onExit();
    }

    _groups.clear();
    removeChildren();
  }

  @protected
  void addPropertyGroup(PropertyGroup group) {
    group
      ..x = 3
      ..isOpen = true
      ..onIsOpenChanged.listen((_) => _relayoutGroups())
      ..preferredWidth = _preferredWidth - 6;
    _groups.add(group);
    addChild(group);

    group.onEnter();

    _relayoutGroups();
  }

  void _relayoutGroups() {
    num deltaY = 0;
    for(PropertyGroup group in _groups) {
      group.y = deltaY;
      deltaY += group.height + 2;
    }
  }

  void _isOpenChanged(Event event) {
    _relayoutGroups();
  }

  num get preferredHeight => height;
}