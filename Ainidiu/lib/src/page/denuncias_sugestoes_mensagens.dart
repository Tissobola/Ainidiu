import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/filtrar.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class OpinionPage extends StatefulWidget {
  User usuario;
  OpinionPage({Key key, this.usuario}) : super(key: key);

  @override
  _OpinionPageState createState() => _OpinionPageState(usuario: usuario);
}

class _OpinionPageState extends State<OpinionPage> {
  User usuario;
  bool temConteudo = true;
  bool canSend = true;

  _OpinionPageState({this.usuario});

  TextEditingController msg = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FbRepository repository = FbRepository();

  Widget _buildTextField() {
    final maxLines = 10;

    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(12),
        height: maxLines * 24.0,
        child: TextFormField(
          maxLength: 500,
          validator: (texto) {
            if (msg.text.isEmpty) {
              return 'Texto inválido!';
            }
            return null;
          },
          maxLines: maxLines,
          controller: msg,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: mensagem,
            hintStyle: TextStyle(color: Colors.grey[300]),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }

  Widget button() {
    return RawMaterialButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          bool ehOfensivo = await Filtrar().filtrarTexto(msg.text);

          if (ehOfensivo) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Sua mensagem contém termos ofensivos!'),
              backgroundColor: Colors.red,
            ));
          } else {
            if (canSend) {
              repository.sugestoes(msg.text, usuario);

              canSend = false;
              Navigator.pop(context);
            }
          }
        }
      },
      elevation: 2.0,
      fillColor: Colors.blue,
      child: Icon(
        Icons.create,
        size: 35.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }

  String mensagem =
      "Use este espaço para escrever algo que você deseje nos comunicar.\nAqui você denunciar algo que aconteceu dentro do aplicativo. Seja um bug (erro) ou algo que aconteceu com outro usuário.\nAlém disso, você pode mandar um mensagem para nossa equipe.";

  @override
  Widget build(BuildContext context) {
    var alturaTela = MediaQuery.of(context).size.height;
    var larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Contato')),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTextField(),
            button(),
          ]),
    );
  }
}
