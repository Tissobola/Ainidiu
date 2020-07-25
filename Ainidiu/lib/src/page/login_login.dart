import 'package:ainidiu/src/page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  FbRepository repository = FbRepository();

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
        onTap: () {},
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Builder(
              builder: (context) => Container(
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                    child: TextFormField(
                      controller: _controladorEmail,
                      decoration: InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 10, right: 10),
                    child: TextFormField(
                      obscureText: true,
                      controller: _controladorSenha,
                      decoration: InputDecoration(
                          labelText: 'Senha', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        int aux = await repository.login(
                            _controladorEmail.text, _controladorSenha.text);
                        if (aux == 0) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HomePage()));
                        } else if(aux == 1) {
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Email não registrado!'), backgroundColor: Colors.red,));
                        }else{
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Senha incorreta!'), backgroundColor: Colors.red,));
                        }
                      }
                    },
                    child: Text('ok'),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
