import 'dart:html';
import '../helpers/IOnEnterExit.dart';

abstract class Tab implements IOnEnterExit {
  final Element view;

  Tab(this.view) {

  }
}