import 'package:ainidiu/src/page/login_login.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _controladorCidade = TextEditingController();
  final TextEditingController _controladorNascimento = TextEditingController();

  bool mas = false;
  bool fem = false;
  bool neu = false;

  String _currText = 'Selecionar';
  List<String> generos = ["Masculino", "Feminino", "Outro", "Selecionar"];

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
  List<String> _urlsMan = new List<String>();
  List<String> _urlsWoman = new List<String>();

  getUrl() async {
    var storage = FirebaseStorage.instance;

    for (var i = 1; i <= 7; i++) {
      String aux = await storage
          .ref()
          .child('avatares/man/man ($i).png')
          .getDownloadURL();
      _urls.add(aux);
      _urlsMan.add(aux);
    }

    for (var i = 1; i <= 6; i++) {
      String aux = await storage
          .ref()
          .child('avatares/woman/woman ($i).png')
          .getDownloadURL();
      _urls.add(aux);
      _urlsWoman.add(aux);
    }

    return _urls;
  }

  Widget escolherFoto() {
    if (_currText == "Feminino") {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              exibirFoto(_urlsWoman[0]),
              exibirFoto(_urlsWoman[1]),
              exibirFoto(_urlsWoman[2]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urlsWoman[3]),
              exibirFoto(_urlsWoman[4]),
              exibirFoto(_urlsWoman[5]),
            ],
          ),
        ],
      );
    } else if (_currText == "Masculino") {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              exibirFoto(_urlsMan[0]),
              exibirFoto(_urlsMan[1]),
              exibirFoto(_urlsMan[2]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urlsMan[3]),
              exibirFoto(_urlsMan[4]),
              exibirFoto(_urlsMan[5]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urlsMan[6]),
            ],
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              exibirFoto(_urls[0]),
              exibirFoto(_urls[1]),
              exibirFoto(_urls[2]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urls[3]),
              exibirFoto(_urls[4]),
              exibirFoto(_urls[5]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urls[6]),
              exibirFoto(_urls[7]),
              exibirFoto(_urls[8]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urls[9]),
              exibirFoto(_urls[10]),
              exibirFoto(_urls[11]),
            ],
          ),
        ],
      );
    }
  }

  Column buildCheck() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
            setState(() {
              neu = value;
              mas = false;
              fem = false;
              _currText = generos[2];

              showDialog(
                  context: context,
                  child: AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Digite seu Gênero'),
                          onChanged: (value) {
                            setState(() {
                              _currText = value;
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _currText = value;
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ));
              //Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }

  String validaSenha(value) {
    if (value.isEmpty) {
      return 'Campo Obrigatório';
    } else {
      if (value.toString().length < 8) {
        return 'A senha não pode ter menos de 8 caracteres';
      }

      if (value != _controladorConfirmarSenha.text) {
        return 'As duas senhas não correspondem';
      }
    }
    return null;
  }

  Widget buildLogo() {
    return Container(
 
      width: 100,
      height:100,
      child: Image.asset("assets/icon/icon.png",
     

      )
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
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  buildLogo(),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: TextFormField(
                      controller: _controladorEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (EmailValidator.validate(value)) {
                          return null;
                        } else {
                          return 'Email Inválido';
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
                      validator: validaSenha,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                    child: TextFormField(
                      controller: _controladorCidade,
                      decoration: InputDecoration(
                          labelText: 'Cidade', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo obrigatório';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                    child: TextFormField(
                      onTap: () async {
                        DateTime date = await showDatePicker(
                            initialEntryMode: DatePickerEntryMode.input,
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());
                        initializeDateFormatting();
                        setState(() {
                          _controladorNascimento.text =
                              DateFormat('dd/MM/yyyy').format(date);
                        });
                      },
                      controller: _controladorNascimento,
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: 'Data de Nascimento',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo obrigatório';
                        } else {
                          return null;
                        }
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
                                        content: buildCheck(),
                                      );
                                    });
                              },
                            ),
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
                                        future: getUrl(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                            );
                                          } else {
                                            return AlertDialog(
                                              elevation: 5,
                                              content: escolherFoto(),
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

                              if (_currText == "Selecionar") {
                                setState(() {
                                  _currText = "Outro";
                                });
                              }

                              final FirebaseMessaging _firebaseMessaging =
                                  FirebaseMessaging();
                              var token = await _firebaseMessaging.getToken();

                              int aux = await repository.cadastro(
                                  token,
                                  _controladorEmail.text,
                                  _controladorSenha.text,
                                  _currText,
                                  _avatar,
                                  _controladorCidade.text,
                                  _controladorNascimento.text);
                              if (aux == 0) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Cadastro realizado!'),
                                  backgroundColor: Colors.blue,
                                ));

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              } else {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
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
