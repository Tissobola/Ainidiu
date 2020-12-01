import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/listview_with_pagination.dart';
import 'package:ainidiu/src/components/post_card.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';

///Tela de apresentação de detalhes de uma postagem
///onde é apresentando os comentarios
class DetalhePostagemPage extends StatefulWidget {
  final ItemData postagem;
  final User usuario;
  DetalhePostagemPage({Key key, this.usuario, this.postagem}) : super(key: key);

  @override
  _DetalhePostagemPageState createState() =>
      _DetalhePostagemPageState(usuario: usuario);
}

class _DetalhePostagemPageState extends State<DetalhePostagemPage> {
  User usuario;
  _DetalhePostagemPageState({this.usuario});

  ItemData getCurrent() {
    return this.widget.postagem;
  }

  FbRepository repository = FbRepository();

  Future<List<ItemData>> getFutureDados() {
    return repository.exibirComentarios(getCurrent());
  }

  Future<List<ItemData>> postagens;

  @override 
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comentários')),
      body: Column(
        children: <Widget>[
          PostCard(context, this.widget.postagem, usuario),
          Expanded(
              child: ListiviewPagination(usuario: usuario, collection: 'comentarios', postPai: getCurrent(),))
        ],
      ),
    );
  }
}
