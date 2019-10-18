import 'dart:html';

abstract class PropertyGroup {
  Element _groupHeaderArrow;
  Element _groupContent;

  PropertyGroup(Element div) {
    _groupHeaderArrow = div.querySelector(".group_header_arrow");
    _groupContent = div.querySelector(".group_content");

    Element groupHeader = div.querySelector(".group_header");
    groupHeader.onClick.listen((_) => open = !open);
  }

  bool get open => _groupContent.style.display == "block";
  void set open(bool value) {
    _groupContent.style.display = value ? "block" : "none";
    _groupHeaderArrow.innerHtml = value ? "▼" : "►";
  }
}