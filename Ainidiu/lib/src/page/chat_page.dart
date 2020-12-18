import 'dart:async';
import 'dart:convert';
import 'package:ainidiu/src/api/user.dart';
import 'package:http/http.dart' as http;
import 'package:ainidiu/src/components/mensagem.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Chat extends StatefulWidget {
  final User user;
  final User userEu;
  final int id;
  final int myId;
  Chat({this.user, this.userEu, this.id, this.myId});
  @override
  _ChatState createState() =>
      _ChatState(user: user, userEu: userEu, id: id, myId: myId);
}

class _ChatState extends State<Chat> {
  _ChatState({this.user, this.userEu, this.id, this.myId});

  TextEditingController msg = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 5000);

  bool podeEnviar = true;

  FbRepository repository = new FbRepository();

  var serverToken =
      'AAAABtx9LIo:APA91bH6u2CwSsFvSFY0rnreRC6TrQTXMVIuBto8nyxgCdmxefrmhmaIrE-fsw6WtvC_Tk-XitERzgYhupdB9kdUn29PuxgBS-n_anwwjQW1_azNjfzU7AWl7nODEoNPrhAn7srHuAFr';

  int myId;
  int id;
  User user;
  User userEu;
  int primeiro;
  int segundo;

  final FlutterLocalNotificationsPlugin _flnNotificacao =
      FlutterLocalNotificationsPlugin();
  var configuracaoInitAndroid;
  var configuracaoInitIOs;
  var configuracaoInit;

  String texto;

  @override
  void initState() {
    super.initState();

    configuracaoInitAndroid = new AndroidInitializationSettings(
        'app_icon' //Nome da imagem que se encontra no diretorio
        //android\app\src\main\res\drawable\[app_icon].png
        );

    configuracaoInitIOs = new IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    configuracaoInit = new InitializationSettings(
        configuracaoInitAndroid, configuracaoInitIOs);

    _flnNotificacao.initialize(configuracaoInit,
        onSelectNotification: _onSelectNotification);
  }

  Future _onSelectNotification(String playload) async {
    if (playload != null) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginHome()));
    }
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String playload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginHome()));
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    primeiro = id;
    segundo = myId;
    if (id > myId) {
      primeiro = myId;
      segundo = id;
    }

    return Scaffold(
        appBar: AppBar(title: Text(user.apelido)),
        body: Container(
          child: Column(
            children: [
              Expanded(child: chatMessages()),
              Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: digitar2())
            ],
          ),
        ));
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: repository
          .getConexao()
          .collection('/chat/conversas/${primeiro}_$segundo')
          .orderBy('id')
          .snapshots(),
      builder: (context, snapshot) {
        var item;
        try {
          item = snapshot.data.documents;
        } catch (ex) {}

        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  return Mensagem('${item[index].data()['texto']}',
                      item[index].data()['env'], myId);
                })
            : Container(
                child: Center(child: CircularProgressIndicator()),
              );
      },
    );
  }

  mandarNotification(String token, texto) async {
    await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': texto,
              'title': userEu.apelido,
            },
            'priority': 'high',
            'to': token,
            'data': <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done",
              "message": "My Message",
              "title": "Meu Title"
            },
          },
        ));
  }

  int linhas = 1;
  digitar2() {
    FbRepository repository = new FbRepository();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 320,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  validator: (text) {
                    if (text.isEmpty) {
                      setState(() {
                        podeEnviar = false;
                      });
                      return null;
                    }

                    setState(() {
                      podeEnviar = true;
                    });
                    return null;
                  },
                  controller: msg,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconButton(
                        iconSize: 25,
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          _formKey.currentState.validate();
                          if (podeEnviar) {
                            //Vai armazenar a mensagem
                            String aux = msg.text;
                            msg.text = '';

                            //Removendo "\n"
                            do {
                              if (aux.characters.last == "\n") {
                                aux = aux.substring(0, aux.length - 1);
                              }
                            } while (aux.characters.last == "\n");

                            await repository.mandarMensagem(
                                aux, id, myId, user, userEu);

                            String textoDaNotificacao = aux;

                            await mandarNotification(
                                user.token, textoDaNotificacao);
                          }
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
      ),
    );
  }
}
