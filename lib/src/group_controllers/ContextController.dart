import 'dart:html';
import './GroupController.dart';

abstract class ContextController extends GroupController {
  final Element div;
  
  ContextController(this.div) : super(div);
}