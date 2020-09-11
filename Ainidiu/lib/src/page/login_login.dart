import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/page/login_cadastro.dart';
import 'package:firebase_core/firebase_core.dart';
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
  bool _loading = false;

  FbRepository repository = FbRepository();

  @override

  // ignore: override_on_non_overriding_member
  Widget buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.blue,
            width: 60,
            height: 60,
            child: Icon(
              Icons.favorite_border,
              size: 90,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          'AINIDIU',
          style: TextStyle(fontSize: 20,),
        )
      ],
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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Builder(
        builder: (context) => Container(
            height: double.infinity,
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildLogo(),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 80.0, left: 20, right: 20),
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
                          const EdgeInsets.only(top: 10.0, left: 20, right: 20),
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
                    SizedBox(
                      height: 50,
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        if (_loading) {
                          return CircularProgressIndicator();
                        } else {
                          return RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(color: Colors.blue)),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _loading = true;
                                
                                });
                                
                                FirebaseApp  app = await Firebase.initializeApp();
                                
                                String aux = await repository.login(
                                    _controladorEmail.text,
                                    _controladorSenha.text);

                                User user = await repository
                                    .carregarDadosDoUsuario(aux);

                                if (aux != '1' && aux != '2') {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(usuario: user)),
                                      (route) => false);

                                  
                                } else if (aux == '1') {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  setState(() {
                                    _loading = false;
                                  });

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Email não registrado!'),
                                    backgroundColor: Colors.red,
                                  ));
                                } else {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  setState(() {
                                    _loading = false;
                                  });

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Senha incorreta!'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              }
                            },
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, bottom: 25, left: 90, right: 90),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    buildCadastro(),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
