import 'package:flutter/material.dart';

class MensagemRecebidaCard extends StatefulWidget {
  String nomeDoUsuario;
  String msg;
  MensagemRecebidaCard(this.nomeDoUsuario, this.msg);
  @override
  _MensagemRecebidaCardState createState() =>
      _MensagemRecebidaCardState(nomeDoUsuario: nomeDoUsuario, mensagem: msg);
}

class _MensagemRecebidaCardState extends State<MensagemRecebidaCard> {
  _MensagemRecebidaCardState({this.nomeDoUsuario, this.mensagem});

  final textoController = TextEditingController();

  String nomeDoUsuario;

  var alturaDoCard = 130.0;

  final espacamento = 50;

  var larguraDoCard = 325.0;

  String horario = '12:30';

  String mensagem;

  @override
  Widget build(BuildContext context) {
    textoController.text = mensagem;

    return Card(
      child: Container(
        height: alturaDoCard,
        width: larguraDoCard,
        child: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                horario,
                textAlign: TextAlign.right,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    ),
                    Text(
                      nomeDoUsuario,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(5)),
                TextField(
                  readOnly: true,
                  textAlign: TextAlign.justify,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: textoController,
                  decoration: InputDecoration(border: InputBorder.none),
                )
              ],
            )),
      ),
    );
  }
}
