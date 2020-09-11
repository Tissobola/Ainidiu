import 'dart:developer';

import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/liste_view_post_card.dart';
import 'package:ainidiu/src/page/escrever_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class PrincipalPage extends StatefulWidget {
  User usuario;
  PrincipalPage({Key key, this.usuario}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState(usuario: usuario);
}

class _PrincipalPageState extends State<PrincipalPage> {
  User usuario;
  _PrincipalPageState({this.usuario});

  FbRepository repository = FbRepository();

  Future<List<ItemData>> getFutureDados() async =>
      await Future.delayed(Duration(seconds: 0), () async {
        List<ItemData> aux = await repository.carregarPostagens();
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
      ///Usando o componente ListViewPostCard, passando como parâmetro a fonte de dados
      body: RefreshIndicator(
        onRefresh: _reload,
              child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: ListViewPostCard(usuario: usuario, handleGetDataSoource: postagens),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Escrever(
                        usuario: usuario.apelido,
                      )));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add_comment, color: Colors.white,),
      ),
    );
  }
}
