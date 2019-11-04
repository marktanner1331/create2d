import 'dart:html';

import '../property_windows/Tab.dart';
import '../helpers/ColorHelper.dart';
import '../view/MainWindow.dart';

class ColorPickerPalette extends Tab {
  List<String> _colors;

  ColorPickerPalette(Element view) : super(view) {
  }

  @override
  void initialize() {
    _colors = [
      "000000", "330604", "8C5600", "AE8422", "004214", "004647", "00167B", "331E54", "782964",
      "1A1A1A", "4D0806", "B95800", "D28e00", "006602", "006A6B", "041F9b", "4F107A", "9F1888",
      "333333", "7D0E0A", "DF5A00", "F4AA00", "008804", "00898B", "0329C4", "512698", "B70B9B",
      "4D4D4D", "B3130E", "FF5D00", "F3D400", "00A406", "00B5B6", "0233E9", "83389B", "C821AC",
      "666666", "E61912", "FF8C00", "FBE700", "5CC151", "00DBDD", "548FFF", "9F60B5", "D630AE",
      "808080", "FF1C14", "FFA200", "F6EC5A", "92DC3F", "06EFE7", "7CB5F4", "C78CDA", "E85DBD",
      "999999", "F15D5D", "FFC550", "EEE88D", "BFEB8D", "92FCE5", "9ED1F9", "D7AAE3", "F9A5D5",
      "CCCCCC", "FF938F", "FED189", "F2F0BC", "D1EBB3", "B6FCF0", "B4E1FE", "E2C9F9", "F9C5DC",
      "E6E6E6", "FFCFCE", "FFE9B1", "FFFDE3", "E7F3DA", "DAFCF8", "C5EEFD", "F1D9FD", "FBD9E8",
      "FFFFFF", "FFE4E4", "FFF5E0", "FFFEEE", "EBF5ED", "EBFDFF", "DCF2FD", "FAEAFF", "FDEAED"];

    TableElement table = view.querySelector("table");
    
    int columns = 9;
    int i = 1;

    TableRowElement row;
    for(String color in _colors) {
      if(i % columns == 1) {
        row = table.addRow();
      }

      TableCellElement cell = row.addCell();
      cell.classes.add("palette_swatch");
      cell.style.backgroundColor = "#" + color;
      cell.onMouseMove.listen(_onCellMouseOver);
      cell.onMouseOut.listen(_onCellMouseOut);
      cell.onClick.listen(_onCellClick);
      cell.setAttribute("value", color.toString());
      i++;
    }
  }

  void _onCellMouseOver(MouseEvent e) {
    String backgroundColor = (e.currentTarget as Element)?.getAttribute("value");
    if(backgroundColor != null) {
      MainWindow.colorPicker.setPreviewPixelColor(ColorHelper.parseHexColor(backgroundColor));
    }
  }

  void _onCellMouseOut(_) {
    MainWindow.colorPicker.setPreviewPixelColor(MainWindow.colorPicker.currentColor);
  }

  void _onCellClick(MouseEvent e) {
    String backgroundColor = (e.currentTarget as Element)?.getAttribute("value");
    if(backgroundColor != null) {
      MainWindow.colorPicker.setSelectedPixelColor(ColorHelper.parseHexColor(backgroundColor));
    }
  }

  @override
  void onExit() {
  }
}