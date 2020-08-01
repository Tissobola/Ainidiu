import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';

class Denunciar extends StatefulWidget {
  int id;
  Denunciar(this.id);
  @override
  _DenunciarState createState() => _DenunciarState(id);
}

class _DenunciarState extends State<Denunciar> {
  int id;
  _DenunciarState(this.id);
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
                    //print('Id = ${id}');
                    await repository.denunciar(id, msg.text);
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