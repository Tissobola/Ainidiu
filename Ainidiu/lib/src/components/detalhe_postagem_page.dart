import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/liste_view_post_card.dart';
import 'package:ainidiu/src/components/post_card.dart';
import 'package:ainidiu/src/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';

///Tela de apresentação de detalhes de uma postagem
///onde é apresentando os comentarios
class DetalhePostagemPage extends StatefulWidget {
  ItemData postagem;
  User usuario;
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

  Future<List<ItemData>> getFutureDados() async =>
      await Future.delayed(Duration(seconds: 1), () {
        return getCurrent().getComentarios();
      });

  Future<List<ItemData>> postagens;

  @override
  void initState() {
    postagens = getFutureDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comentários')),
      body: RefreshIndicator(
        onRefresh: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                    1,
                        usuario: usuario,
                      )),
              (route) => false);
        },
        child: Column(
          children: <Widget>[
            PostCard(context, this.widget.postagem, usuario),
            Expanded(
                child: ListViewPostCard(
              usuario: usuario,
              handleGetDataSoource: postagens,
            ))
          ],
        ),
      ),
    );
  }
}
