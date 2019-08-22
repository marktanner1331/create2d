import 'package:stagexl/stagexl.dart';

mixin ColorPickerTabMixin {
  String get modelName;
  String get displayName;

  void onExit();
  void onEnter();

  DisplayObject getDisplayObject();
}