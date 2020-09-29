import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/filtrar.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class Escrever extends StatefulWidget {
  String usuario;
  Escrever({Key key, this.usuario}) : super(key: key);

  @override
  _EscreverState createState() => _EscreverState(usuario: usuario);
}

class _EscreverState extends State<Escrever> {
  String usuario;
  bool temConteudo = true;
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
          validator: (texto) {
            if (msg.text.isEmpty) {
              return 'Escreva alguma coisa para que possamos te entender :)';
            } else {}
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
            child: Stack(children: <Widget>[
              _buildTextField(),
              Positioned(
                top: 240.0 + 24,
                left: larguraTela - 70 - 12,
                child: GestureDetector(
                  onTap: () async {
                    
                    if (_formKey.currentState.validate()) {
                      bool ehOfensivo = await Filtrar().filtrarTexto(msg.text);

                      if (ehOfensivo) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content:
                              Text('Sua mensagem contém termos ofensivos!'),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        User user =
                            await repository.carregarDadosDoUsuario(usuario);

                        repository.escreverPostagens(DateTime.now(),
                            user.imageURL, 0, user.id, user.apelido, msg.text);

                        Navigator.pop(context);
                        
                      }
                    }
                  },
                  child: ClipOval(
                    child: Container(
                      color: Colors.blue,
                      height: 70,
                      width: 70,
                      child: Icon(
                        Icons.create,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ])));
  }
}
