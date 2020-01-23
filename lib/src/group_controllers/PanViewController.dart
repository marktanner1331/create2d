import 'dart:html';
import './ContextController.dart';
import '../view/MainWindow.dart';

class PanViewController extends ContextController {
  static PanViewController get instance =>
      _instance ?? (_instance = PanViewController());
  static PanViewController _instance;

  TextInputElement _step;
  CheckboxInputElement _reverse;

  PanViewController() : super(document.querySelector("#contextTab #pan")) {
    _step = view.querySelector("#panStep");
    _step.onInput.listen(_onStepChanged);

    _reverse = view.querySelector("#reversePan");
    _reverse.onInput.listen(_onReverseChanged);

    ButtonElement resetPan = view.querySelector("#resetPan");
    resetPan.onClick.listen((_) => MainWindow.resetCanvasZoomAndPosition());
  }

  void _onStepChanged(_) {
    int newStep = int.tryParse(_step.value);

    if (newStep == null || newStep < 1) {
      return;
    }

    MainWindow.panStep = newStep;

    dispatchChangeEvent();
  }

  void _onReverseChanged(_) {
    MainWindow.reversePanDirection = _reverse.checked;
    
    dispatchChangeEvent();
  }

  void clearModels() {

  }

  @override
  void refreshProperties() {
    _step.value = MainWindow.panStep.toString();
    _reverse.checked = MainWindow.reversePanDirection;
  }
}