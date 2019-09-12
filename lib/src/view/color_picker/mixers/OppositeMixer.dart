import 'ColorMixerGroup.dart';

import '../ColorPicker.dart';
import '../ColorSwatch.dart';
import '../ColorHelper.dart';

class OppositeMixer extends ColorMixerGroup {
  ColorSwatch _same;
  ColorSwatch _opposite;

  OppositeMixer(ColorPicker colorPicker) : super(colorPicker, "Complementary") {
    _same = addSwatch();
    _opposite = addSwatch();
  }

  @override
  void refreshForColor(int color) {
    color = ColorHelper.removeTransparency(color);
    _same.color = color;

    List<num> hsv = ColorHelper.colorToHSVDecimals(color);
    num h = hsv[0];
    num s = hsv[1];
    num v = hsv[2];

    //if our saturation is at 0 then its a gray color, and changing the hue won't do much
    //in this case we flip the vibrance instead
    //there is an edge case where the vibrance is set to 0.5, and nothing will change
    //but i don't mind that too much
    if(s == 0) {
      v = 1 - v;
    } else {
      //if we do have some saturation then we spin the hue by 180 degress
      if(h > 0.5) {
        h -= 0.5;
      } else {
        h += 0.5;
      }
    }

    _opposite.color = ColorHelper.HSVtoRGB(h, s, v);
  }
}