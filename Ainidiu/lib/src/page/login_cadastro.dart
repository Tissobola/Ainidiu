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

  bool mas = false;
  bool fem = false;
  bool neu = false;

  String _currText = 'Selecionar';
  List<String> generos = ["Masculino", "Feminino", "Neutro", "Selecionar"];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Builder(
              builder: (context) => Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 10, right: 10),
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
                  padding: const EdgeInsets.only(top: 16.0, left: 10, right: 10),
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
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 10, right: 10),
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
                                          height: 325, child: buildCheck()),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      int aux = await repository.cadastro(_controladorEmail.text,
                          _controladorSenha.text, _currText);
                      if (aux == 0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginHome()));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Email já em uso!'), backgroundColor: Colors.red,));
                        
                      }
                    }
                  },
                  child: Text('ok'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
