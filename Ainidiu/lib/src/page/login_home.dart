import 'package:flutter/material.dart';

import 'login_cadastro.dart';
import 'login_login.dart';

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  Widget buildLogo() {
    return Container(
      color: Colors.blue,
      width: 50,
      height: 50,
      child: Icon(Icons.favorite_border, size: 80, color: Colors.white,),
    );
  }

  Widget buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 50,),
        buildLogo(),
        SizedBox(height: 260,),
        Text(
      'SEJA\nBEM-VINDO AO\nAINIDIU',
      style: TextStyle(
        fontSize: 35,
        fontFamily: 'Montserrat'
      ),
    )
      ],
    );
  }

  Widget buildButton() {
    return FlatButton(
      onPressed: () {
        Navigator.push(this.context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      color: Colors.blue,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 25, bottom: 25, left: 90, right: 90),
        child: Text(
          'SIGN IN',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.blue)),
    );
  }

  Widget buildCadastro() {
    var estilo = TextStyle(fontSize: 18);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'É novo aqui?',
          style: estilo,
        ),
        FlatButton(
            onPressed: () {
              Navigator.push(this.context,
                MaterialPageRoute(builder: (context) => Cadastro()));
            },
            child: Container(
                width: 110,
                child: Text(
                  'Cadastre-se',
                  style: estilo,
                )))
      ],
    );
  }

  Widget buildTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[buildButton(), buildCadastro()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[buildText(), buildTest()],
              ),
            ],
          )),
    );
  }
}
