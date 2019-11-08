import 'dart:html';
import './GroupController.dart';

abstract class ContextController extends GroupController {
  final Element view;
  
  ContextController(this.view) : super(view);
}