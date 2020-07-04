import 'package:flutter/material.dart';

class Comentar extends StatefulWidget {
  Comentar({Key key}) : super(key: key);

  @override
  _ComentarState createState() => _ComentarState();
}

class _ComentarState extends State<Comentar> {
  Widget _buildTextField() {
    final maxLines = 10;

    return Container(
      margin: EdgeInsets.all(12),
      height: maxLines * 24.0,
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Diga o que está sentindo...",
          hintStyle: TextStyle(color: Colors.grey[300]),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Comentar')),
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
                onPressed: () {},
              ))
        ])));
  }
}
