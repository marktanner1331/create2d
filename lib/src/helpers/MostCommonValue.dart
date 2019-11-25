import 'dart:collection';

T mostCommonValue<T>(Iterable<T> values) {
  HashMap<T, int> map = HashMap();
  for(T value in values) {
    if(map.containsKey(value) == false) {
      map[value] = 1;
    } else {
      map[value]++;
    }
  }

  return map.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
}