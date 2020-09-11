import 'package:ainidiu/src/components/mensagem.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  TextEditingController msg = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool podeEnviar = true;
  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 5000);

  FbRepository repository = new FbRepository();

  int myId;
  int id;
  String apelido;
  int primeiro;
  int segundo;

  final FlutterLocalNotificationsPlugin _flnNotificacao =
      FlutterLocalNotificationsPlugin();
  var configuracaoInitAndroid;
  var configuracaoInitIOs;
  var configuracaoInit;

  String texto;

  void _mostrarNotificacao() async {
    await _simularNovaNotificacao();
  }

  Future<void> _simularNovaNotificacao() {
    var notificacaoAndroid = AndroidNotificationDetails(
        'channel_id', 'channel Name', 'channel Description',
        importance: Importance.Max, priority: Priority.High, ticker: 'Teste');

    var notificacaoIOs = IOSNotificationDetails();

    var notificacao = NotificationDetails(notificacaoAndroid, notificacaoIOs);
    _flnNotificacao.show(0, 'Ainidiu', texto, notificacao,
        payload: 'teste onload');
  }

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
      print('Notificação $playload');
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

  int old = 0;

  notifica(int now, lastData) {
    if (old == 0) {
      old = now;
    } else if (old < now) {
      if (lastData.data()['env'] != myId) {
        texto = lastData.data()['texto'];

        _mostrarNotificacao();
      }

      old = now;
    }
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
        //floatingActionButton:
        //FloatingActionButton(onPressed: _mostrarNotificacao),
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

                    //print('item = ${item[0].data()['texto']}');
                    print(item.length);
                    if (old < item.length) {
                      notifica(item.length, item[(item.length - 1)]);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      //_mostrarNotificacao();
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: item.length,
                        itemBuilder: (context, index) {
                          //print('item = ${item[index]['texto']}');

                          //print('$index = ${item[index]['env']}');
                          return Mensagem('${item[index].data()['texto']}',
                              item[index].data()['env'], myId);
                        },
                      );
                    }
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  digitar()
                ],
              )
            ],
          ),
        )
        //persistentFooterButtons: <Widget>[IconButton(icon: Icon(Icons.send), onPressed:() {print('OK');})],
        );
  }

  digitar() {
    FbRepository repository = new FbRepository();

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
                Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
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
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
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
                            _formKey.currentState.validate();
                            if (podeEnviar) {
                              await repository.mandarMensagem(
                                  msg.text, id, myId);
                              msg.text = '';
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
}
