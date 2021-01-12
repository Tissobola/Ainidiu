import 'package:ainidiu/data/models/item.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class Comentar extends StatefulWidget {
  final String usuario;
  final ItemData current;
  Comentar({Key key, this.usuario, this.current}) : super(key: key);

  @override
  _ComentarState createState() => _ComentarState(usuario: usuario, current: current);
}

class _ComentarState extends State<Comentar> {
  String usuario;
  ItemData current;
  TextEditingController msg = TextEditingController();
  FbRepository repository = FbRepository();

  _ComentarState({this.usuario, this.current});

  ItemData getCurrent() {
    return this.widget.current;
  }

  Widget _buildTextField() {
    final maxLines = 10;

    return Container(
      margin: EdgeInsets.all(12),
      height: maxLines * 24.0,
      child: TextField(
        controller: msg,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Faça seu comentário...",
          hintStyle: TextStyle(color: Colors.grey[300]),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var alturaTela = MediaQuery.of(context).size.height;
    var larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: Text('Comentar')),
        body: Container(
            height: alturaTela,
            child: Stack(children: <Widget>[
              _buildTextField(),
              Positioned(
                top: 240.0 + 24,
                left: larguraTela - 70 - 12,
                child: GestureDetector(
                  onTap: () async {
                    
                    User user =
                        await repository.carregarDadosDoUsuario(usuario);

                    repository.escreverComentario(
                      current.id,
                      msg.text,
                      user
                    );

                    Navigator.pop(context);
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
