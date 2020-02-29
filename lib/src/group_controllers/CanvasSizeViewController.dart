import 'dart:html';
import 'dart:math';

import '../view/MainWindow.dart';
import '../helpers/ColorHelper.dart';
import '../helpers/ColorSwatchController.dart';
import './GroupController.dart';
import '../property_mixins/CanvasPropertiesMixin.dart';
import '../model/PaperSize.dart';
import '../model/Orientation.dart';

class CanvasSizeViewController extends GroupController {
  CanvasPropertiesMixin _model;
  InputElement _width;
  InputElement _height;
  ColorSwatchController _bgColorController;

  SelectElement _paperSize;
  SelectElement _paperOrientation;
  HtmlElement _paperOrientationContainer;

  CanvasSizeViewController(Element view) : super(view) {
    _width = view.querySelector("#canvasWidth") as InputElement;
    _width.onInput.listen(_onWidthOrHeightChange);

    _height = view.querySelector("#canvasHeight") as InputElement;
    _height.onInput.listen(_onWidthOrHeightChange);

    _bgColorController =
        ColorSwatchController(view.querySelector("#backgroundColor"));
    _bgColorController.onColorChanged.listen(_onBGColorChange);

    _paperSize = view.querySelector("#paperSize") as SelectElement;
    _paperSize.onChange.listen(_onPaperSizeChange);

    _paperOrientationContainer =
        view.querySelector("#paperOrientationContainer") as HtmlElement;

    _paperOrientation =
        view.querySelector("#paperOrientation") as SelectElement;
    _paperOrientation.onChange.listen(_onPaperOrientationChange);
  }

  void _setPaperSizeToCustom() {
    _model.paperSize = PaperSize.Custom;
    _paperSize.selectedIndex = 0;
    _paperOrientationContainer.style.display = "none";
  }

  void _onPaperSizeChange(_) {
    String selectedOption = _paperSize.selectedOptions.first.text;
    _model.paperSize = _parsePaperSize(selectedOption);

    MainWindow.propertyWindow.refreshCurrentTab();
  }

  void _onPaperOrientationChange(_) {
    String selectedOption = _paperOrientation.selectedOptions.first.value;
    _model.paperOrientation = _parseOrientation(selectedOption);

    MainWindow.propertyWindow.refreshCurrentTab();
  }

  void _onBGColorChange(_) {
    _model.backgroundColor = _bgColorController.color;
  }

  static String getBGColorCommand() =>
      "#" + ColorHelper.colorToHex(MainWindow.canvas.backgroundColor);

  static Orientation _parseOrientation(String value) {
    switch (value.toLowerCase()) {
      case "landscape":
        return Orientation.Landscape;
      case "portrait":
        return Orientation.Portrait;
      default:
        return null;
    }
  }

  static PaperSize _parsePaperSize(String value) {
    switch (value.toLowerCase()) {
      case "custom":
        return PaperSize.Custom;
      case "a0":
        return PaperSize.A0;
      case "a1":
        return PaperSize.A1;
      case "a2":
        return PaperSize.A2;
      case "a3":
        return PaperSize.A3;
      case "a4":
        return PaperSize.A4;
      case "a5":
        return PaperSize.A5;
      case "a6":
        return PaperSize.A6;
      default:
        return null;
    }
  }

  static String _paperSizeToString(PaperSize value) {
    return value.toString().replaceAll("PaperSize.", "");
  }

  static String _orientationToString(Orientation value) {
    return value.toString().replaceAll("Orientation.", "");
  }

  static String getPaperSizeCommand() => _paperSizeToString(MainWindow.canvas.paperSize);

  static void setPaperSizeCommand(String paperSize) {
    PaperSize size = _parsePaperSize(paperSize);
    if (size == null) {
      return;
    }

    MainWindow.canvas.paperSize = size;
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  static String getPaperOrientationCommand() =>
      _orientationToString(MainWindow.canvas.paperOrientation);

  static void setPaperOrientationCommand(String paperOrientation) {
    Orientation orientation = _parseOrientation(paperOrientation);
    if (orientation == null) {
      return;
    }

    MainWindow.canvas.paperOrientation = orientation;
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  static void setBGColorCommand(String hexCode) {
    MainWindow.canvas.backgroundColor = ColorHelper.parseCssColor(hexCode);
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  static void setCanvasWidthCommand(num value) {
    MainWindow.canvas.setCanvasSize(value, MainWindow.canvas.canvasHeight);
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  static void setCanvasHeightCommand(num value) {
    MainWindow.canvas.setCanvasSize(MainWindow.canvas.canvasWidth, value);
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  static void setCanvasSizeCommand(num width, num height) {
    MainWindow.canvas.setCanvasSize(width, height);
    MainWindow.propertyWindow.refreshCurrentTab();
  }

  void _onWidthOrHeightChange(_) {
    num newWidth = num.tryParse(_width.value);
    num newHeight = num.tryParse(_height.value);

    if (newWidth == null || newHeight == null) {
      return;
    }

    _setPaperSizeToCustom();
    _model.setCanvasSize(newWidth, newHeight);
  }

  void set model(CanvasPropertiesMixin value) {
    _model = value;
    refreshProperties();
  }

  @override
  void refreshProperties() {
    _width.value = _model.canvasWidth.toString();
    _height.value = _model.canvasHeight.toString();
    _bgColorController.color = _model.backgroundColor;

    String paperSizeString = _paperSizeToString(_model.paperSize);

    _paperSize.selectedIndex = _paperSize.options
        .firstWhere((option) => option.value == paperSizeString)
        .index;

    if (_model.paperSize == PaperSize.Custom) {
      _paperOrientationContainer.style.display = "none";
    } else {
      _paperOrientationContainer.style.display = "";
      if (_model.paperOrientation == Orientation.Portrait) {
        _paperOrientation.selectedIndex = 1; //portrait
      } else {
        _paperOrientation.selectedIndex = 0; //landscape
      }
    }
  }

  @override
  void onExit() {
    _bgColorController.onExit();
  }
}
