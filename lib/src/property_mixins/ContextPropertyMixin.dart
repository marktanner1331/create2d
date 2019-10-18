import 'package:stagexl/stagexl.dart';

import '../html_property_windows/property_groups/ContextGroup.dart';

///PROPERTIES_CHANGED is fired when the value of one or more properties inside the context changes
/// e.g. the lineWidth
///
///CONTEXT_CHANGED is fired when the properties themselves have changed
/// e.g. the lineWidth property didn't use to exist in the context at all, and now it does
/// this is leveraged nicely by the select tool, to change the context based on what you select
mixin ContextPropertyMixin {
  EventDispatcher _dispatcher = EventDispatcher();

  static const String PROPERTIES_CHANGED = "PROPERTIES_CHANGED";
  static const String CONTEXT_CHANGED = "CONTEXT_CHANGED";

  static const EventStreamProvider<Event> _propertiesChangedEvent =
      const EventStreamProvider<Event>(PROPERTIES_CHANGED);
  static const EventStreamProvider<Event> _contextChangedEvent =
      const EventStreamProvider<Event>(CONTEXT_CHANGED);

  EventStream<Event> get onPropertiesChanged =>
      _propertiesChangedEvent.forTarget(_dispatcher);
  EventStream<Event> get onContextChanged =>
      _contextChangedEvent.forTarget(_dispatcher);

  List<ContextGroup> getPropertyGroups() {
    return List();
  }

  void invalidateContext() {
    _dispatcher.dispatchEvent(Event(CONTEXT_CHANGED));
  }

  void invalidateProperties() {
    _dispatcher.dispatchEvent(Event(PROPERTIES_CHANGED));
  }
}