import 'dart:collection';

import 'package:stagexl/stagexl.dart';
import 'package:stagexl/stagexl.dart' as stageXL;
import 'dart:html' as html;
import 'dart:math';

import '../stateful_graphics/IShape.dart';
import '../property_windows/ContextTab.dart';
import './ITool.dart';
import '../view/MainWindow.dart';
import '../stateful_graphics/Vertex.dart';
import '../property_mixins/SelectedObjectsMixin.dart';
import '../group_controllers/ContextController.dart';

class SelectTool extends ITool with SelectedObjectsMixin {
  HashSet<Vertex> selectedVertices;

  //the vertex we are currently dragging, or null if we aren't
  Vertex _currentVertex;

  List<IShape> selectedShapes;

  //tracks the point in canvas space that the user mouse downed at
  //sometimes also updated on every onMouseMove to track the mouses position
  //only really used when moving multiple vertices at once
  Point _mouseDownPoint;

  SelectTool() : super(html.document.querySelector("#selectTool")) {
    selectedVertices = HashSet();
    selectedShapes = List();
  }

  @override
  void onMouseDown(Point unsnappedMousePosition, Point snappedMousePosition) {
    super.onMouseDown(unsnappedMousePosition, snappedMousePosition);

    bool hasBlacklisted = false;
    _mouseDownPoint = unsnappedMousePosition;

    Vertex v = MainWindow.canvas.currentGraphics.getFirstVertexUnderPoint(
        unsnappedMousePosition,
        squareTolerance: 100,
        ignoreLockedVertices: true);

    if (v != null) {
      if (MainWindow.shortcutController.shiftIsDown) {
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
          _currentVertex = v;
        }
      } else {
        if (selectedVertices.contains(v)) {
          //do nothing, user wants to move selected vertices
          v.locked = true;
        } else {
          for (Vertex oldVertex in selectedVertices) {
            oldVertex.locked = false;
          }

          //we are selecting a new vertex
          selectedVertices.clear();
          selectedVertices.add(v);
          v.locked = true;
          _currentVertex = v;
          selectedShapes.clear();
        }
      }
    } else {
      if (MainWindow.shortcutController.shiftIsDown) {
        //do nothing
      } else {
        //user has clicked part of the background
        //so we deselect all
        for (Vertex oldVertex in selectedVertices) {
          oldVertex.locked = false;
        }
        selectedVertices.clear();
        _currentVertex = null;
      }

      //now its time for selecting shapes
      IShape shape = MainWindow.canvas.currentGraphics
          .getFirstShapeUnderPoint(unsnappedMousePosition);

      if (shape != null) {
        if (MainWindow.shortcutController.shiftIsDown) {
          if (selectedShapes.contains(shape)) {
            selectedShapes.remove(shape);

            //TODO: remove all selectedVertices
            //and then add all the ones that are part of the selected shapes
          } else {
            selectedShapes.add(shape);
            selectedVertices.addAll(shape.getVertices());
          }
        } else {
          selectedShapes.clear();
          selectedShapes.add(shape);
          selectedVertices.addAll(shape.getVertices());
        }
      } else {
        if (MainWindow.shortcutController.shiftIsDown) {
          //do nothing
        } else {
          selectedShapes.clear();
        }
      }
    }

    //now that we have updated what is selected
    //we can carry on with telling the rest of the tool about the updates
    //best to keep this code seperate to keep things simple
    //even if it does mean having a 'hasBlacklisted' boolean

    MainWindow.canvas.selectionLayer
        .deselectAllAndSelectVertices("SELECT_TOOL", selectedVertices);

    if (hasBlacklisted) {
      MainWindow.canvas.selectionLayer.selectedBlacklist.remove(v);
    }

    MainWindow.canvas.selectionLayer.deselectAllAndSelectShapes(selectedShapes);
    MainWindow.canvas.currentGraphics.removeInvalidShapes(selectedShapes);

    MainWindow.canvas.invalidateGraphics();

    //any changes to the selected vertices will need a total context refresh
    //as the vertex is stored in the property group
    ContextTab.refreshContext();
  }

  void selectShape(IShape shape) {
    //user has clicked part of the background
    //so we deselect all
    for (Vertex oldVertex in selectedVertices) {
      oldVertex.locked = false;
    }
    selectedVertices.clear();
    _currentVertex = null;

    selectedShapes.clear();
    selectedShapes.add(shape);
    selectedVertices.addAll(shape.getVertices());

    MainWindow.canvas.selectionLayer
        .deselectAllAndSelectVertices("SELECT_TOOL", selectedVertices);

    MainWindow.canvas.selectionLayer.deselectAllAndSelectShapes(selectedShapes);

    MainWindow.canvas.invalidateGraphics();

    //any changes to the selected vertices will need a total context refresh
    //as the vertex is stored in the property group
    ContextTab.refreshContext();
  }

  @override
  HashSet<ContextController> registerAndReturnViewControllers() {
    Map<ContextController, int> map = Map();

    for (IShape shape in selectedShapes) {
      for (ContextController controller
          in shape.registerAndReturnViewControllers()) {
        if (map.containsKey(controller) == false) {
          map[controller] = 1;
        } else {
          map[controller]++;
        }
      }
    }

    HashSet<ContextController> controllers =
        super.registerAndReturnViewControllers();

    for (ContextController key in map.keys) {
      if (map[key] == 1 || key.supportsMultipleModels) {
        controllers.add(key);
      }
    }

    return controllers;
  }

  @override
  void onMouseUp(num x, num y) {
    super.onMouseUp(x, y);
    for (Vertex vertex in selectedVertices) {
      vertex.locked = false;
    }

    MainWindow.canvas.currentGraphics.mergeInShapes(selectedShapes);
    MainWindow.canvas.currentGraphics.mergeInVertices(selectedVertices);

    _currentVertex = null;
  }

  @override
  void onMouseMove(num x, num y) {
    //TODO
    //test if we can always rely on the else if
    //we can't use the if anymore
    //as some shapes only have a single vertex
    if (false && selectedVertices.length == 1) {
      Vertex v = selectedVertices.first;
      v.x = x;
      v.y = y;

      //so the property windows update and the canvas redraws
      ContextTab.refreshProperties();
      MainWindow.canvas.invalidateVertexPositions();
    } else if (selectedVertices.length != 0) {
      num deltaX = x - _mouseDownPoint.x;
      num deltaY = y - _mouseDownPoint.y;

      for (Point p in selectedVertices) {
        p.x += deltaX;
        p.y += deltaY;
      }

      _mouseDownPoint.x = x;
      _mouseDownPoint.y = y;

      //so the property windows update and the canvas redraws
      ContextTab.refreshProperties();
      MainWindow.canvas.invalidateVertexPositions();
    }
  }

  @override
  String get tooltipText => "Select Tool";

  @override
  String get shortName => "se";

  @override
  void onEnter() {}

  @override
  void onExit() {
    selectedVertices.clear();
    selectedShapes.clear();
    _currentVertex = null;

    MainWindow.canvas.selectionLayer
        .deselectAllAndSelectVertices("SELECT_TOOL", selectedVertices);

    //wont worry about invalidating the context
    //as what ever is about be be onEntered will do it instead
  }

  @override
  Iterable<stageXL.Point> getSnappablePoints() {
    if (_currentVertex == null) {
      return [];
    }

    return MainWindow.canvas.currentGraphics
        .getAllVerticesConnectedToVertex(_currentVertex);
  }

  void deleteSelectedObjects() {
    //if we have only selected vertices then
    //we probably want to actually delete those vertices
    if(selectedShapes.length == 0) {
      MainWindow.canvas.currentGraphics.deleteVertices(selectedVertices);
    } else {
      //but if we have shapes selected, probably best just to delete those
      MainWindow.canvas.currentGraphics.deleteShapes(HashSet<IShape>()..addAll(selectedShapes));
    }

    _deselectAll();
    MainWindow.canvas.invalidateVertices();
  }

  void _deselectAll() {
    for (Vertex oldVertex in selectedVertices) {
      oldVertex.locked = false;
    }

    selectedVertices.clear();
    selectedShapes.clear();
    _currentVertex = null;

    MainWindow.canvas.selectionLayer.deselectAllVertices("SELECT_TOOL");
    MainWindow.canvas.selectionLayer.deselectAllShapes();
  }

  @override
  void contextPropertiesHaveChanged() {
    MainWindow.canvas.invalidateVertices();
  }
}
