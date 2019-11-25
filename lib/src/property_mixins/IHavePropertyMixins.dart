import 'dart:collection';
import 'package:meta/meta.dart';
import '../group_controllers/GroupController.dart';

abstract class IHavePropertyMixins {
  @mustCallSuper
  HashSet<GroupController> registerAndReturnViewControllers() => HashSet();
}