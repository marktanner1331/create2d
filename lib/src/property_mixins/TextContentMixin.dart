import 'dart:collection';

import './IHavePropertyMixins.dart';
import '../group_controllers/ContextController.dart';
import '../group_controllers/TextContentViewController.dart';

mixin TextContentMixin on IHavePropertyMixins {
  String content = "";

    void fromTextContentMixin(TextContentMixin other) {
      this.content = other.content;
    }

    HashSet<ContextController> registerAndReturnViewControllers() {
      TextContentViewController.instance.model = this;

      return super.registerAndReturnViewControllers()
        ..add(TextContentViewController.instance);
  }
}