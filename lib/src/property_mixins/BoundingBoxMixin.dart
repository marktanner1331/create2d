import 'dart:collection';
import 'package:stagexl/stagexl.dart' show JointStyle;

import '../group_controllers/BoundingBoxViewController.dart';
import './IHavePropertyMixins.dart';
import '../group_controllers/ContextController.dart';

mixin BoundingBoxMixin on IHavePropertyMixins  {
  bool boundingBoxVisible = false;
  num boundingBoxThickness = 5;
  int boundingBoxStrokeColor = 0xff000000;
  JointStyle boundingBoxJointStyle = JointStyle.ROUND;
  bool boundingBoxDashed = false;
  num boundingBoxDashLength = 5;
  num boundingBoxDashSpacing = 5;

  @override
  HashSet<ContextController> registerAndReturnViewControllers() {
    BoundingBoxViewController.instance.addModel(this);

    return super.registerAndReturnViewControllers()
      ..add(BoundingBoxViewController.instance);
  }

  void fromBoundingBoxMixin(BoundingBoxMixin other) {
    this.boundingBoxVisible = other.boundingBoxVisible;
    this.boundingBoxThickness = other.boundingBoxThickness;
    this.boundingBoxStrokeColor = other.boundingBoxStrokeColor;
    this.boundingBoxJointStyle = other.boundingBoxJointStyle;
    this.boundingBoxDashed = other.boundingBoxDashed;
    this.boundingBoxDashLength = other.boundingBoxDashLength;
    this.boundingBoxDashSpacing = other.boundingBoxDashSpacing;
  }
}