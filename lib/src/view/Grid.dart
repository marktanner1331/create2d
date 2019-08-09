import 'package:stagexl/stagexl.dart';

import '../model/GridGeometryType.dart';
import '../model/GridDisplayType.dart';

import '../view/Canvas.dart';
import '../ErrorLogger.dart';

import 'dart:math' as math;

class Grid extends Sprite {
  //TODO
  //expose interface for snapping

  Canvas _canvas;
  EventStreamSubscription<Event> _gridChangedSubscription;

  Grid(Canvas canvas) {
    _canvas = canvas;
  }

  void dispose() {
    _gridChangedSubscription.cancel();
  }

  void refresh() {
    graphics.clear();

    if (_canvas.gridDisplayType == GridDisplayType.None) {
      return;
    }

    switch (_canvas.gridGeometryType) {
      case GridGeometryType.Isometric:
        switch (_canvas.gridDisplayType) {
          case GridDisplayType.Lines:
            _refreshIsometricLines();
            break;
          case GridDisplayType.Dots:
            _refreshIsometricDots();
            break;
          default:
            ErrorLogger.warn("unknown grid display type: ${_canvas.gridDisplayType}");
            return;
        }
        break;
      case GridGeometryType.Square:
        switch (_canvas.gridDisplayType) {
          case GridDisplayType.Lines:
            _refreshSquareLines();
            break;
          case GridDisplayType.Dots:
            _refreshSquareDots();
            break;
          default:
            ErrorLogger.warn("unknown grid display type: ${_canvas.gridDisplayType}");
            return;
        }
        break;
      default:
        ErrorLogger.warn("unknown grid geometry type: ${_canvas.gridGeometryType}");
        return;
    }
  }

  //gets the closest grid point to the given point
  Point getClosestPoint(num x, num y) {
    switch(_canvas.gridGeometryType) {
      case GridGeometryType.Square:
        return _getClosestSquarePoint(x, y);
      case GridGeometryType.Isometric:
        return _getClosestIsometricPoint(x, y);
      default:
        return Point(x, y);
    }
  }

  Point _getClosestIsometricPoint(num x, num y) {
    num horizontalStep = 0.866 * _canvas.gridStep;

    //find the closest vertical line
    //we do this differently to the code in _getClosestSquarePoint
    //because we need to know whether its an even line or an odd line
    int ci = (x / horizontalStep).round();
    num cx = ci * horizontalStep;

    bool isEven = (ci & 1) == 0;

    //if its an even line the y needs to be shifted up by half a step
    num cy;
    if(isEven) {
      y -= _canvas.gridStep / 2;

      //find the closest horizontal line
      cy = y - (y % _canvas.gridStep);
      if((y - cy) * 2 > _canvas.gridStep) {
        cy += _canvas.gridStep;
      }

      cy += _canvas.gridStep / 2;
    } else {
      //find the closest horizontal line
      cy = y - (y % _canvas.gridStep);
      if((y - cy) * 2 > _canvas.gridStep) {
        cy += _canvas.gridStep;
      }
    }

    return Point(cx, cy);
  }

  Point _getClosestSquarePoint(num x, num y) {
    //find the closest vertical line
    num cx = x - (x % _canvas.gridStep);
    if((x - cx) * 2 > _canvas.gridStep) {
      cx += _canvas.gridStep;
    }
    
    //find the closest horizontal line
    num cy = y - (y % _canvas.gridStep);
    if((y - cy) * 2 > _canvas.gridStep) {
      cy += _canvas.gridStep;
    }
    
    return Point(cx, cy);
  }

  void _refreshSquareLines() {
    num xDelta = _canvas.gridStep;
    while (xDelta < _canvas.canvasWidth) {
      graphics.beginPath();
      graphics.moveTo(xDelta, 0);
      graphics.lineTo(xDelta, _canvas.canvasHeight);
      graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);
      graphics.closePath();

      xDelta += _canvas.gridStep;
    }

    num yDelta = _canvas.gridStep;
    while (yDelta < _canvas.canvasHeight) {
      graphics.beginPath();
      graphics.moveTo(0, yDelta);
      graphics.lineTo(_canvas.canvasWidth, yDelta);
      graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);
      graphics.closePath();

      yDelta += _canvas.gridStep;
    }
  }

  void _refreshSquareDots() {
    num yDelta = _canvas.gridStep;

    while (yDelta < _canvas.canvasHeight) {
      num xDelta = _canvas.gridStep;
      while (xDelta < _canvas.canvasWidth) {
        graphics.beginPath();
        graphics.circle(xDelta, yDelta, _canvas.gridThickness);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);
        graphics.closePath();

        xDelta += _canvas.gridStep;
      }

      yDelta += _canvas.gridStep;
    }
  }

  void _refreshIsometricLines() {
    num horizontalStep = 0.866 * _canvas.gridStep;
    num doubleHorizontalStep = horizontalStep * 2;
    num verticalStep = _canvas.gridStep;

    //xDelta is the position along the top of the screen
    num xDelta = horizontalStep;
    while (xDelta <= _canvas.canvasWidth) {
      graphics.moveTo(xDelta, 0);
      graphics.lineTo(xDelta, _canvas.canvasHeight);
      graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

      xDelta += horizontalStep;
    }

    xDelta = horizontalStep;

    //yDelta is the position along the left edge of the screen
    num yDelta = verticalStep / 2;
    while (xDelta <= _canvas.canvasWidth && yDelta <= _canvas.canvasHeight) {
      graphics.moveTo(0, yDelta);
      graphics.lineTo(xDelta, 0);
      graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

      xDelta += doubleHorizontalStep;
      yDelta += verticalStep;
    }

    if (xDelta >= _canvas.canvasWidth) {
      //yDelta2 is the position along the right edge of the screen
      num yDelta2 = yDelta - _canvas.canvasWidth * 0.577;

      while (yDelta <= _canvas.canvasHeight) {
        graphics.moveTo(0, yDelta);
        graphics.lineTo(_canvas.canvasWidth, yDelta2);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        yDelta += verticalStep;
        yDelta2 += verticalStep;
      }

      //we should now be at a point where we reached the bottom left
      //yDelta will be at its max value

      //now we run along the bottom side
      //xDelta2 is the position along the bottom of the screen
      num xDelta2 =
          _canvas.canvasWidth - (_canvas.canvasHeight - yDelta2) * 1.732;

      while (xDelta2 <= _canvas.canvasWidth) {
        graphics.moveTo(xDelta2, _canvas.canvasHeight);
        graphics.lineTo(_canvas.canvasWidth, yDelta2);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        xDelta2 += doubleHorizontalStep;
        yDelta2 += verticalStep;
      }
    } else {
       //we have hit the bottom left of the screen
      //so we go along the top and bottom now

      //xDelta2 is the position along the bottom of the screen
      num xDelta2 = xDelta - _canvas.canvasHeight * 1.732;
      while(xDelta <= _canvas.canvasWidth) {
        graphics.moveTo(xDelta, 0);
        graphics.lineTo(xDelta2, _canvas.canvasHeight);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        xDelta += doubleHorizontalStep;
        xDelta2 += doubleHorizontalStep;
      }

      //we have now hit the right edge, so we need to start going down it
      num yDelta2 = _canvas.canvasHeight - (_canvas.canvasWidth - xDelta2) * 0.577;
      while (xDelta2 <= _canvas.canvasWidth) {
        graphics.moveTo(xDelta2, _canvas.canvasHeight);
        graphics.lineTo(_canvas.canvasWidth, yDelta2);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        xDelta2 += doubleHorizontalStep;
        yDelta2 += verticalStep;
      }
    }

    //now for the other diagonal lines
    //start at the far right
    //the vertical lines start one horizontal step in
    //and then we get diagonal lines on every other vertical line
    //so we set xDelta to be the last vertical line that gets a horizontal line
    xDelta = _canvas.canvasWidth -
        ((_canvas.canvasWidth - horizontalStep) % (horizontalStep * 2));

    //then we find its corresonding point on the right edge
    num yDelta2 = (_canvas.canvasWidth - xDelta) * 0.577;

    while (xDelta >= 0 && yDelta2 <= _canvas.canvasHeight) {
      graphics.moveTo(xDelta, 0);
      graphics.lineTo(_canvas.canvasWidth, yDelta2);
      graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

      xDelta -= doubleHorizontalStep;
      yDelta2 += verticalStep;
    }

    //if we hit the left edge first, we start going down the screen
    if (xDelta < 0) {
      yDelta = verticalStep / 2;
      while (yDelta2 <= _canvas.canvasHeight) {
        graphics.moveTo(0, yDelta);
        graphics.lineTo(_canvas.canvasWidth, yDelta2);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        yDelta += verticalStep;
        yDelta2 += verticalStep;
      }

      //now we have hit the bottom right corner
      //so we travel down the left edge and left along the bottom
      num xDelta2 = (_canvas.canvasHeight - yDelta) * 1.732;
      
      while (xDelta2 >= 0) {
        graphics.moveTo(0, yDelta);
        graphics.lineTo(xDelta2, _canvas.canvasHeight);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        xDelta2 -= doubleHorizontalStep;
        yDelta += verticalStep;
      }
    } else {
      //we have reached the bottom right edge
      //we now go along the top and bottom edges

      //xDelta2 is the position along the bottom of the screen
      num xDelta2 = xDelta + _canvas.canvasHeight * 1.732;

      while(xDelta >= 0) {
        graphics.moveTo(xDelta, 0);
        graphics.lineTo(xDelta2, _canvas.canvasHeight);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        xDelta -= doubleHorizontalStep;
        xDelta2 -= doubleHorizontalStep;
      }

      //and finally we go along the left edge and bottom edge
      yDelta = verticalStep / 2;
      while(yDelta < _canvas.canvasHeight) {
        graphics.moveTo(0, yDelta);
        graphics.lineTo(xDelta2, _canvas.canvasHeight);
        graphics.strokeColor(_canvas.gridColor, _canvas.gridThickness);

        xDelta2 -= doubleHorizontalStep;
        yDelta += verticalStep;
      }
    }
  }

  void _refreshIsometricDots() {
    num horizontalStep = 0.866 * _canvas.gridStep;
    num doubleHorizontalStep = horizontalStep * 2;
    num verticalStep = _canvas.gridStep;

    //we do this in two parts
    //first every other vertical line
    //then those in between
    //this helps as we don't need to worry about yDelta's starting at different places
    
    num xDelta = 0;
    while(xDelta <= _canvas.canvasWidth) {
      num yDelta = verticalStep / 2;

      while(yDelta <= _canvas.canvasHeight) {
        graphics.beginPath();
        graphics.circle(xDelta, yDelta, _canvas.gridThickness);
        graphics.fillColor(_canvas.gridColor);
        graphics.closePath();

        yDelta += verticalStep;
      }

      xDelta += doubleHorizontalStep;
    }

    //now we fill in every other vertical line that we missed
    //notice that yDelta is set to something different to the above code
    //its the only change

    xDelta = horizontalStep;
    while(xDelta <= _canvas.canvasWidth) {
      num yDelta = 0;

      while(yDelta <= _canvas.canvasHeight) {
        graphics.beginPath();
        graphics.circle(xDelta, yDelta, _canvas.gridThickness);
        graphics.fillColor(_canvas.gridColor);
        graphics.closePath();

        yDelta += verticalStep;
      }

      xDelta += doubleHorizontalStep;
    }
  }
}
