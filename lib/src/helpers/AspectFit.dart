import 'package:stagexl/stagexl.dart';

Rectangle aspectFitChildInsideParent(num parentWidth, num parentHeight, num childWidth, num childHeight, {num padding = 0}) {
  parentWidth -= 2 * padding;
  parentHeight -= 2 * padding;

  num parentRatio = parentWidth / parentHeight;
  num childRatio = childWidth / childHeight;
  
  if(childRatio < parentRatio) {
    Rectangle rect = Rectangle(padding, padding, childRatio * parentHeight, parentHeight);
    rect.left += (parentWidth - rect.width) / 2;
    return rect;
  } else {
    Rectangle rect = Rectangle(padding, padding, parentWidth, parentWidth / childRatio);
    rect.top += (parentHeight - rect.height) / 2;
    return rect;
  }
}