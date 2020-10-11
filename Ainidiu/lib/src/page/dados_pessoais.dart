import 'dart:ffi';

import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DadosPessoais extends StatefulWidget {
  User usuario;
  DadosPessoais({this.usuario});
  @override
  _DadosPessoaisState createState() => _DadosPessoaisState(usuario: usuario);
}

class _DadosPessoaisState extends State<DadosPessoais> {
  String senhaText = 'oi';
  bool senhaVisivel = true;
  Icon senhaVisivelIcon = Icon(Icons.visibility_off);
  TextEditingController exibirSenhaController = new TextEditingController();

  User usuario;
  _DadosPessoaisState({this.usuario});

  FbRepository repository = new FbRepository();

  List<Widget> dados = new List<Widget>();

  var contextScaffold;

  final _formKeySenha = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();

  TextEditingController _senhaAntigaController = new TextEditingController();
  TextEditingController _senhaNovaController = new TextEditingController();
  TextEditingController _senhaConfirmarController = new TextEditingController();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _emailConfirmarController = new TextEditingController();

  String senha(String senha) {
    String password = '';

    for (int i = 0; i < senha.length; i++) {
      password += '*';
    }

    return senha;
  }

  double senhaDialogHeight = 340.0;

  emailDialog() {
    return AlertDialog(
      title: Text('Redefinir Email'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKeyEmail,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo obrigatório';
                    } else if (EmailValidator.validate(value)) {
                      if (value == usuario.email) {
                        return 'Email igual ao atual';
                      }
                    } else {
                      return 'Email Inválido';
                    }
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Novo Email',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailConfirmarController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo Obrigátorio';
                    } else if (value != _emailController.text) {
                      return 'Os emails não coincidem';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Confirmar Email',
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
                        if (_formKeyEmail.currentState.validate()) {
                          var res = await repository.updateDados(usuario, 'email',
                              email: _emailConfirmarController.text);

                          if (res == 0) {
                            _emailConfirmarController.clear();
                            _emailController.clear();

                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  content: Container(
                                    height: 400,
                                    width: 300,
                                    color: Colors.white,
                                    child: Center(
                                        child: Text(
                                      'Email alterado com sucesso',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 21),
                                    )),
                                  ),
                                ));

                            
                            await Future.delayed(Duration(seconds: 3));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginHome()),
                                (route) => false);
                          }else{
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
                                    'Email não disponível',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 21),
                                  ),
                                ),
                              ));
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double alturaSenhaDialog = 310;

  senhaDialog() {
    senhaDialogHeight = 340.0;

    return AlertDialog(
      
      
      title: Text('Redefinir Senha'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        
        children: [
          Form(
            key: _formKeySenha,
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
                      if (_formKeySenha.currentState.validate()) {
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
        ],
      ),
    );
  }

  @override
  void initState() {
    exibirSenhaController.text = usuario.senha;

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
        child: ListView(
          children: [
            //Foto de Perfil

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text('Foto de Perfil'),
                leading: CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(usuario.imageURL),
                    backgroundColor: Colors.white,
                  ),
                ),
                trailing: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Editar',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await repository.updateDados(usuario, 'foto');
                    }),
              ),
            ),

            //Apelido

            ListTile(
              title: Text('Apelido'),
              subtitle: Text(usuario.apelido),
            ),

            //ID

            ListTile(
              title: Text('Seu ID'),
              subtitle: Text(usuario.id.toString()),
            ),

            //Gênero

            ListTile(
              title: Text('Gênero'),
              subtitle: Text(usuario.genero),
              focusColor: Colors.red,
              hoverColor: Colors.red,
              trailing: FlatButton(
                onPressed: () async {
                  await repository.updateDados(usuario, 'genero');
                },
                child: Text(
                  'Editar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            ),

            //Email

            ListTile(
              title: Text('Email'),
              subtitle: Text(usuario.email),
              focusColor: Colors.red,
              hoverColor: Colors.red,
              trailing: FlatButton(
                onPressed: () async {
                  showDialog(context: context, child: emailDialog());
                },
                child: Text(
                  'Editar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            ),

            //Senha

            Stack(
              children: [
                ListTile(
                  title: Text('Senha'),
                  subtitle: TextField(
                    controller: exibirSenhaController,
                    readOnly: true,
                    obscureText: senhaVisivel,
                    decoration: null,
                  ),
                  focusColor: Colors.red,
                  hoverColor: Colors.red,
                  trailing: FlatButton(
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
                ),
                Positioned(
                  child: IconButton(
                      icon: senhaVisivelIcon,
                      onPressed: () {
                        setState(() {
                          if (senhaVisivel) {
                            senhaVisivel = false;
                            senhaVisivelIcon = Icon(Icons.visibility);
                          } else {
                            senhaVisivel = true;
                            senhaVisivelIcon = Icon(Icons.visibility_off);
                          }
                        });
                      }),
                  right: 120,
                  top: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
