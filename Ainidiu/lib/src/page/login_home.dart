
import 'package:flutter/material.dart';
import 'package:login/src/pages/login_cadastro.dart';
import 'package:login/src/pages/login_login.dart';

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  @override
  // ignore: override_on_non_overriding_member
  Text buildLogo() {
    return Text(
      'AINIDIU',
      style: TextStyle(fontSize: 50, color: Colors.white),
    );
  }

  TextStyle estilo1() {
    return TextStyle(
      fontSize: 25,
      color: Colors.white,
    );
  }

  Row build1(texto, texto2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            texto,
            style: estilo1(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            texto2,
            textAlign: TextAlign.end,
            style: estilo1(),
          ),
        )
      ],
    );
  }

  FlatButton buildButton(texto, op) {
    return FlatButton(
        onPressed: () {
           if(op == 1) {
             Navigator.push(this.context, MaterialPageRoute(builder: (context) => LoginPage()));
           }else{
            Navigator.push(this.context, MaterialPageRoute(builder: (context) => CadastroPage()));
           }
        },
        child: Container(
          width: 171,
          color: Colors.white,
          child: Center(
            child: Text(
              texto,
              style: TextStyle(fontSize: 30),
            ),
          ),
        ));
  }

  Row build2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: buildButton('LOGIN', 1),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: buildButton('CADASTRO', 2),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 130,
            ),
            buildLogo(),
            SizedBox(
              height: 180,
            ),
            build1('JÁ TEM UMA\nCONTA?', 'É NOVO\nPOR AQUI?'),
            SizedBox(
              height: 50,
            ),
            build2(),
            SizedBox(
              height: 270,
            ),
            Text(
              'Termos de Serviço',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
