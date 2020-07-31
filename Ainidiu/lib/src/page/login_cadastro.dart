import 'package:ainidiu/src/page/login_login.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/page/login_home.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  FbRepository repository = FbRepository();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();
  final TextEditingController _controladorConfirmarSenha =
      TextEditingController();

  bool mas = false;
  bool fem = false;
  bool neu = false;

  String _currText = 'Neutro';
  List<String> generos = ["Masculino", "Feminino", "Neutro", "Selecionar"];

  String _avatar =
      'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png';
  double _tamanhoAlert = 200;

  Widget exibirFoto(url) {
    return FlatButton(
      onPressed: () {
        setState(() {
          _avatar = url;
        });
        Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  List<String> _urls = new List<String>();

  a() async {
    var storage = FirebaseStorage.instance;

    for (var i = 1; i < 7; i++) {
      String aux =
          await storage.ref().child('avatares/img ($i).png').getDownloadURL();
      _urls.add(aux);
    }

    return _urls;
  }

  Widget escolherFoto() {
    
      if (_currText == "Neutro") {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
                  child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  exibirFoto(_urls[0]),
                  exibirFoto(_urls[1]),
                  exibirFoto(_urls[2]),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  exibirFoto(_urls[3]),
                  exibirFoto(_urls[4]),
                  exibirFoto(_urls[5]),
                ],
              ),
              
            ],
          ),
        );
      } else if (_currText == "Masculino") {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
                  child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  exibirFoto(_urls[0]),
                  exibirFoto(_urls[1]),
                  exibirFoto(_urls[2]),
                ],
              ),
              
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
                  child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  exibirFoto(_urls[3]),
                  exibirFoto(_urls[4]),
                  exibirFoto(_urls[5]),
                ],
              ),
              
            ],
          ),
        );
      }
  }

  Column buildCheck() {
    return Column(
      children: <Widget>[
        CheckboxListTile(
          title: Text(generos[0]),
          value: mas,
          onChanged: (bool value) {
            if (value) {
              setState(() {
                mas = value;
                fem = false;
                neu = false;
                _currText = generos[0];
                Navigator.pop(context);
              });
            }
          },
        ),
        CheckboxListTile(
          title: Text(generos[1]),
          value: fem,
          onChanged: (bool value) {
            if (value) {
              setState(() {
                fem = value;
                mas = false;
                neu = false;
                _currText = generos[1];
                Navigator.pop(context);
              });
            }
          },
        ),
        CheckboxListTile(
          title: Text(generos[2]),
          value: neu,
          onChanged: (bool value) {
            if (value) {
              setState(() {
                neu = value;
                mas = false;
                fem = false;
                _currText = generos[2];
                Navigator.pop(context);
              });
            }
          },
        ),
      ],
    );
  }

  String validaSenha(value) {
    if (value.isEmpty) {
      return 'Campo Obrigatório';
    } else {
      if (value != _controladorConfirmarSenha.text) {
        return 'As duas senhas não correspondem';
      }
    }
    return null;
  }

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
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Widget buildCadastro() {
    var estilo = TextStyle(fontSize: 18);

    return Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '                Já tem uma conta?',
          style: estilo,
        ),
        FlatButton(
            onPressed: () {
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Container(
                width: 110,
                child: Text(
                  'Login',
                  style: estilo,
                )))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Builder(
        builder: (context) => Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
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
                      validator: validaSenha,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                    child: TextFormField(
                      obscureText: true,
                      controller: _controladorConfirmarSenha,
                      decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          border: OutlineInputBorder()),
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
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Text('Gênero'),
                            FlatButton(
                              child: Text(_currText),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                          child: buildCheck(),
                                          height: 180,
                                        ),
                                      );
                                    });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: <Widget>[
                            Text('Avatar'),
                            FlatButton(
                              child: Text('Selecionar Foto'),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FutureBuilder(
                                        future: a(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return AlertDialog(
                                              content: Container(
                                                height: _tamanhoAlert,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text('Carregando Imagens'),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    CircularProgressIndicator()
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return AlertDialog(
                                              elevation: 5,
                                              content: Container(
                                                child: escolherFoto(),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    });
                              },
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(_avatar),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Builder(
                    builder: (context) {
                      if (_loading) {
                        return CircularProgressIndicator();
                      } else {
                        return RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: Colors.blue)),
                          color: Colors.blue,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });

                              int aux = await repository.cadastro(
                                  _controladorEmail.text,
                                  _controladorSenha.text,
                                  _currText,
                                  _avatar);
                              if (aux == 0) {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Cadastro realizado!'),
                                  backgroundColor: Colors.blue,
                                ));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginHome()));
                              } else {
                                setState(() {
                                  _loading = false;
                                });
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Email já em uso!'),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 25, bottom: 25, left: 90, right: 90),
                            child: Text(
                              'CADASTRO',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  buildCadastro()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
