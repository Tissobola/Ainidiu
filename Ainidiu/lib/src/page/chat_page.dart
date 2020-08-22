

import 'package:ainidiu/src/components/mensagem_enviada_card.dart';
import 'package:ainidiu/src/components/mensagem_recebida_card.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/page/messages_page.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController msg = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Conversas conversa = ModalRoute.of(context).settings.arguments;
    FbRepository repository = new FbRepository();
    return Scaffold(
        appBar: AppBar(
          title: Text(conversa.apelido),
        ),
        body: Stack(
          children: [
            StreamBuilder(
              stream: repository.getConexao().collection('chat').orderBy('id').snapshots(),
              builder: (context, snapshot) {
                var item = snapshot.data.documents;

                return ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    print('$index = ${item[index]['env']}');
                    return (item[index]['env'] == 0)
                        ? MensagemRecebidaCard(conversa.apelido, item[index]['texto'])
                        : MensagemEnviadaCard(
                            conversa.apelido, item[index]['texto']);
                  },
                );
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [espacoDeDigitacao()],
            )
          ],
        )
        //persistentFooterButtons: <Widget>[IconButton(icon: Icon(Icons.send), onPressed:() {print('OK');})],
        );
  }

  espacoDeDigitacao() {
    FbRepository repository = new FbRepository();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
        child: Row(children: <Widget>[
          Container(
            width: 300,
            child: TextField(
              controller: msg,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(),
                  color: Colors.white,
                ),
                height: 59,
                width: 59,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      size: 50,
                    ),
                    onPressed: () async {
                      print(msg.text);
                      await repository.mandarMensagem(msg.text);
                    },
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
