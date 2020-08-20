import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:ainidiu/src/api/user.dart';

class Denunciar extends StatefulWidget {
  User usuario;
  int id;
  Denunciar({Key key, this.usuario, this.id}) : super(key: key);
  @override
  _DenunciarState createState() => _DenunciarState(usuario: usuario, id: id);
}

class _DenunciarState extends State<Denunciar> {
  User usuario;
  int id;
  _DenunciarState({this.usuario, this.id});
  TextEditingController msg = TextEditingController();
  FbRepository repository = FbRepository();

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
          hintText: "Insira o motivo da denuncia...",
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
        appBar: AppBar(
          title: Text('Denunciar'),
          backgroundColor: Colors.red,
        ),
        body: Container(
            height: alturaTela,
            child: Stack(children: <Widget>[
              _buildTextField(),
              Positioned(
                top: 240.0 + 24,
                left: larguraTela - 70 - 12,
                child: GestureDetector(
                  onTap: () async {
                    print('user = ${usuario.apelido}');
                    repository.denunciar(id, msg.text, usuario);
                    Navigator.pop(context);
                  },
                  child: ClipOval(
                    child: Container(
                      color: Colors.red,
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
