import './ContextPropertyGroup.dart';
import '../property_mixins/SelectedSingleVertexMixin.dart';
import '../widgets/NumberFieldWithLabel.dart';

class SelectedSingleVertexGroup extends ContextPropertyGroup {
  SelectedSingleVertexMixin _myMixin;
  NumberFieldWithLabel _xField;
  NumberFieldWithLabel _yField;

  SelectedSingleVertexGroup(SelectedSingleVertexMixin myMixin) : super(myMixin, "Vertex") {
    _myMixin = myMixin;
    
    _xField = NumberFieldWithLabel("X");
    _xField.onValueChanged.listen(_onXChanged);
    addChild(_xField);

    _yField = NumberFieldWithLabel("Y");
    _yField.onValueChanged.listen(_onYChanged);
    addChild(_yField);

    relayout();
  }

  void refreshProperties() {
    _xField.value = _myMixin.x;
    _yField.value = _myMixin.y;
  }

  void _onXChanged(_) {
    _myMixin.x = _xField.value;
  }

  void _onYChanged(_) {
    _myMixin.y = _yField.value;
  }

  @override
  void relayout() {
    _xField
      ..x = 5
      ..y = 5;
    
    _yField
      ..x =  (preferredWidth / 2) + 5
      ..y = 5;
  }
}