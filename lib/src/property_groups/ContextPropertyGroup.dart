import 'package:stagexl/stagexl.dart';

import './PropertyGroup.dart';
import '../property_mixins/ContextPropertyMixin.dart';

abstract class ContextPropertyGroup extends PropertyGroup {
  EventStreamSubscription<Event> _propertyChangedSubscription;
  ContextPropertyMixin _myMixin;

  ContextPropertyGroup(ContextPropertyMixin myMixin, String title) : super(title) {
    this._myMixin = myMixin;
  }

  @override
  void onEnter() {
    _propertyChangedSubscription = _myMixin.onPropertiesChanged.listen((_) => refreshProperties());
    refreshProperties();
  }

  @override
  void onExit() {
    _propertyChangedSubscription.cancel();
  }

  void refreshProperties();
}