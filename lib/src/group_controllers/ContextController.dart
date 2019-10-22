import 'dart:html';

import '../helpers/IOnEnterExit.dart';
import './GroupController.dart';

abstract class ContextController extends GroupController implements IOnEnterExit {
  final Element div;

  ContextController(this.div) : super(div);
}