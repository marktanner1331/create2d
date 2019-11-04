import 'dart:html';
import 'package:meta/meta.dart';
import '../helpers/IOnEnterExit.dart';

abstract class Tab implements IOnEnterExit {
  final Element view;
  bool _initialized = false;

  Tab(this.view) {

  }

  void initialize();

  @mustCallSuper
  void onEnter() {
    if(_initialized == false) {
      initialize();
      _initialized = true;
    }
  }
}