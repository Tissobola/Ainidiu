import 'package:flutter/material.dart';
import 'package:ainidiu/src/page/messages_page.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final Conversas conversa = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(conversa.apelido),
      ),
      bottomNavigationBar: espacoDeDigitacao(),
      //persistentFooterButtons: <Widget>[IconButton(icon: Icon(Icons.send), onPressed:() {print('OK');})],
    );
  }

  espacoDeDigitacao() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
        child: Row (children: <Widget>[Container(width: 300,
        child:TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0))),
        ),),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                border: Border(),
                color: Colors.white,
              ),
              
              height: 59,
              width: 59,
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 50,
                ),
              ),
            ),
          ),
        )
        ]),
      ),
    );
  }
}