import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RaisedButtonExt1 extends StatelessWidget {
  Color _backgroundColor;
  Color _textColor;
  String _text;
  Function _onPressed;

  RaisedButtonExt1(
      {String text,
      Function onPressed,
      Color backgroundColor,
      Color textColor}) {
    this._text = text;
    this._onPressed = onPressed;
    this._backgroundColor = backgroundColor;
    this._textColor = textColor;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: Colors.blue)),
      onPressed: _onPressed,
      color: _backgroundColor,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 25, bottom: 25, left: 90, right: 90),
        child: Text(
          _text,
          style: TextStyle(color: _textColor, fontSize: 18),
        ),
      ),
    );
  }
}
