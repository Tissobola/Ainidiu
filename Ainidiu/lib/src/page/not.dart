import 'package:ainidiu/helpers/database_helper.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:ainidiu/src/testes/1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class HomeTest extends StatefulWidget {
  @override
  _HomeTestState createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  FbRepository repository = new FbRepository();

  @override
  void initState() {
    super.initState();
  
    Firebase.initializeApp().whenComplete(() {
     
      setState(() {});
    });
  }

  DatabaseHelper db = DatabaseHelper();

  List<Contato> contatos = List<Contato>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
