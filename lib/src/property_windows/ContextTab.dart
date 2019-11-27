import 'dart:html';
import 'package:stagexl/stagexl.dart';

import '../view/MainWindow.dart';
import './Tab.dart';
import '../group_controllers/ContextController.dart';
import '../property_mixins/IHavePropertyMixins.dart';

class ContextTab extends Tab {
  static ContextTab _instance;
  static bool _isActive = false;
  
  List<EventStreamSubscription<Event>> _propertiesChangedSubscriptions;
  
  List<ContextController> _activeGroups;

  ContextTab(Element div) : super(div) {
    _instance = this;
  }

  @override
  void initialize() {
      _activeGroups = List();
      _propertiesChangedSubscriptions = List();
  }

  static void refreshContext() {
    if (_isActive) {
      _instance._refreshContext();
    }
  }

  @override
  void onEnter() {
    super.onEnter();

    _isActive = true;
    _refreshContext();
  }

  //does not refresh the context, only the current active groups
  static void refreshProperties() {
    for (ContextController group in _instance._activeGroups) {
      group.refreshProperties();
    }
  }

  void _onPropertiesChanged(_) {
    MainWindow.toolbox.currentTool.contextPropertiesHaveChanged();
  }

  void _refreshContext() {
    clearPropertyGroups();

    for (ContextController group in MainWindow.toolbox.currentTool.registerAndReturnViewControllers()) {
      group.view.style.display = "block";
      group.open = true;
      _propertiesChangedSubscriptions.add(group.onPropertyChanged.listen(_onPropertiesChanged));
      _activeGroups.add(group);
      group.onEnter();
    }
  }

  void clearPropertyGroups() {
    for (ContextController group in _activeGroups) {
      group.view.style.display = "none";
      group.onExit();
    }

    for(EventStreamSubscription<Event> subscription in _propertiesChangedSubscriptions) {
      subscription.cancel();
    }

    _activeGroups.clear();
  }

  @override
  void onExit() {
    _isActive = false;
    clearPropertyGroups();
  }
}
