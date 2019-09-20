import 'package:stagexl/stagexl.dart';

import './ITool.dart';
import '../view/MainWindow.dart';
import '../stateful_graphics/Vertex.dart';
import '../property_mixins/SelectedSingleVertexMixin.dart';

class SelectTool extends ITool with SelectedSingleVertexMixin {
  List<Vertex> selectedVertices;

  SelectTool() {
    selectedVertices = List();
  }

  @override
  void onMouseDown(num x, num y) {
    super.onMouseDown(x, y);
    
    Vertex v = MainWindow.canvas.currentGraphics
          .getFirstVertexUnderPoint(Point(x, y), 100);

    if(v == null && selectedVertices.length == 0) {
      //nothing changed
      return;
    } else if(v != null && selectedVertices.length == 1 && selectedVertices.first == v) {
      //nothing changed
      return;
    }

    selectedVertices.clear();
    if(v != null) {
      selectedVertices.add(v);
    }

    MainWindow.canvas.selectionLayer.deselectAllAndSelectVertices("SELECT_TOOL", selectedVertices);
    
    //any changes to the selected vertices will need a total context refresh
    //as the vertex is stored in the property group
    invalidateContext();
  }

  void invalidateVertexPositions() => MainWindow.canvas.invalidateVertexPositions();

  @override
  void onMouseUp(num x, num y) {
    super.onMouseUp(x, y);

    // _currentLine = null;
    // MainWindow.canvas.mergeInTemporaryLayer(_currentGraphics);
    // _currentGraphics = null;
    // MainWindow.canvas.invalidateVertices();
  }

  @override
  void onMouseMove(num x, num y) {
    assert(isActive == false);
    
    // _currentLine.end.x = x;
    // _currentLine.end.y = y;

    // MainWindow.canvas.invalidateVertexPositions();
  }

  @override
  DisplayObject getIcon() {
    TextField tf = TextField("S");
    
    return tf
      ..autoSize = TextFieldAutoSize.NONE
      ..width = tf.textWidth
      ..height = tf.textHeight;
  }

  @override
  String get name => "Select";
}