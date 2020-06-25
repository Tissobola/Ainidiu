import 'package:flutter/material.dart';

import 'package:Ainidiu/lib/src/page/home_page.dart'

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ainidiu',
      theme: ThemeData(
        prymarySwatch: Colors.blue,
      ),
      home: HomePage(), 
    );
  }
}