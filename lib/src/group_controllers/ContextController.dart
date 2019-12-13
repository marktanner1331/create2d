import 'dart:html';

import 'package:meta/meta.dart';
import 'package:stagexl/stagexl.dart' as stageXL;

import './GroupController.dart';

abstract class ContextController extends GroupController {
  final Element view;

  bool get supportsMultipleModels => true;

  stageXL.EventDispatcher _dispatcher = stageXL.EventDispatcher();
 
  static const String PROPERTY_CHANGED = "PROPERTY_CHANGED";
  stageXL.EventStream<stageXL.Event> get onPropertyChanged => _dispatcher.on(PROPERTY_CHANGED);
  
  ContextController(this.view) : super(view);

  @override
  @mustCallSuper
  void onExit() {
    super.onExit();
    clearModels();
  }

  void clearModels();

  @protected
  void dispatchChangeEvent() {
    _dispatcher.dispatchEvent(stageXL.Event(PROPERTY_CHANGED));
  }
}