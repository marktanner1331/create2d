import 'dart:collection';

import '../group_controllers/LineViewController.dart';
import './IHavePropertyMixins.dart';
import '../group_controllers/GroupController.dart';

mixin LinePropertiesMixin on IHavePropertyMixins {
  num thickness = 5;
  int strokeColor = 0xff000000;

  @override
  HashSet<GroupController> registerAndReturnViewControllers() {
    LineViewController.instance.addModel(this);

    return super.registerAndReturnViewControllers()
      ..add(LineViewController.instance);
  }

  void fromLinePropertiesMixin(LinePropertiesMixin other) {
    this.thickness = other.thickness;
    this.strokeColor = other.strokeColor;
  }
}
