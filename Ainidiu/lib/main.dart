import 'dart:async';
import 'dart:io';

import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FbRepository repository = new FbRepository();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flnNotificacao =
      FlutterLocalNotificationsPlugin();

  void _mostrarNotificacao(String texto) async {
    _simularNovaNotificacao(texto);
  }

  void _simularNovaNotificacao(String texto) {
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
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });

    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
        _mostrarNotificacao('message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
      onResume: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      localizationsDelegates: [
          GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale("pt", "BR"),
      ],
        debugShowCheckedModeBanner: false,
        title: 'Ainidiu',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //HomePage() para o app
        //IntroPage() para a introdução
        //LoginHome para login

        //home: HomePage()
        //home: IntroPage(),
        //home: LoginHome(),
        home: FutureBuilder(
          future: repository.loginAuto(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.data == null) {
                return LoginHome();
              } else {
                return HomePage(
                  0,
                  usuario: snapshot.data,
                );
              }
            }
          },
        ));
  }
}
