import 'package:ainidiu/src/page/chat_page.dart';
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
        body: conversasListView());
  }

  conversasListView() {
    final conversas = List<Conversas>.generate(
      20,
      (i) => Conversas(
        'Apelido $i',
        'Conversa $i',
        'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
      ),
    );

    return ListView.builder(
      itemCount: conversas.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Chat()));
          },
          leading: CircleAvatar(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png'),
            radius: 25,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                conversas[index].apelido,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '12:00',
                style: new TextStyle(color: Colors.grey, fontSize: 14.0),
              )
            ],
          ),
          subtitle: Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              conversas[index].conversa,
              style: new TextStyle(color: Colors.grey, fontSize: 15.0),
            ),
          ),
        );
      },
    );
  }
}

class Conversas {
  final String apelido;
  final String foto;
  final String conversa;

  Conversas(this.apelido, this.conversa, this.foto);
}
