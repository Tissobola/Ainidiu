import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  bool mas = false;
  bool fem = false;
  bool neu = false;
  String _currText = 'Selecionar';
  List<String> generos = ["Masculino", "Feminino", "Neutro", "Selecionar"];

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

  Column buildCheck() {
    return Column(
      children: <Widget>[
        CheckboxListTile(
          title: Text(generos[0]),
          value: mas,
          onChanged: (bool value) {
            setState(() {
              mas = value;
              fem = false;
              neu = false;
              _currText = generos[0];
              Navigator.pop(context);
            });
          },
        ),
        CheckboxListTile(
          title: Text(generos[1]),
          value: fem,
          onChanged: (bool value) {
            setState(() {
              fem = value;
              mas = false;
              fem = false;
              _currText = generos[1];
              Navigator.pop(context);
            });
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
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }

  Text mensagem() {
    String msg;
    if (fem) {
      setState(() {
        msg = 'Olá ${_controladorEmail.text}, seja bem-vindA\nSua senha é ${_controladorSenha.text}';
      });
    } else if (mas) {
      setState(() {
        msg = 'Olá ${_controladorEmail.text}, seja bem-vindO\nSua senha é ${_controladorSenha.text}';
      });
    } else {
      setState(() {
        msg = 'Olá ${_controladorEmail.text}, seja bem-vindX\nSua senha é ${_controladorSenha.text}';
      });
    }

    return Text(msg);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
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
                SizedBox(
                  height: 100,
                ),
                mensagem(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: builButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
