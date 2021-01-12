import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlatButtonExt1 extends StatelessWidget {
  ///Botão sem forma, apenas texto  
  ///
  ///asdasd
  ///asd
  ///asd

  String _texto;
  Function _onPressed;
  var estilo = TextStyle(fontSize: 18, fontWeight: FontWeight.normal);

  FlatButtonExt1({@required String texto, @required Function onPressed}) {
    this._texto = texto;
    this._onPressed = onPressed;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            onPressed: _onPressed,
            child: Center(
              child: Container(
                  child: Text(
                _texto,
                style: estilo,
              )),
            ))
      ],
    );
  }
}
