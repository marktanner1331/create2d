import 'package:stagexl/stagexl.dart';

void drawDash(Graphics graphics, Point start, Point end, num dashLength, num spaceLength) {
  num x1 = start.x;
  num y1 = start.y;
  num x2 = end.x;
  num y2 = end.y;

  num diffX = end.x - start.x;
  num diffY = end.y - start.y;
  
  num hyp = start.distanceTo(end);
  num units = hyp / (dashLength + spaceLength);
  num dashSpaceRatio = dashLength / (dashLength + spaceLength);
  num dashX = (diffX / units) * dashSpaceRatio;
  num spaceX = (diffX / units) - dashX;
  num dashY = (diffY / units) * dashSpaceRatio;
  num spaceY = (diffY / units) - dashY;

  graphics.moveTo(x1, y1);
  while (hyp > 0)
  {
    x1 += dashX;
    y1 += dashY;
    hyp -= dashLength;
    if (hyp < 0)
    {
      x1 = x2;
      y1 = y2;
    }
    graphics.lineTo(x1, y1);
    x1 += spaceX;
    y1 += spaceY;
    graphics.moveTo(x1, y1);
    hyp -= spaceLength;
  }
  graphics.moveTo(x2, y2);
}