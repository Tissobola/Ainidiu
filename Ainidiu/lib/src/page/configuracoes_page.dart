import 'package:ainidiu/src/page/sobre_page.dart';
import 'package:flutter/material.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações'),
      ),
      body: opcoesListView()
    );
  }

  opcoesListView() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Sobre'),
          onTap:() {Navigator.push(
              context, MaterialPageRoute(builder: (context) => Sobre()));}
        )
      ],
    );
  }
}