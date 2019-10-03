import 'package:stagexl/stagexl.dart';

import '../Styles.dart';
import '../widgets/TextButton.dart';

class Dialog extends Sprite {
  TextField _titleField;
  TextButton _okButton;
  TextField _messageField;

  //calls onComplete with the text of the button that was pressed e..g 'OK'
  Dialog(String title, String message, void onComplete(String buttonText)) {
    _titleField = TextField()
      ..textColor = Styles.dialogTitleText
      ..text = title
      ..mouseEnabled = false
      ..autoSize = TextFieldAutoSize.NONE;

    _titleField
      ..x = 3
      ..y = 2
      ..width = _titleField.textWidth
      ..height = _titleField.textHeight;

    _messageField = TextField()
      ..textColor = Styles.dialogText
      ..text = message;

    _messageField
      ..mouseEnabled = false
      ..multiline = true
      ..wordWrap = true
      ..autoSize = TextFieldAutoSize.NONE;

    _messageField
      ..x = 10
      ..y = _titleField.height + 10
      ..width = _messageField.textWidth + 1
      ..height = _messageField.textHeight;

    addChild(_messageField);

    num preferredWidth = _messageField.width + 20;

    addChild(_titleField);

    _okButton = TextButton("OK");
    _okButton
      ..x = (preferredWidth - _okButton.width) / 2
      ..y = (_messageField.y + _messageField.height + 10)
      ..onMouseClick.listen((_) => onComplete("OK"));
    addChild(_okButton);

    num preferredHeight = _okButton.y + _okButton.height + 10;

    graphics
      ..beginPath()
      ..rect(0, 0, preferredWidth, preferredHeight)
      ..fillColor(Styles.dialogBG)
      ..closePath();
    
    graphics
      ..beginPath()
      ..rect(0, 0, preferredWidth, _titleField.height + 5)
      ..fillColor(Styles.panelHeadBG)
      ..closePath();
  }
}