import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({Key key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.end,children: <Widget>[Padding(padding: EdgeInsets.only(top:5.0, right: 5.0),child: Icon(Icons.settings, size: 40.0))]),
              CircleAvatar(minRadius: 40.0, child: Icon(Icons.person, size: 50.0)),
              Padding(padding: EdgeInsets.only(top:10.0),child: Container(width: 200,decoration: BoxDecoration(border: Border.all(color: Colors.black)),child: Center(child:Text('Apelido', style: TextStyle(fontWeight: FontWeight.bold)) ))),
              Padding(padding: EdgeInsets.only(top:10.0),child: Container(width: 200,decoration: BoxDecoration(border: Border.all(color: Colors.black)),child: Center(child:Text(a, style: TextStyle(fontWeight: FontWeight.bold)) )))
              
             
            ]
          )
        );
  }
}
