import 'package:ainidiu/views/components/flat_button_ext/flat_button_ext1.dart';
import 'package:ainidiu/views/components/logo/logo.dart';
import 'package:ainidiu/views/components/raisedbutton_ext/raisedbutton_ext1.dart';
import 'package:ainidiu/views/components/responsividade/screen.dart';
import 'package:ainidiu/views/page/login_cadastro.dart';
import 'package:ainidiu/views/page/login_login.dart';
import 'package:flutter/material.dart';

class LoginHomeController {
  final screen = Screen();
  final logo = Logo();

  void loginButton(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void cadastroButton(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Cadastro()));
  }

  Widget buildText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: screen.getScreenHeight(context, 10, 1),
        ),
        logo.buildLogo(context, 100, 5, 1),
        SizedBox(
          height: screen.getScreenHeight(context, 20, 3),
        ),
        Text(
          'SEJA\nBEM-VINDO AO\nAINIDIU',
          style: TextStyle(fontSize: 35, fontFamily: 'Montserrat'),
        )
      ],
    );
  }

  Widget buttons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RaisedButtonExt1(
          text: 'Login',
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          onPressed: () => loginButton(context),
        ),
        FlatButtonExt1(texto: 'Cadastre-se', onPressed: () => cadastroButton(context)),
      ],
    );
  }
}
