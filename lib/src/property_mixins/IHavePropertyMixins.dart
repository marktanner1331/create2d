import 'dart:collection';
import 'package:meta/meta.dart';
import '../group_controllers/ContextController.dart';

abstract class IHavePropertyMixins {
  @mustCallSuper
  HashSet<ContextController> registerAndReturnViewControllers() => HashSet();
}