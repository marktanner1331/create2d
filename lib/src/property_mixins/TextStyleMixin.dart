import 'dart:collection';
import 'package:stagexl/stagexl.dart' show TextField, TextFormat;

import './IHavePropertyMixins.dart';
import '../group_controllers/ContextController.dart';
import '../group_controllers/TextStyleViewController.dart';

mixin TextStyleMixin on IHavePropertyMixins {
  int textColor = 0xff000000;
  int textSize = 12;

  bool bold = false;
  bool italic = false;
  bool underline = false;
  String font = "Arial";

  void fromTextStyleMixin(TextStyleMixin other) {
    this.textColor = other.textColor;
    this.textSize = other.textSize;
    this.bold = other.bold;
    this.italic = other.italic;
    this.underline = other.underline;
    this.font = font;
  }

  void applyStyleToText(TextField text) {
    TextFormat format = text.defaultTextFormat
      ..color = textColor
      ..size = textSize
      ..bold = bold
      ..italic = italic
      ..underline = underline
      ..font = font;

    text.defaultTextFormat = format;

    text
      ..multiline = true
      ..width = text.textWidth
      ..height = text.textHeight;

    //add an extra character to fix any italics being cut off
    text.width += text.width / text.text.length;
  }

  HashSet<ContextController> registerAndReturnViewControllers() {
    TextStyleViewController.instance.addModel(this);

    return super.registerAndReturnViewControllers()
      ..add(TextStyleViewController.instance);
  }
}