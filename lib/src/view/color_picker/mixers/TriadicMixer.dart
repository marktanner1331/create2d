import 'ColorMixerGroup.dart';

import '../ColorPicker.dart';
import '../ColorSwatch.dart';
import '../ColorHelper.dart';

class TriadicMixer extends ColorMixerGroup {
  ColorSwatch _pre;
    ColorSwatch _same;
  ColorSwatch _post;

  TriadicMixer(ColorPicker colorPicker) : super(colorPicker, "Triadic") {
    _pre = addSwatch();
    _same = addSwatch();
    _post = addSwatch();
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
      //if the vibrance is too close to 0 then the pre will be < 0
      //this is bad, and wrapping back round to 1 is also bad
      //we set the pre to the given color, and recalculate the same and post from that
      //we also do a similar thing if v is close to 1
      if(v < 1/3) {
        _pre.color = ColorHelper.HSVtoRGB(h, s, v);
        _same.color = ColorHelper.HSVtoRGB(h, s, v + 1/3);
        _post.color = ColorHelper.HSVtoRGB(h, s, v + 2/3);
      } else if(v > 2/3) {
        _post.color = ColorHelper.HSVtoRGB(h, s, v);
        _same.color = ColorHelper.HSVtoRGB(h, s, v - 1/3);
        _pre.color = ColorHelper.HSVtoRGB(h, s, v - 2/3);
      } else {
        _pre.color = ColorHelper.HSVtoRGB(h, s, v - 1/3);
        _same.color = ColorHelper.HSVtoRGB(h, s, v);
        _post.color = ColorHelper.HSVtoRGB(h, s, v + 1/3);
      }
    } else {
      //if we do have some saturation then we can modify the hue
      _pre.color = ColorHelper.HSVtoRGB((h - 1/3) % 1, s, v);
      _same.color = ColorHelper.HSVtoRGB(h, s, v);
      _post.color = ColorHelper.HSVtoRGB((h + 1/3) % 1, s, v);
    }
  }
}