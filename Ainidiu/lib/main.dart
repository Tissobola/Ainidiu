
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/page/not.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: LoginHome(),
    );
  }
}
