import 'dart:collection';
import 'package:stagexl/stagexl.dart' show JointStyle;

import '../group_controllers/LineViewController.dart';
import './IHavePropertyMixins.dart';
import '../group_controllers/ContextController.dart';

mixin LinePropertiesMixin on IHavePropertyMixins {
  num thickness = 5;
  int strokeColor = 0xff000000;
  JointStyle jointStyle = JointStyle.ROUND;
  bool dashed = false;
  num dashLength = 5;
  num dashSpacing = 5;

  @override
  HashSet<ContextController> registerAndReturnViewControllers() {
    LineViewController.instance.addModel(this);

    return super.registerAndReturnViewControllers()
      ..add(LineViewController.instance);
  }

  void fromLinePropertiesMixin(LinePropertiesMixin other) {
    this.thickness = other.thickness;
    this.strokeColor = other.strokeColor;
    this.jointStyle = other.jointStyle;
    this.dashed = other.dashed;
    this.dashLength = other.dashLength;
    this.dashSpacing = other.dashSpacing;
  }

  // bool equals(LinePropertiesMixin other) {
  //   return this.thickness == other.thickness
  //       && this.strokeColor == other.strokeColor
  //       && this.jointStyle == other.jointStyle
  //       && this.dashed == other.dashed
  //       && this.dashLength == other.dashLength
  //       && this.spaceLength == other.spaceLength;
  // }
}
