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
        'Conversa $i',
        'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
      ),
    );

    return ListView.builder(
      itemCount: conversas.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(conversas[index].foto),
          title: Text(conversas[index].apelido),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat(),
                  settings: RouteSettings(
                    arguments: conversas[index],
                  ),
                ));
          },
          contentPadding: EdgeInsets.fromLTRB(0, 2, 0, 2),
        );
      },
    );
  }
}

class Conversas {
  final String apelido;
  final String foto;

  Conversas(this.apelido, this.foto);
}
