import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/components/liste_view_post_card.dart';
import 'package:ainidiu/src/components/post_card.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';

///Tela de apresentação de detalhes de uma postagem
///onde é apresentando os comentarios
class DetalhePostagemPage extends StatefulWidget {
  ItemData postagem;

  DetalhePostagemPage(this.postagem);

  @override
  _DetalhePostagemPageState createState() => _DetalhePostagemPageState();
}

class _DetalhePostagemPageState extends State<DetalhePostagemPage> {

  ItemData getCurrent() {
    return this.widget.postagem;
  }

  FbRepository repository = FbRepository();

  Future<List<ItemData>> getFutureDados() async =>
      await Future.delayed(Duration(seconds: 1), () {
        return repository.carregarComentarios(this.getCurrent().id);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Comentários')),
      body: Column(
        children: <Widget>[
          PostCard(context, this.widget.postagem),
          Expanded(child: ListViewPostCard(getFutureDados()))
          
        ],
      ),
    );
  }
}