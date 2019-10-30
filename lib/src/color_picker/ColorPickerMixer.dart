import 'dart:html';
import 'package:stagexl/stagexl.dart' as stageXL;

import '../property_windows/Tab.dart';
import '../helpers/ColorHelper.dart';
import '../view/MainWindow.dart';

class ColorPickerMixer extends Tab {
  stageXL.EventStreamSubscription _currentColorChangedSubscription;

  Element _complementary;
  Element _analogous;
  Element _triadic;
  Element _splitComplementary;
  Element _tetradic;

  ColorPickerMixer(Element view) : super(view) {
    _complementary = view.querySelector("#complementary");
    _analogous = view.querySelector("#analogous");
    _triadic = view.querySelector("#triadic");
    _splitComplementary = view.querySelector("#splitComplementary");
    _tetradic = view.querySelector("#tetradic");

    List<Element> swatches =
        view.getElementsByClassName("mixer_swatch").cast<Element>();

    for (Element swatch in swatches) {
      swatch.onClick.listen(_onSwatchClick);
      swatch.onMouseOver.listen(_onSwatchMouseOver);
      swatch.onMouseOut.listen(_onSwatchMouseOut);
    }
  }

  void _onSwatchMouseOut(_) {
    MainWindow.colorPicker.setPreviewPixelColor(MainWindow.colorPicker.currentColor);
  }

  void _onSwatchMouseOver(MouseEvent e) {
    Element swatch = e.currentTarget as Element;
    int color = ColorHelper.parseCssColor(swatch.style.backgroundColor);
    MainWindow.colorPicker.setPreviewPixelColor(color);
  }

  void _onSwatchClick(MouseEvent e) {
    Element swatch = e.currentTarget as Element;
    int color = ColorHelper.parseCssColor(swatch.style.backgroundColor);
    MainWindow.colorPicker.setSelectedPixelColor(color);
  }

  void _refreshComplementary() {
    List<Element> swatches =
        _complementary.getElementsByClassName("mixer_swatch").cast<Element>();

    int color = MainWindow.colorPicker.currentColor;
    color = ColorHelper.removeTransparency(color);

    swatches[0].style.backgroundColor = "#" + ColorHelper.colorToHex(color);

    List<num> hsv = ColorHelper.colorToHSVDecimals(color);
    num h = hsv[0];
    num s = hsv[1];
    num v = hsv[2];

    //if our saturation is at 0 then its a gray color, and changing the hue won't do much
    //in this case we flip the vibrance instead
    //there is an edge case where the vibrance is set to 0.5, and nothing will change
    //but i don't mind that too much
    if (s == 0) {
      v = 1 - v;
    } else {
      //if we do have some saturation then we spin the hue by 180 degress
      if (h > 0.5) {
        h -= 0.5;
      } else {
        h += 0.5;
      }
    }

    swatches[1].style.backgroundColor =
        "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
  }

  void _refreshAnalogous() {
    List<Element> swatches =
        _analogous.getElementsByClassName("mixer_swatch").cast<Element>();

    int color = MainWindow.colorPicker.currentColor;
    color = ColorHelper.removeTransparency(color);

    List<num> hsv = ColorHelper.colorToHSVDecimals(color);
    num h = hsv[0];
    num s = hsv[1];
    num v = hsv[2];

    //if our saturation is at 0 then its a gray color, and changing the hue won't do much
    //in this case we change the vibrance instead
    if (s == 0) {
      //if the vibrance is too close to 0 then the pre will be < 0
      //this is bad, and wrapping back round to 1 is also bad
      //we set the pre to the given color, and recalculate the same and post from that
      //we also do a similar thing if v is close to 1
      if (v < 1 / 12) {
        swatches[0].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[1].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 1 / 6));
        swatches[2].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 2 / 6));
      } else if (v > 11 / 12) {
        swatches[0].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[1].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 1 / 6));
        swatches[2].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 2 / 6));
      } else {
        swatches[0].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 1 / 12));
        swatches[1].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[2].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 1 / 12));
      }
    } else {
      //if we do have some saturation then we can modify the hue
      swatches[0].style.backgroundColor = "#" +
          ColorHelper.colorToHex(ColorHelper.HSVtoRGB((h - 1 / 12) % 1, s, v));
      swatches[1].style.backgroundColor =
          "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
      swatches[2].style.backgroundColor = "#" +
          ColorHelper.colorToHex(ColorHelper.HSVtoRGB((h + 1 / 12) % 1, s, v));
    }
  }

  void _refreshTriadic() {
    List<Element> swatches =
        _triadic.getElementsByClassName("mixer_swatch").cast<Element>();

    int color = MainWindow.colorPicker.currentColor;
    color = ColorHelper.removeTransparency(color);

    List<num> hsv = ColorHelper.colorToHSVDecimals(color);
    num h = hsv[0];
    num s = hsv[1];
    num v = hsv[2];

    //if our saturation is at 0 then its a gray color, and changing the hue won't do much
    //in this case we change the vibrance instead
    if (s == 0) {
      //if the vibrance is too close to 0 then the pre will be < 0
      //this is bad, and wrapping back round to 1 is also bad
      //we set the pre to the given color, and recalculate the same and post from that
      //we also do a similar thing if v is close to 1
      if (v < 1 / 3) {
        swatches[0].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[1].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 1 / 3));
        swatches[2].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 2 / 3));
      } else if (v > 2 / 3) {
        swatches[0].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[1].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 1 / 3));
        swatches[2].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 2 / 3));
      } else {
        swatches[0].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 1 / 3));
        swatches[1].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[2].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 1 / 3));
      }
    } else {
      //if we do have some saturation then we can modify the hue
      swatches[0].style.backgroundColor = "#" +
          ColorHelper.colorToHex(ColorHelper.HSVtoRGB((h - 1 / 3) % 1, s, v));
      swatches[1].style.backgroundColor =
          "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
      swatches[2].style.backgroundColor = "#" +
          ColorHelper.colorToHex(ColorHelper.HSVtoRGB((h + 1 / 3) % 1, s, v));
    }
  }

  void _refreshSplitComplementary() {
    List<Element> swatches = _splitComplementary
        .getElementsByClassName("mixer_swatch")
        .cast<Element>();

    int color = MainWindow.colorPicker.currentColor;
    color = ColorHelper.removeTransparency(color);

    List<num> hsv = ColorHelper.colorToHSVDecimals(color);
    num h = hsv[0];
    num s = hsv[1];
    num v = hsv[2];

    //if our saturation is at 0 then its a gray color, and changing the hue won't do much
    //in this case we change the vibrance instead
    if (s == 0) {
      //if the vibrance is too close to 0 then the pre will be < 0
      //this is bad, and wrapping back round to 1 is also bad
      //we set the pre to the given color, and recalculate the same and post from that
      //we also do a similar thing if v is close to 1
      if (v < 1 / 12) {
        swatches[0].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[1].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 9 / 12));
        swatches[2].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v + 11 / 12));
      } else if (v > 11 / 12) {
        swatches[0].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[1].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 9 / 12));
        swatches[2].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v - 11 / 12));
      } else {
        swatches[0].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, 1 - v - 1 / 12));
        swatches[1].style.backgroundColor =
            "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
        swatches[2].style.backgroundColor = "#" +
            ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, 1 - v + 1 / 12));
      }
    } else {
      //if we do have some saturation then we can modify the hue
      swatches[0].style.backgroundColor = "#" +
          ColorHelper.colorToHex(ColorHelper.HSVtoRGB((h + 5 / 12) % 1, s, v));
      swatches[1].style.backgroundColor =
          "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
      swatches[2].style.backgroundColor = "#" +
          ColorHelper.colorToHex(ColorHelper.HSVtoRGB((h + 7 / 12) % 1, s, v));
    }
  }

  void _refreshTetradic() {
    List<Element> swatches = _tetradic
        .getElementsByClassName("mixer_swatch")
        .cast<Element>();

    int color = MainWindow.colorPicker.currentColor;
    color = ColorHelper.removeTransparency(color);

    List<num> hsv = ColorHelper.colorToHSVDecimals(color);
    num h = hsv[0];
    num s = hsv[1];
    num v = hsv[2];

    //if our saturation is at 0 then its a gray color, and changing the hue won't do much
    //in this case we change the vibrance instead
    if (s == 0) {
      num v2 = v % 1 / 4;
      swatches[0].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v2));
      swatches[1].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v2 + 1 / 4));
      swatches[2].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v2 + 1 / 2));
      swatches[3].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v2 + 3 / 4));
    } else {
      swatches[0].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h - 1 / 6, s, v));
      swatches[1].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h, s, v));
      swatches[2].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h + 2 / 6, s, v));
      swatches[3].style.backgroundColor = "#" + ColorHelper.colorToHex(ColorHelper.HSVtoRGB(h + 3 / 6, s, v));
    }
  }

  void _onCurrentColorChanged(_) {
    _refreshComplementary();
    _refreshAnalogous();
    _refreshTriadic();
    _refreshSplitComplementary();
    _refreshTetradic();
  }

  @override
  void onEnter() {
    _currentColorChangedSubscription = MainWindow
        .colorPicker.onCurrentColorChanged
        .listen(_onCurrentColorChanged);
    _onCurrentColorChanged(null);
  }

  @override
  void onExit() {
    _currentColorChangedSubscription.cancel();
  }
}
