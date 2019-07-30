import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:design2D/design2D.dart';

Stage stage;
MainWindow mainWindow;

Future<Null> main() async {
  StageOptions options = StageOptions()
    ..backgroundColor = Color.White
    ..renderEngine = RenderEngine.WebGL
    ..stageAlign = StageAlign.TOP_LEFT
    ..preventDefaultOnTouch = false
    ..inputEventMode = InputEventMode.MouseOnly
    ..stageScaleMode = StageScaleMode.NO_SCALE;

  var canvas = html.querySelector('#stage');
  stage = Stage(canvas, width: 1280, height: 800, options: options);
  
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  mainWindow = MainWindow();
  stage.addChild(mainWindow);

  stage.onResize.listen(onResized);
  onResized(null);
}

void onResized(Event e) {
  mainWindow.setSize(stage.stageWidth, stage.stageHeight);
}