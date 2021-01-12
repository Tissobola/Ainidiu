import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _textController = TextEditingController();

  String iOSDevice = 'Your iOS Token(Physical device)';
  String androidSimul =
      'eIJ_3cVjTZqiPIXa15EUeH:APA91bGevHf1o3iZu6JB8nE1Yzy7Wlte_J3AMQ4vrUJSr4vu7vF31jO-kbLAwSeEvrJBce2oAxC9eInu_ZUn-L1yGbq5bjko2e4E1RYu-4WoWvMVgNLA2mng2Khd-wkQ2YKl7g1QdpTF';

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _mostrarNotificacao();
      },
    );
  }

  void myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      //final dynamic notification = message['notification'];
    }

    _mostrarNotificacao();
  }

  FlutterLocalNotificationsPlugin _flnNotificacao =
      new FlutterLocalNotificationsPlugin();

  //Configurações das plataformas de notificação
  var configuracaoInitAndroid;
  var configuracaoInitIOs;
  var configuracaoInit;

  void _mostrarNotificacao() {
    _simularNovaNotificacao();
  }

  void _simularNovaNotificacao() {
    var notificacaoAndroid = AndroidNotificationDetails(
        'channel_Id', 'channel Name', 'channel Description',
        importance: Importance.Max, priority: Priority.High, ticker: 'Teste');

    var notificacaoIOs = IOSNotificationDetails();

    var notificacao = NotificationDetails(notificacaoAndroid, notificacaoIOs);

    _flnNotificacao.show(
        0, 'Nome do meu App', 'Ola, sou um teste de notificação', notificacao,
        payload: 'teste onload');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Get Token', style: TextStyle(fontSize: 20)),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 10));
                _firebaseMessaging.getToken().then((val) {
                  
                });
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('TEst'),
              onPressed: () async {
                FbRepository repository = new FbRepository();
                repository
                    .getConexao()
                    .collection('a')
                    .doc()
                    .set({'teset': 'rtest'});
              },
            ),
            SizedBox(
              width: 260,
              child: TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please type an message';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Message'),
                controller: _textController,
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Send a message to Android',
                  style: TextStyle(fontSize: 20)),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 3));
                sendAndRetrieveMessage(androidSimul);
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Send a message ', style: TextStyle(fontSize: 20)),
              onPressed: () {
                _mostrarNotificacao();
              },
            )
          ],
        ),
      ),
    );
  }

  final String serverToken =
      'AAAABtx9LIo:APA91bH6u2CwSsFvSFY0rnreRC6TrQTXMVIuBto8nyxgCdmxefrmhmaIrE-fsw6WtvC_Tk-XitERzgYhupdB9kdUn29PuxgBS-n_anwwjQW1_azNjfzU7AWl7nODEoNPrhAn7srHuAFr';

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _textController.text,
            'title': 'FlutterCloudMessage',
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
      ),
    );

    _textController.text = '';
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
        _mostrarNotificacao();
      },
      onLaunch: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
      onResume: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler
    );

    return completer.future;
  }
}
