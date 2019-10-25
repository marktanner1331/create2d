import '../model/CanvasUnitType.dart';
import 'package:meta/meta.dart';

String _toStringRounded(num number) {
  String s = number.toStringAsPrecision(2);
  if (s.endsWith('.00')) {
    return s.substring(0, s.length - 3);
  } else if (s.endsWith('0')) {
    return s.substring(0, s.length - 1);
  } else {
    return s;
  }
}

abstract class UnitsHelper {
  CanvasUnitType get type;

  static UnitsHelper getUnitsHelper(CanvasUnitType type) {
    switch (type) {
      case CanvasUnitType.PIXEL:
        return _PixelHelper();
      case CanvasUnitType.INCH:
        return _InchHelper();
      case CanvasUnitType.MM:
        return _MMHelper();
      case CanvasUnitType.CM:
        return _CMHelper();
      case CanvasUnitType.M:
        return _MHelper();
      case CanvasUnitType.KM:
        return _KMHelper();
      case CanvasUnitType.FEET:
        return _FeetHelper();
      case CanvasUnitType.MILE:
        return _MileHelper();
    }
  }

  num unitsToPixels(String s);
  String pixelsToUnits(num p);
}

class _MileHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.MILE;

  @override
  num unitsToPixels(String s) {
    if (s.endsWith("m")) {
      s = s.substring(0, s.length - 1);
    } else if (s.endsWith("mi")) {
      s = s.substring(0, s.length - 2);
    }

    return num.tryParse(s);
  }

  @override
  String pixelsToUnits(num p) {
    return _toStringRounded(p) + "mi";
  }
}

class _FeetHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.FEET;

  @override
  num unitsToPixels(String s) {
    RegExp regex = RegExp("^(\\d+) ?(?:(?:')|(?:ft))?-? ?(\\d+)? ?(?:\")?\$");
    Match match = regex.firstMatch(s);

    if (match == null) {
      return null;
    }

    String feetString = match.group(1);
    String inchString = match.group(2);

    if (feetString == null) {
      return null;
    }

    num n = num.parse(feetString);

    if (inchString != null) {
      n += num.parse(inchString) / 12;
    }

    //if 6'6 is passed in then 6.5 is returned
    return n;
  }

  @override
  String pixelsToUnits(num p) {
    num feet = p.floor();
    num inches = (p % 1) * 12;
    return "${feet}ft" + _toStringRounded(inches);
  }
}

class _KMHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.KM;

  @override
  num unitsToPixels(String s) {
    if (s.endsWith("km")) {
      s = s.substring(0, s.length - 2);
    }

    return num.tryParse(s);
  }

  @override
  String pixelsToUnits(num p) {
    return _toStringRounded(p) + "km";
  }
}

class _MHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.M;

  @override
  num unitsToPixels(String s) {
    if (s.endsWith("m")) {
      s = s.substring(0, s.length - 1);
    }

    return num.tryParse(s);
  }

  @override
  String pixelsToUnits(num p) {
    return _toStringRounded(p) + "m";
  }
}

class _CMHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.CM;

  @override
  num unitsToPixels(String s) {
    if (s.endsWith("cm")) {
      s = s.substring(0, s.length - 2);
    }

    return num.tryParse(s);
  }

  @override
  String pixelsToUnits(num p) {
    return _toStringRounded(p) + "cm";
  }
}

class _MMHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.MM;

  @override
  num unitsToPixels(String s) {
    if (s.endsWith("mm")) {
      s = s.substring(0, s.length - 2);
    }

    return num.tryParse(s);
  }

  @override
  String pixelsToUnits(num p) {
    return _toStringRounded(p) + "mm";
  }
}

class _InchHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.INCH;

  @override
  num unitsToPixels(String s) {
    if (s.endsWith("\"")) {
      s = s.substring(0, s.length - 1);
    }

    return num.tryParse(s);
  }

  @override
  String pixelsToUnits(num p) {
    return _toStringRounded(p) + "\"";
  }
}

class _PixelHelper extends UnitsHelper {
  @override
  CanvasUnitType get type => CanvasUnitType.PIXEL;

  @override
  num unitsToPixels(String s) {
    if (s.endsWith("px")) {
      s = s.substring(0, s.length - 2);
    }

    return num.tryParse(s);
  }

  @override
  String pixelsToUnits(num p) {
    return _toStringRounded(p) + "px";
  }
}
