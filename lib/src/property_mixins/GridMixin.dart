import '../view/Grid.dart';
import '../view/Canvas.dart';
import './InitializeMixins.dart';

mixin GridMixin on InitializeMixins {
  Grid grid;

  @override
  void initializeMixins() {
    super.initializeMixins();
    
    assert(this is Canvas);
    grid = Grid(this);
  }
}