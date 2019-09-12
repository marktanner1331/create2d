import 'ColorMixerGroup.dart';

import '../ColorPicker.dart';
import '../ColorSwatch.dart';
import '../ColorHelper.dart';

class TetradicMixer extends ColorMixerGroup {
  ColorSwatch _same;
  ColorSwatch _one;
  ColorSwatch _two;
  ColorSwatch _three;

  TetradicMixer(ColorPicker colorPicker) : super(colorPicker, "Tetradic") {
    _one = addSwatch();
    _same = addSwatch();
    _two = addSwatch();
    _three = addSwatch();
  }

  @override
  void refreshForColor(int color) {
    color = ColorHelper.removeTransparency(color);

    List<num> hsv = ColorHelper.colorToHSVDecimals(color);
    num h = hsv[0];
    num s = hsv[1];
    num v = hsv[2];

    //if our saturation is at 0 then its a gray color, and changing the hue won't do much
    //in this case we change the vibrance instead
    if(s == 0) {
      num v2 = v % 1/4;
      _one.color =  ColorHelper.HSVtoRGB(h, s, v2);
      _same.color = ColorHelper.HSVtoRGB(h, s, v2 + 1/4);
      _two.color = ColorHelper.HSVtoRGB(h, s, v2 + 1/2);
      _three.color = ColorHelper.HSVtoRGB(h, s, v2 + 3/4);
    } else {
      _one.color = ColorHelper.HSVtoRGB(h - 1/6, s, v);
      _same.color = ColorHelper.HSVtoRGB(h, s, v);
      _two.color = ColorHelper.HSVtoRGB(h + 2/6, s, v);
      _three.color = ColorHelper.HSVtoRGB(h + 3/6, s, v);
    }
  }
}