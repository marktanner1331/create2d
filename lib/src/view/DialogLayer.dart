import 'package:stagexl/stagexl.dart';
import './Dialog.dart';

class DialogLayer extends Sprite {
  static DialogLayer _instance;
  static DialogLayer get instance => _instance;

  static List<Sprite> _blockers;
  static List<DisplayObject> _dialogs;

  DialogLayer() {
    assert(_instance == null);
    _instance = this;
    
    _blockers = List();
    _dialogs = List();
  }

  static Sprite _createBlocker() {
    Sprite blocker = Sprite();
    blocker.graphics
      ..rect(0, 0, 1, 1)
      ..fillColor(0xaa000000);
    return blocker;
  }

  static void relayout() {
    for(Sprite blocker in _blockers) {
      blocker.width = _instance.stage.stageWidth;
      blocker.height = _instance.stage.stageHeight;
    }

    for(DisplayObject dialog in _dialogs) {
      dialog
        ..x = (_instance.stage.stageWidth - dialog.width) / 2
        ..y = (_instance.stage.stageHeight - dialog.height) / 2;
    }
  }

  static void pushDialog(DisplayObject dialog) {
    Sprite blocker = _createBlocker();
    
    _instance.addChild(blocker);
    _blockers.add(blocker);

    _instance.addChild(dialog);
    _dialogs.add(dialog);

    //might be null if we are showing a dialog straight away
    //before the MainWindow has had a chance to be added to the stage
    //in that case, relayout() will be called as soon as we have a stage
    //and that will handle the positioning
    if(_instance.stage != null) {
      blocker
        ..width = _instance.stage.stageWidth
        ..height = _instance.stage.stageHeight;

      dialog
        ..x = (_instance.stage.stageWidth - dialog.width) / 2
        ..y = (_instance.stage.stageHeight - dialog.height) / 2;
    }
  }

  static void popDialog() {
    DisplayObject dialog = _dialogs.removeLast();
    _instance.removeChild(dialog);

    Sprite blocker = _blockers.removeLast();
    _instance.removeChild(blocker);
  }

  static void alert(String message, void onComplete()) {
    Dialog dialog = Dialog("Info", message, (_) {
      popDialog();
      onComplete();
    });

    pushDialog(dialog);
  }
}
