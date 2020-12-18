import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/filtrar.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class OpinionPage extends StatefulWidget {
  final User usuario;
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
            hintText: 'Digite aqui...',
            hintStyle: TextStyle(color: Colors.grey[300]),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
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

  _buildCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Center(
          child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width - 30,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child: Text(
                  mensagem,
                  textAlign: TextAlign.justify,
                )),
              )),
        ),
      ),
    );
  }

  String mensagem =
      "Use este espaço para escrever algo que você deseje nos comunicar. Aqui você denunciar algo que aconteceu dentro do aplicativo. Seja um bug (erro) ou algo que aconteceu com outro usuário. Além disso, você pode mandar um mensagem para nossa equipe.";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Contato')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildTextField(),
              _buildButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
              _buildCard()
            ]),
      ),
    );
  }
}
