import 'package:ainidiu/src/page/login_login.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/page/login_home.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  FbRepository repository = FbRepository();

  final _formKey = GlobalKey<FormState>();

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

  Column escolherFoto() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F001-man-13.png?alt=media&token=ccfbda64-d61a-4625-8e15-d809384456e5'),
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F002-woman-14.png?alt=media&token=48e9f9e5-072d-40c1-b883-0798b08900f5'),
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F005-woman-11.png?alt=media&token=9d4180ad-2302-4c8c-8eba-fcff6bd479ef'),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F001-man-13.png?alt=media&token=ccfbda64-d61a-4625-8e15-d809384456e5'),
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F002-woman-14.png?alt=media&token=48e9f9e5-072d-40c1-b883-0798b08900f5'),
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F005-woman-11.png?alt=media&token=9d4180ad-2302-4c8c-8eba-fcff6bd479ef'),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F001-man-13.png?alt=media&token=ccfbda64-d61a-4625-8e15-d809384456e5'),
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F002-woman-14.png?alt=media&token=48e9f9e5-072d-40c1-b883-0798b08900f5'),
            exibirFoto(
                'https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2F005-woman-11.png?alt=media&token=9d4180ad-2302-4c8c-8eba-fcff6bd479ef'),
          ],
        )
      ],
    );
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
                                      return AlertDialog(
                                        content: Container(
                                          height: 230,
                                          child: escolherFoto(),
                                        ),
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
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.blue)),
                    color: Colors.blue,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        int aux = await repository.cadastro(
                            _controladorEmail.text,
                            _controladorSenha.text,
                            _currText,
                            _avatar
                            );
                        if (aux == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginHome()));
                        } else {
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
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
