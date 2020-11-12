import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/filtrar.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class Escrever extends StatefulWidget {
  User usuario;
  Escrever({Key key, this.usuario}) : super(key: key);

  @override
  _EscreverState createState() => _EscreverState(usuario: usuario);
}

class _EscreverState extends State<Escrever> {
  User usuario;
  bool temConteudo = true;
  bool canSend = true;
  _EscreverState({this.usuario});
  TextEditingController msg = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
            hintText: "Diga o que está sentindo...",
            hintStyle: TextStyle(color: Colors.grey[300]),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var alturaTela = MediaQuery.of(context).size.height;
    var larguraTela = MediaQuery.of(context).size.width;

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Escrever')),
        body: Container(
            height: alturaTela,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _buildTextField(),
                  RawMaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        bool ehOfensivo =
                            await Filtrar().filtrarTexto(msg.text);

                        if (ehOfensivo) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text('Sua mensagem contém termos ofensivos!'),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          if (canSend) {
                            repository.escreverPostagens(
                                DateTime.now(),
                                usuario.imageURL,
                                0,
                                usuario.id,
                                usuario.apelido,
                                msg.text);

                            Navigator.pop(context);
                            canSend = false;
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
                  ),
                ])));
  }
}
