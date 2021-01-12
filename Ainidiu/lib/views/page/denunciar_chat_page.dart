import 'package:ainidiu/views/page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:ainidiu/data/models/user.dart';

class DenunciarChat extends StatefulWidget {
  final User usuario;
  final int id;
  final int denunciadoId;
  DenunciarChat({Key key, this.usuario, this.id, this.denunciadoId})
      : super(key: key);
  @override
  _DenunciarChatState createState() =>
      _DenunciarChatState(usuario: usuario, id: id, denunciadoId: denunciadoId);
}

class _DenunciarChatState extends State<DenunciarChat> {
  User usuario;
  int id;
  int denunciadoId;

  _DenunciarChatState({this.usuario, this.id, this.denunciadoId});
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
        maxLength: 500,
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
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Sua denúncia foi enviada para análise!'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                                1,
                                                usuario: usuario,
                                              )),
                                      (route) => false);
                                },
                                child: Text(
                                  "Confirmar",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ));

                    FocusScope.of(context).requestFocus(new FocusNode());

                    repository.denunciarChat(id, denunciadoId, msg.text, usuario);

                    await Future.delayed(Duration(milliseconds: 1000));
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
