import 'package:flutter/material.dart';

class Escrever extends StatefulWidget {
  Escrever({Key key}) : super(key: key);

  @override
  _EscreverState createState() => _EscreverState();
}

class _EscreverState extends State<Escrever> {
  Widget _buildTextField() {
    final maxLines = 10;

    return Container(
      margin: EdgeInsets.all(12),
      height: maxLines * 24.0,
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: "Enter a message",
          fillColor: Colors.grey[300],
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Escrever')),
        body: Container(
            child: Stack(children: <Widget>[
          _buildTextField(),
          Positioned(
              top: 175,
              left: 193,
              child: RaisedButton(
                child: Icon(Icons.forward),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Escrever()));
                },
              ))
        ])));
  }
}
