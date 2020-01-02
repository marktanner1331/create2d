import 'package:stagexl/stagexl.dart';

class ShortcutController {
  bool shiftIsDown = false;

  //the interactive object passed in must be added to the stage at some point
  ShortcutController(InteractiveObject interactiveObject) {
    interactiveObject.onKeyDown.listen(_onKeyDown);
    interactiveObject.onKeyUp.listen(_onKeyUp);

    if(interactiveObject.stage != null) {
      interactiveObject.stage.focus = interactiveObject;
    }

    interactiveObject.onAddedToStage.listen((_) {
      interactiveObject.stage.focus = interactiveObject;
    });
  }

  void _onKeyDown(KeyboardEvent e) {
    shiftIsDown = e.shiftKey;
  }

  void _onKeyUp(KeyboardEvent e) {
    shiftIsDown = e.shiftKey;
  }
}