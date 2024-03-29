import 'package:ainidiu/data/models/item.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/components/liste_view_post_card.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class MeusPosts extends StatefulWidget {
  final User usuario;
  MeusPosts({Key key, this.usuario}) : super(key: key);

  @override
  _MeusPostsState createState() => _MeusPostsState(usuario: usuario);
}

class _MeusPostsState extends State<MeusPosts> {
  User usuario;
  _MeusPostsState({this.usuario});

  FbRepository repository = FbRepository();

  Future<List<ItemData>> getFutureDados() async =>
      await Future.delayed(Duration(seconds: 0), () async {
        List<ItemData> aux = await repository.carregarMinhasPostagens(usuario.id);
        return aux;
      });

  Future<List<ItemData>> postagens;

  @override
  void initState() {
    postagens = getFutureDados();
    super.initState();
  }

  Future<void> _reload() async {
    Future<List<ItemData>> aux =
        await Future.delayed(Duration(seconds: 1), () => getFutureDados());
    setState(() {
      postagens = aux;
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Posts'),
      ),

      ///Usando o componente ListViewPostCard, passando como parâmetro a fonte de dados
      body: RefreshIndicator(
        child: ListViewMeusPostCards(
            usuario: usuario, handleGetDataSoource: postagens),
        onRefresh: _reload,
      ),
    );
  }
}
