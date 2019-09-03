import 'package:stagexl/stagexl.dart';
import 'dart:math' as math;

import './ColorPickerTabMixin.dart';

import './ColorPicker.dart';
import './Square.dart';

class Color3D extends Sprite with ColorPickerTabMixin {
  ColorPicker _colorPicker;
  num _preferredWidth;

  int _numSquares = 12;
  num _preferredHeight = 300;
  num _adjustmentY;

  List<Square> _squares;

  Sprite _selectedSquareBlocker;
  Square _selectedSquare;

  EventStreamSubscription<MouseEvent> _stageClickSubscription;

  Color3D(ColorPicker colorPicker, num preferredWidth) {
    this._colorPicker = colorPicker;
    this._preferredWidth = preferredWidth;

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
      addChild(square);
    }

    _adjustmentY = -_squares[0].boundsTransformed.top;
    onMouseOut.listen((_) => restackAllSquares());

    restackAllSquares();
  }

  void onSquareClick(MouseEvent event) {
    _selectedSquareBlocker = Sprite();
    _selectedSquareBlocker.graphics
      ..rect(0, 0, _preferredWidth, height)
      ..fillColor(0x33000000);
    addChild(_selectedSquareBlocker);

    Square square = event.currentTarget as Square;
    square.visible = false;

    restackAllSquares();

    _selectedSquare = Square(square.index, square.hue);

    _selectedSquare
      ..mouseCursor = MouseCursor.POINTER
      ..onMouseMove.listen(_onSelectedSquareMouseMove);

    Point mousePos = mousePosition;

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

    Translation tween = stage.juggler.addTranslation(0, 1, duration, Transition.linear, (delta) {
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

    addChild(_selectedSquare);

    event.stopImmediatePropagation();
    _stageClickSubscription = stage.onMouseClick.listen(_onStageClick);
  }

  void _onSelectedSquareMouseMove(_) {
    int color = _selectedSquare.getColorUnderMouse();
    if(color != null) {
      _colorPicker.setPreviewPixelColor(color);
    }
  }

  void _onStageClick(_) {
    int color = _selectedSquare.getColorUnderMouse();
    if(color != null) {
      _colorPicker.setSelectedPixelColor(color);
    } else {
      _colorPicker.setPreviewPixelColor(ColorPicker.currentColor);
    }

    _stageClickSubscription.cancel();

    removeChild(_selectedSquareBlocker);
    _selectedSquareBlocker = null;

    removeChild(_selectedSquare);
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
  String get displayName => "3D";

  @override
  DisplayObject getDisplayObject() => this;

  @override
  String get modelName => "3D";

  @override
  void onEnter() {
    // TODO: implement onEnter
  }

  @override
  void onExit() {
    // TODO: implement onExit
  }
}
