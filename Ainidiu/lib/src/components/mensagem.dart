import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mensagem extends StatelessWidget {
  final String texto;
  final int env;
  final int myId;

  Mensagem(this.texto, this.env, this.myId);

  @override
  Widget build(BuildContext context) {
    BoxDecoration recebida = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(
            width: 0.5, color: Colors.grey[200], style: BorderStyle.solid));

    BoxDecoration enviada = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.all(Radius.circular(40)),
    );

    var cWidth;

    if (texto.length > 40) {
      cWidth = MediaQuery.of(context).size.width * 0.8;
    }

    return Row(
      mainAxisAlignment:
          (!(env == myId)) ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 15, right: 15),
              //Definir max 40 caracteres por msg
              child: Container(
                  width: cWidth,
                  child:
                      Text(texto, style: TextStyle(fontSize: 16))),
            ),
            decoration: (env == myId) ? enviada : recebida
          ),
        )
      ],
    );
  }
}
