import 'dart:math' as math;

class ColorHelper {
  static int removeTransparency(int color) {
    return color | 0xff000000;
  }

  ///sets the alpha component of the given color to the given alpha value
  ///the alpha value should be in the range 0-255
  static int setAlpha(int color, int alpha) {
    color &= 0x00ffffff;
    alpha <<= 24;
    return color | alpha;
  }

  static bool isCompletelyOpaque(int color) {
    return (color >> 24) == 0xff;
  }

  static bool isCompletelyTransparent(int color) {
    return (color >> 24) == 0;
  }

  static String colorToHex(int color) {
    if((color >> 24) == 0xff) {
      //if its opaque we can chop off the front
      color &= 0x00ffffff;
      return color.toRadixString(16).padLeft(6, '0').toUpperCase();
    } else {
      return color.toRadixString(16).padLeft(8, '0').toUpperCase();
    }
  }

  static int colorFromRGB(int r, int g, int b) {
    return (((((0xff << 8) | r) << 8) | g) << 8) | b;
  }

  static List<num> colorToHSVDecimals(int color) {
    num r = ((color >> 16) & 0xff) / 0xff;
    num g = ((color >> 8) & 0xff) / 0xff;
    num b = (color & 0xff) / 0xff;
    
    return RGBDecimalsToHSVDecimals(r, g, b);
  }

  ///converts RGB to HSV with given RGB components in the range 0-1
  ///the resultant HSV values will also be decimals
  static List<num> RGBDecimalsToHSVDecimals(num r, num g, num b) {
    num max = math.max(math.max(r, g), b);
    num min = math.min(math.min(r, g), b);

    num d = max - min;
    
    num h;
    num s = max == 0 ? 0 : d / max;
    num v = max;
    
    if(max == min) {
      h = 0;
    } else if(max == r) {
      h = (g - b) + d * (g < b ? 6: 0); 
      h /= 6 * d;
    } else if(max == g) {
      h = (b - r) + d * 2; 
      h /= 6 * d;
    } else {
      h = (r - g) + d * 4; 
      h /= 6 * d;
    }
    
    return [h, s, v].toList();
}

  ///HSV components should be in the range 0-1
  static int HSVtoRGB(num h, num s, num v) {
    num r;
    num g;
    num b;
    
    int i = (h * 6).floor();
    num f = h * 6 - i;
    num p = v * (1 - s);
    num q = v * (1 - f * s);
    num t = v * (1 - (1 - f) * s);

    switch (i % 6) {
        case 0: 
        r = v; 
        g = t; 
        b = p; 
        break;
        case 1: 
        r = q; 
        g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
    }

    return colorFromRGB((r * 255).round(), (g * 255).round(), (b * 255).round());
  }
}