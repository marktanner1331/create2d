import 'dart:collection';

import './IHavePropertyMixins.dart';
import '../group_controllers/ContextController.dart';
import '../group_controllers/TextStyleViewController.dart';

mixin TextStyleMixin on IHavePropertyMixins {
  int textColor = 0xff000000;
  int textSize = 12;

  void fromTextStyleMixin(TextStyleMixin other) {
    this.textColor = other.textColor;
    this.textSize = other.textSize;
  }

  HashSet<ContextController> registerAndReturnViewControllers() {
    TextStyleViewController.instance.addModel(this);

    return super.registerAndReturnViewControllers()
      ..add(TextStyleViewController.instance);
  }
}