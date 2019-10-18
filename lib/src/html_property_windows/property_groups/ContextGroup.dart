import 'dart:html';

import '../../helpers/IOnEnterExit.dart';

abstract class ContextGroup implements IOnEnterExit {
  final Element div;

  ContextGroup(this.div);
}