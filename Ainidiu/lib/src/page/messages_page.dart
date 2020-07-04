import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({Key key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        ///Usando o componente ListViewPostCard, passando como parâmetro a fonte de dados
        body: Container(color: Colors.white,)    
    );
  }
}
