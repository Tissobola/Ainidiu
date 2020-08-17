import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

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
              return 'Você precisa escrever alguma coisa para que possamos te entender :)';
            }else{
              
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

    return Scaffold(
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
                    //print('usuario = $usuario');
                    if (_formKey.currentState.validate()) {
                      String mensagem = msg.text;
                      bool ehOfensivo = await filtrarTexto(mensagem);

                      
                        User user =
                          await repository.carregarDadosDoUsuario(usuario);

                      repository.escreverPostagens(DateTime.now(),
                          user.imageURL, 0, user.id, user.apelido, msg.text);

                      Navigator.pop(context);
                      

                      
                    } else {}
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

  Future<String> carregarArquivo() async {
    return await rootBundle.loadString('assets/blacklist.txt');
  }

  Future<List> lerArquivo() async {
    String data = await carregarArquivo();
    List<String> palavras = data.split(" ");
    int i = palavras.length;
    return palavras;
  }

  Future<int> tamanhoDaListaDePlavras() async {
    String data = await carregarArquivo();
    List<String> palavras = data.split(" ");
    int i = palavras.length;
    return Future.value(i);
  }

  Future<bool> filtrarTexto(String msg) async {
    List<String> listaDePalavras = await lerArquivo();
    msg = msg.toLowerCase();
    bool ehOfensivo = false;
    for (int i = 0; i < await tamanhoDaListaDePlavras() - 1; i++) {
      bool aux = msg.contains(listaDePalavras[i]);
      if (aux == true) {
        ehOfensivo = true;
      }
    }
    return ehOfensivo;
  }
}
