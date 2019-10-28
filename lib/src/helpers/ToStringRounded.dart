  String toStringRounded(num number) {
    String s = number.toStringAsFixed(2);
    if (s.endsWith('.00')) {
      return s.substring(0, s.length - 3);
    } else if (s.endsWith('0')) {
      return s.substring(0, s.length - 1);
    } else {
      return s;
    }
  }