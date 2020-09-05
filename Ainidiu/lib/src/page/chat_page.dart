import 'package:ainidiu/src/components/mensagem.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  String apelido;
  int id;
  int myId;
  Chat({this.apelido, this.id, this.myId});
  @override
  _ChatState createState() => _ChatState(apelido: apelido, id: id, myId: myId);
}

class _ChatState extends State<Chat> {
  _ChatState({this.apelido, this.id, this.myId});
  final _formKey = new GlobalKey<FormState>();

  int myId;
  int id;
  String apelido;
  int primeiro;
  int segundo;

  @override
  Widget build(BuildContext context) {
    primeiro = id;
    segundo = myId;
    if (id > myId) {
      primeiro = myId;
      segundo = id;
    }

    FbRepository repository = new FbRepository();
    return Scaffold(
        appBar: AppBar(
          title: Text(apelido),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: repository
                      .getConexao()
                      .collection('/chat/conversas/${primeiro}_$segundo')
                      .orderBy('id')
                      .snapshots(),
                  builder: (context, snapshot) {
                    var item = snapshot.data.documents;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }else{
                      return ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        //print('$index = ${item[index]['env']}');
                        return Mensagem(
                            '${item[index]['texto']}', item[index]['env'], myId);
                      },
                    );
                    }
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [digitar()],
              )
            ],
          ),
        )
        //persistentFooterButtons: <Widget>[IconButton(icon: Icon(Icons.send), onPressed:() {print('OK');})],
        );
  }

  digitar() {
    FbRepository repository = new FbRepository();

    TextEditingController msg = new TextEditingController();

    return Padding(
      padding: EdgeInsets.only(bottom: 5, top: 5),
      child: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: TextFormField(
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Escreva algo';
                      } else if (text.length > 40) {
                        return 'O máximo de caracteres é 40';
                      }
                      return null;
                    },
                    controller: msg,
                    decoration: InputDecoration(
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 25,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await repository.mandarMensagem(msg.text, id, myId);

                            msg.text = '';
                          }),
                    ),
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width - 20,
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40)),
              border: Border.all(
                  width: 1, color: Colors.grey, style: BorderStyle.solid)),
        ),
      ),
    );
  }

/*
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
  */
}
