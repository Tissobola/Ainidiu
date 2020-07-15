import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  @override

  // ignore: override_on_non_overriding_member
  Text buildLogo() {
    return Text(
      'AINIDIU',
      style: TextStyle(fontSize: 50, color: Colors.blue),
    );
  }

  Center builButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          
        },
        child: ClipOval(
          child: Container(
            color: Colors.blue,
            height: 70,
            width: 70,
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
              height: 70,
            ),
              buildLogo(),
              SizedBox(
              height: 80,
            ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _controladorEmail,
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _controladorSenha,
                  decoration: InputDecoration(
                      labelText: 'Senha', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
              height: 190,
            ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: builButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
