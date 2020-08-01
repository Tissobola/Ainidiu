import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class Comentar extends StatefulWidget {
  String usuario;
  ItemData current;
  Comentar({Key key, this.usuario, this.current}) : super(key: key);

  @override
  _ComentarState createState() => _ComentarState(usuario: usuario);
}

class _ComentarState extends State<Comentar> {
  String usuario;
  _ComentarState({this.usuario});
  TextEditingController msg = TextEditingController();
  FbRepository repository = FbRepository();

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
                    //print('usuario = $usuario');
                    User user =
                        await repository.carregarDadosDoUsuario(usuario);

                    repository.escreverComentario(DateTime.now(), user.imageURL, this.getCurrent().id, user.id, user.apelido, msg.text, );

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