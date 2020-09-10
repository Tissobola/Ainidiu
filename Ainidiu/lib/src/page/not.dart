import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Gerenciador das notificações
  FlutterLocalNotificationsPlugin _flnNotificacao =
      new FlutterLocalNotificationsPlugin();

  //Configurações das plataformas de notificação
  var configuracaoInitAndroid;
  var configuracaoInitIOs;
  var configuracaoInit;

  void _mostrarNotificacao() async {
    await _simularNovaNotificacao();
  }

  Future<void> _simularNovaNotificacao() {
    var notificacaoAndroid = AndroidNotificationDetails(
        'channel_Id', 'channel Name', 'channel Description',
        importance: Importance.Max, priority: Priority.High, ticker: 'Teste');
    
    var notificacaoIOs = IOSNotificationDetails();

    var notificacao = NotificationDetails(notificacaoAndroid, notificacaoIOs);

    _flnNotificacao.show(0, 'Nome do meu App', 'Ola, sou um teste de notificação', notificacao,
    payload: 'teste onload' );
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
          context, MaterialPageRoute(builder: (context) => NotificacaoPage()));
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
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificacaoPage()));
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarNotificacao,
        child: Icon(Icons.notifications),
      ),
    );
  }
}

class NotificacaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes notificação'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('voltar...'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}