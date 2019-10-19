import 'package:stagexl/stagexl.dart';

import './ITool.dart';
import '../view/MainWindow.dart';
import '../stateful_graphics/Vertex.dart';
import '../property_mixins/SelectedSingleVertexMixin.dart';

class SelectTool extends ITool with SelectedSingleVertexMixin {
  List<Vertex> selectedVertices;

  //tracks the point in canvas space that the user mouse downed at
  //sometimes also updated on every onMouseMove to track the mouses position
  //only really used when moving multiple vertices at once
  Point _mouseDownPoint;

  SelectTool() {
    selectedVertices = List();
    onPropertiesChanged.listen(_onPropertiesChanged);
  }

  @override
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    super.onMouseDown(unsnappedMousePosition, snappedMousePosition);

    bool hasBlacklisted = false;
    _mouseDownPoint = unsnappedMousePosition;

    Vertex v = MainWindow.canvas.currentGraphics
        .getFirstVertexUnderPoint(unsnappedMousePosition, squareTolerance: 100, ignoreLockedVertices: true);
    
    if(v != null) {
      if(MainWindow.keyboardController.shiftIsDown) {
        //if the selected vertex is already selected then we deselect it
        if (selectedVertices.contains(v)) {
          selectedVertices.remove(v);

          //we want to remove the vertex from the selection
          //which is fine
          //but the user will still think its selected 
          //because the mouse is over it, causing a highlight
          //keeping it locked until the selection layer code has run will stop that
          hasBlacklisted = true;
        } else {
          selectedVertices.add(v);
          v.locked = true;
        }
      } else {
        if(selectedVertices.contains(v)) {
          //do nothing, user wants to move selected vertices
          v.locked = true;
        } else {
          for(Vertex oldVertex in selectedVertices) {
            oldVertex.locked = false;
          }

          //we are selecting a new vertex
          selectedVertices.clear();
          selectedVertices.add(v);
          v.locked = true;
        }
      }
    } else {
      //check shapes

      if(MainWindow.keyboardController.shiftIsDown) {
        //do nothing
        return;
      } else {
        //user has clicked part of the background
        //so we deselect all
        for(Vertex oldVertex in selectedVertices) {
          oldVertex.locked = false;
        }
        selectedVertices.clear();
      }
    }

    //now that we have updated what is selected
    //we can carry on with telling the rest of the tool about the updates
    //best to keep this code seperate to keep things simple
    //even if it does mean having a 'hasBlacklisted' boolean

    MainWindow.canvas.selectionLayer
        .deselectAllAndSelectVertices("SELECT_TOOL", selectedVertices);

    if(hasBlacklisted) {
      MainWindow.canvas.selectionLayer.selectedBlacklist.remove(v);
    }
      
    //any changes to the selected vertices will need a total context refresh
    //as the vertex is stored in the property group
    invalidateContext();
  }

  @override
  void onMouseUp(num x, num y) {
    super.onMouseUp(x, y);
    for(Vertex vertex in selectedVertices) {
      vertex.locked = false;
      MainWindow.canvas.currentGraphics.mergeVerticesUnderVertex(vertex);
    }
  }

  @override
  void onMouseMove(num x, num y) {
    if (selectedVertices.length == 1) {
      Vertex v = selectedVertices.first;
      v.x = x;
      v.y = y;

      //so the property windows update and teh canvas redraws
      invalidateProperties();
    } else if(selectedVertices.length != 0) {
      num deltaX = x - _mouseDownPoint.x;
      num deltaY = y - _mouseDownPoint.y;

      for(Point p in selectedVertices) {
        p.x += deltaX;
        p.y += deltaY;
      }

      _mouseDownPoint.x = x;
      _mouseDownPoint.y = y;

      //so the property windows update and teh canvas redraws
      invalidateProperties();
    }
  }

  void _onPropertiesChanged(_) {
    //so the canvas redraws
    MainWindow.canvas.invalidateVertexPositions();
  }
  
  @override
  String get id => "selectTool";

  @override
  String get tooltipText => "Select Tool";

  @override
  void onEnter() {
  }

  @override
  void onExit() {
    selectedVertices.clear();
    MainWindow.canvas.selectionLayer
        .deselectAllAndSelectVertices("SELECT_TOOL", selectedVertices);
    
    //wont worry about invalidating the context
    //as what ever is about be be onEntered will do it instead
  }
}
