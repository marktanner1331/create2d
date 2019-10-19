import 'dart:html';
import 'package:stagexl/stagexl.dart';

import './Tab.dart';
import './property_groups/ContextGroup.dart';
import '../property_mixins/ContextPropertyMixin.dart';

class ContextTab extends Tab {
  static ContextTab _instance;
  static bool _isActive = false;

  static ContextPropertyMixin _currentObject;
  static EventStreamSubscription<Event> _contextChangedSubscription;
  
  List<ContextGroup> _activeGroups;

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

    _refreshPropertyGroups();
  }

  void _refreshPropertyGroups() {
    clearPropertyGroups();
    for (ContextGroup group in _currentObject.getPropertyGroups()) {
      group.div.style.display = "block";
    }
  }

  void clearPropertyGroups() {
    for(ContextGroup group in _activeGroups) {
      group.div.style.display = "none";
      group.onExit();
    }

    _activeGroups.clear();
  }

  @override
  void onExit() {
    if (_contextChangedSubscription != null) {
      _contextChangedSubscription.cancel();
    }

    _isActive = false;
    clearPropertyGroups();
  }
}