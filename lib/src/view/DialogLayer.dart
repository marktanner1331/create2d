import 'package:stagexl/stagexl.dart';

class DialogLayer extends Sprite {
  static DialogLayer _instance;
  static DialogLayer get instance => _instance;

  static List<Sprite> _blockers;

  DialogLayer() {
    assert(_instance == null);
    _instance = this;

    _blockers = List();
  }

  static Sprite _createBlocker() {
    Sprite blocker = Sprite();
    blocker.graphics
      ..rect(0, 0, 1, 1)
      ..fillColor(0xaa000000);
    return blocker;
  }

  static void setSize(num width, num height) {
    for(Sprite blocker in _blockers) {
      blocker.width = width;
      blocker.height = height;
    }
  }
}
