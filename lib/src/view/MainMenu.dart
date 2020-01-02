import 'package:stagexl_main_menu/stagexl_main_menu.dart' as stagexl_main_menu;
import './MainWindow.dart';
import './DialogLayer.dart';

class MainMenu extends stagexl_main_menu.MainMenu {
  stagexl_main_menu.CheckboxMenuItem _showPropertyWindow;

  MainMenu() {
    addMenuItem("File")
      ..addMenuItem("New")
        .onMouseClick.listen(_onNewClick);
    
    stagexl_main_menu.MenuItem view = addMenuItem("View")
      ..onMouseClick.listen(_refreshViewMenu, priority: 1);

    view.addMenuItem("Zoom Out")
      ..onMouseClick.listen((_) {
        MainWindow.resetCanvasZoomAndPosition();
      });

    _showPropertyWindow = view.addCheckboxMenuItem("Show Property Window", true)
      ..onIsCheckedChanged.listen((_) {
        MainWindow.propertyWindow.visible = _showPropertyWindow.isChecked;
      });
  }

  void _refreshViewMenu(_) {
    _showPropertyWindow.isChecked = MainWindow.propertyWindow.visible;
  }

  void _onNewClick(_) {
    DialogLayer.alert("New", (){});
  }
}