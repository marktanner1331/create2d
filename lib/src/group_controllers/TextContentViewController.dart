import 'dart:html';

import './ContextController.dart';
import '../property_mixins/TextContentMixin.dart';

class TextContentViewController extends ContextController {
  static TextContentViewController get instance =>
      _instance ?? (_instance = TextContentViewController());
  static TextContentViewController _instance;

  TextAreaElement _content;

  TextContentMixin _model;
  void set model(TextContentMixin value) => _model = value;

  TextContentViewController() : super(document.querySelector("#contextTab #textContent")) {
    _content = view.querySelector("#contentArea");
    _content.onInput.listen(_onTextContentChanged);
  }

  void _onTextContentChanged(_) {
    _model.content = _content.value;
  }

  void clearModels() => _model = null;

  @override
  void refreshProperties() {
    _content.value = _model.content;
  }
}