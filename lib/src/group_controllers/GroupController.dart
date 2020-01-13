import 'dart:html';
import 'package:meta/meta.dart';

import '../helpers/IOnEnterExit.dart';

abstract class GroupController implements IOnEnterExit {
  Element _groupHeaderArrow;
  Element _groupContent;

  bool _hasOnEntered = false;

  GroupController(Element div) {
    _groupHeaderArrow = div.querySelector(".group_header_arrow");
    _groupContent = div.querySelector(".group_content");

    Element groupHeader = div.querySelector(".group_header");
    groupHeader.onClick.listen((_) {
      open = !open;
    });
  }

  void refreshProperties();

  bool get open => _groupContent.style.display == "block";
  void set open(bool value) {
    _groupContent.style.display = value ? "block" : "none";
    _groupHeaderArrow.innerHtml = value ? "▼" : "►";
  }

  void onExit() {}

  @override
  void onEnter() {
    if(_hasOnEntered == false) {
      onEnterForFirstTime();
      _hasOnEntered = true;
    }

    refreshProperties();
  }

  void onEnterForFirstTime() {

  }
}