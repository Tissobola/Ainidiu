import 'package:flutter/material.dart';

class Sobre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre')),
      body: ListView(
        children: [
          ListTile(title: Text('Versão'),
          subtitle: Text('1.0.1'),
          trailing: Icon(Icons.code),)
        ],
      ),
    );
  }
}