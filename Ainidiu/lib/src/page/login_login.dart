import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/page/login_cadastro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  double getScreenHeight(
      BuildContext context, double divider, double multiplier) {
    return multiplier * MediaQuery.of(context).size.height / divider;
  }

  @override

  // ignore: override_on_non_overriding_member
  Widget buildLogo() {
    return Container(
        width: 100,
        height: getScreenHeight(context, 5, 1),
        child: Image.asset(
          "assets/icon/icon.png",
        ));
  }

  Widget buildCadastro() {
    var estilo = TextStyle(fontSize: 18, fontWeight: FontWeight.normal);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => Cadastro()));
            },
            child: Center(
              child: Container(
                  child: Text(
                'Cadastre-se',
                style: estilo,
              )),
            ))
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
                    SizedBox(
                      height: getScreenHeight(context, 30, 1),
                    ),
                    buildLogo(),
                    SizedBox(
                      height: getScreenHeight(context, 90, 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
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
                    SizedBox(
                      height: getScreenHeight(context, 100, 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
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
                      height: getScreenHeight(context, 20, 1),
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

                                String aux = await repository.login(
                                    _controladorEmail.text,
                                    _controladorSenha.text);

                                User user = await repository
                                    .carregarDadosDoUsuario(aux);

                                if (aux != '1' && aux != '2') {
                                  var prefs =
                                      await SharedPreferences.getInstance();

                                  prefs.setString('user', user.apelido);

                                  final FirebaseMessaging _firebaseMessaging =
                                      FirebaseMessaging();
                                  var token =
                                      await _firebaseMessaging.getToken();

                                  QuerySnapshot userDoc = await repository
                                      .getConexao()
                                      .collection('usuarios')
                                      .where('id', isEqualTo: user.id)
                                      .get();

                                  userDoc.docs[0].id;
                                  repository
                                      .getConexao()
                                      .collection('usuarios')
                                      .doc(userDoc.docs[0].id)
                                      .update({'token': token});

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage(0, usuario: user)),
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
