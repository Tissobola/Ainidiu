import 'dart:io';

import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


void printHello() {
  final DateTime now = DateTime.now();
  
  print("[$now] Hello, world!  function='$printHello'");
}

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

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  usuario: snapshot.data,
                );
              }
            }
          },
        ));
  }
}
