import 'dart:html' as html;
import 'dart:math' as math;

import 'package:stagexl/stagexl.dart';
import '../property_windows/Tab.dart';
import '../view/MainWindow.dart';
import './Square.dart';

class ColorPicker3D extends Tab {
  RenderLoop _renderLoop;
  Stage _stage;

  int _numSquares = 12;
  num _preferredWidth = 250;
  num _preferredHeight = 300;
  num _adjustmentY;

  List<Square> _squares;

  Sprite _selectedSquareBlocker;
  Square _selectedSquare;

  EventStreamSubscription<MouseEvent> _stageClickSubscription;

  ColorPicker3D(html.Element view) : super(view) {
  }

  @override
  void initialize() {
    StageOptions options = StageOptions()
      ..backgroundColor = 0xff222222
      ..renderEngine = RenderEngine.WebGL
      ..stageAlign = StageAlign.TOP_LEFT
      ..stageScaleMode = StageScaleMode.NO_SCALE;

    html.CanvasElement canvas =
        view.querySelector('#_3DCanvas') as html.CanvasElement;

    canvas.width = _preferredWidth;
    canvas.height = 400;

    _stage = Stage(canvas, width: _preferredWidth, height: 400, options: options);
    _renderLoop = RenderLoop();
  
    this._squares = List();

    for (int i = 0; i < _numSquares; i++) {
      Square square = Square(i, i * (1 / _numSquares));
      square
        ..mouseCursor = MouseCursor.POINTER
        ..onMouseOver.listen(_onSquareMouseOver)
        ..onMouseClick.listen(onSquareClick);

      square
        ..x = 10
        ..skewY = -math.pi / 6
        ..skewX = -math.pi / 6;

      square
        ..width = _preferredWidth - 20;

      _squares.add(square);
      _stage.addChild(square);
    }

    _adjustmentY = -_squares[0].boundsTransformed.top + 5;
    view.onMouseOut.listen((_) => restackAllSquares());

    restackAllSquares();
  }

  void onSquareClick(MouseEvent event) {
    _selectedSquareBlocker = Sprite();
    _selectedSquareBlocker.graphics
      ..rect(0, 0, _stage.stageWidth, _stage.stageHeight)
      ..fillColor(0x33000000);
    _stage.addChild(_selectedSquareBlocker);

    Square square = event.currentTarget as Square;
    square.visible = false;

    restackAllSquares();

    _selectedSquare = Square(square.index, square.hue);

    _selectedSquare
      ..mouseCursor = MouseCursor.POINTER
      ..onMouseMove.listen(_onSelectedSquareMouseMove);

    Point mousePos = _stage.mousePosition;

    num duration = 0.2;

    num startX = mousePos.x;
    num endX = 5;
    num deltaX = endX - startX;

    num startY = mousePos.y;
    num endY =  (_preferredHeight - (_preferredWidth - 10)) / 2;
    num deltaY = endY - startY;

    num startWidth = (_preferredWidth - 10) / 2;
    num endWidth = _preferredWidth - 10;
    num deltaWidth = endWidth - startWidth;

    num startHeight = (_preferredWidth - 10) / 2;
    num endHeight = _preferredWidth - 10;
    num deltaHeight = endHeight - startHeight;

    num startRotation = -math.pi / 6;
    num endRotation = 0;
    num deltaRotation = endRotation - startRotation;

    _selectedSquare
        ..x = startX
        ..y = startY
        ..width = startWidth
        ..height = startHeight
        ..rotation = startRotation;

    Translation tween = _stage.juggler.addTranslation(0, 1, duration, Transition.linear, (delta) {
      _selectedSquare
        ..x = startX + delta * deltaX
        ..y = startY + delta * deltaY
        ..width = startWidth + delta * deltaWidth
        ..height = startHeight + delta * deltaHeight
        ..rotation = startRotation + delta * deltaRotation;
    });
    tween.onComplete = () {
      _selectedSquare
        ..skewX = 0
        ..skewY = 0
        ..x = endX
        ..y = endY
        ..width = endWidth
        ..height = endHeight
        ..rotation = endRotation;
    };

    _stage.addChild(_selectedSquare);

    event.stopImmediatePropagation();
    _stageClickSubscription = _stage.onMouseClick.listen(_onStageClick);
  }

  void _onSelectedSquareMouseMove(_) {
    int color = _selectedSquare.getColorUnderMouse();
    if(color != null) {
      MainWindow.colorPicker.setPreviewPixelColor(color);
    }
  }

  void _onStageClick(_) {
    int color = _selectedSquare.getColorUnderMouse();
    if(color != null) {
      MainWindow.colorPicker.setSelectedPixelColor(color);
    } else {
      MainWindow.colorPicker.setPreviewPixelColor(MainWindow.colorPicker.currentColor);
    }

    _stageClickSubscription.cancel();

    _stage.removeChild(_selectedSquareBlocker);
    _selectedSquareBlocker = null;

    _stage.removeChild(_selectedSquare);
    _squares[_selectedSquare.index].visible = true;
    _selectedSquare = null;
  }

  void _onSquareMouseOver(MouseEvent e) {
    num deltaY = 0;
    
    for (Square square in _squares) {
      num deltaHeight =
          (_preferredHeight - _adjustmentY) / _numSquares;

      square.y = (_numSquares - square.index) * deltaHeight + _adjustmentY;

      square.y -= deltaY;

      if (e.currentTarget == square) {
        deltaY = 25;
      }
    }
  }

  void restackAllSquares() {
    for (Square square in _squares) {
      num deltaHeight =
          (_preferredHeight - _adjustmentY) / _numSquares;
      
      square.y = (_numSquares - square.index) * deltaHeight + _adjustmentY;
    }
  }

  @override
  void onEnter() {
    super.onEnter();
    
    if (_stage.renderLoop == null) {
      _renderLoop.addStage(_stage);
    }
  }

  @override
  void onExit() {
    _renderLoop.removeStage(_stage);
    if(_selectedSquare != null) {
      _onStageClick(null);
    }
  }
}
