import 'package:stagexl/stagexl.dart';

class KeyboardController {
  bool shiftIsDown;

  KeyboardController(InteractiveObject interactiveObject) {
    interactiveObject.onKeyDown.listen(_onKeyDown);
    interactiveObject.onKeyUp.listen(_onKeyUp);
  }

  void _onKeyDown(KeyboardEvent e) {
    shiftIsDown = e.shiftKey;
  }

  void _onKeyUp(KeyboardEvent e) {
    shiftIsDown = e.shiftKey;
  }
}