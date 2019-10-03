import 'package:stagexl_main_menu/stagexl_main_menu.dart' as stagexl_main_menu;

import './DialogLayer.dart';

class MainMenu extends stagexl_main_menu.MainMenu {
  MainMenu() {
    addMenuItem("File")
      ..addMenuItem("New")
        .onMouseClick.listen(_onNewClick);
  }

  void _onNewClick(_) {
    DialogLayer.alert("New", (){});
  }
}