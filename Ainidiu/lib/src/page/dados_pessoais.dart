import 'dart:ffi';

import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class DadosPessoais extends StatefulWidget {
  User usuario;
  DadosPessoais({this.usuario});
  @override
  _DadosPessoaisState createState() => _DadosPessoaisState(usuario: usuario);
}

class _DadosPessoaisState extends State<DadosPessoais> {
  User usuario;
  _DadosPessoaisState({this.usuario});

  FbRepository repository = new FbRepository();

  List<Widget> dados = new List<Widget>();

  var contextScaffold;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _senhaAntigaController = new TextEditingController();
  TextEditingController _senhaNovaController = new TextEditingController();
  TextEditingController _senhaConfirmarController = new TextEditingController();

  String senha(String senha) {
    String password = '';

    for (int i = 0; i < senha.length; i++) {
      password += '*';
    }

    return password;
  }

  double senhaDialogHeight = 340.0;

  senhaDialog() {
    senhaDialogHeight = 340.0;

    return AlertDialog(
      title: Text('Redefinir Senha'),
      content: Container(
        height: 400,
        width: 300,
        //color: Colors.blue[100],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo Obrigátorio';
                  }
                  return null;
                },
                controller: _senhaAntigaController,
                decoration: InputDecoration(
                    labelText: 'Senha Antiga',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _senhaNovaController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo Obrigátorio';
                  } else if (value != _senhaConfirmarController.text) {
                    return 'As senhas não coincidem';
                  } else if (value.length < 8) {
                    return 'A senha deve ter mais que 8 caracteres';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Senha Nova',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _senhaConfirmarController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Campo Obrigátorio';
                  } else if (value != _senhaNovaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Confirme a Senha',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: RaisedButton(
                  child: Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var res = await repository.updateDados(usuario, 'senha',
                          senhaAntiga: _senhaAntigaController.text,
                          senhaNova: _senhaNovaController.text);

                      if (res == 0) {
                        _senhaAntigaController.clear();
                        _senhaConfirmarController.clear();
                        _senhaNovaController.clear();

                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              content: Container(
                                height: 400,
                                width: 300,
                                color: Colors.white,
                                child: Center(
                                    child: Text(
                                  'Senha alterada com sucesso',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 21),
                                )),
                              ),
                            ));
                      } else if (res == 1) {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                              content: Container(
                                height: 100,
                                width: 300,
                                color: Colors.white,
                                child: Text(
                                  'Senha antiga não corresponde',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                            ));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool senhaVisivel = false;
  Icon senhaVisivelIcon = Icon(Icons.visibility_off);
  String senhaText;

  @override
  void initState() {
    senhaText = senha(usuario.senha);

    dados = [
      ListTile(
        title: Text('Apelido'),
        subtitle: Text(usuario.apelido),
      ),
      ListTile(
        title: Text('Seu ID'),
        subtitle: Text(usuario.id.toString()),
      ),
      Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 27,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(usuario.imageURL),
                backgroundColor: Colors.white,
              ),
            ),
            FlatButton(
              onPressed: () async {
                await repository.updateDados(usuario, 'foto');
              },
              child: Text(
                'Editar',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            )
          ],
        ),
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Stack(
            children: [
              ListTile(
                title: Text('Gênero'),
                subtitle: Text(usuario.genero),
                focusColor: Colors.red,
                hoverColor: Colors.red,
              ),
              Positioned(
                right: 15,
                top: 10,
                child: FlatButton(
                  onPressed: () async {
                    await repository.updateDados(usuario, 'genero');
                  },
                  child: Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Stack(
            children: [
              ListTile(
                title: Text('Email'),
                subtitle: Text(usuario.email),
                focusColor: Colors.red,
                hoverColor: Colors.red,
              ),
              Positioned(
                right: 15,
                top: 10,
                child: FlatButton(
                  onPressed: () async {
                    await repository.updateDados(usuario, 'email');
                  },
                  child: Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Stack(
            children: [
              ListTile(
                title: Text('Senha'),
                subtitle: Text(senhaText),
                focusColor: Colors.red,
                hoverColor: Colors.red,
              ),
              Positioned(
                child: IconButton(
                    icon: senhaVisivelIcon,
                    onPressed: () {
                      print(senhaText);
                      this.setState(() {
                        print('a');
                          senhaVisivel = false;
                          senhaVisivelIcon = Icon(Icons.visibility_off);
                          senhaText = 'senha(usuario.senha)';
                      });
                      if (senhaVisivel) {
                        setState(() {
                          
                        });
                      } else {
                        setState(() {
                          print('b');
                          senhaVisivel = true;
                          senhaVisivelIcon = Icon(Icons.visibility);
                          senhaText = 'usuario.senha';
                        });
                      }
                    }),
                right: 120,
                top: 12,
              ),
              Positioned(
                right: 15,
                top: 10,
                child: FlatButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return senhaDialog();
                      },
                    );
                  },
                  child: Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contextScaffold = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Pessoais'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dados.length,
          itemBuilder: (context, index) {
            return dados[index];
          },
        ),
      ),
    );
  }
}
