import 'dart:html';
import 'package:stagexl/stagexl.dart';

import './Tab.dart';
import '../group_controllers/ContextController.dart';
import '../property_mixins/ContextPropertyMixin.dart';

class ContextTab extends Tab {
  static ContextTab _instance;
  static bool _isActive = false;

  static ContextPropertyMixin _currentObject;
  static EventStreamSubscription<Event> _contextChangedSubscription;
  static EventStreamSubscription<Event> _propertyChangedSubscription;

  List<ContextController> _activeGroups;

  Element _div;

  ContextTab(Element div) : super(div) {
    assert(_instance == null);
    _instance = this;

    this._div = div;
    _activeGroups = List();
  }

  static void set currentObject(ContextPropertyMixin value) {
    if (_isActive) {
      _instance.onExit();
      _currentObject = value;
      _instance.onEnter();
    } else {
      _currentObject = value;
    }
  }

  @override
  void onEnter() {
    _isActive = true;

    if (_currentObject == null) {
      return;
    }

    _contextChangedSubscription = _currentObject.onContextChanged.listen((_) {
      _refreshPropertyGroups();
    });

    _propertyChangedSubscription = _currentObject.onPropertiesChanged.listen((_) {
      for(ContextController group in _activeGroups) {
        group.refreshProperties();
      }
    });
  
    _refreshPropertyGroups();
  }

  void _refreshPropertyGroups() {
    clearPropertyGroups();

    for (ContextController group in _currentObject.getPropertyGroups()) {
      group.div.style.display = "block";
      group.open = true;
      _activeGroups.add(group);
    }
  }

  void clearPropertyGroups() {
    for(ContextController group in _activeGroups) {
      group.div.style.display = "none";
    }

    _activeGroups.clear();
  }

  @override
  void onExit() {
    if (_contextChangedSubscription != null) {
      _contextChangedSubscription.cancel();
    }

    if (_propertyChangedSubscription != null) {
      _propertyChangedSubscription.cancel();
    }

    _isActive = false;
    clearPropertyGroups();
  }
}