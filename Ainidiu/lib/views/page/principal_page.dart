import 'package:ainidiu/data/models/item.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/components/listview_with_pagination.dart';
import 'package:ainidiu/views/page/escrever_page.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class PrincipalPage extends StatefulWidget {
  final User usuario;
  
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Usando o componente ListViewPostCard, passando como parâmetro a fonte de dados
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: ListiviewPagination(usuario: usuario, collection: 'postagens',)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Escrever(
                        usuario: usuario,
                      )));
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.add_comment,
          color: Colors.white,
        ),
      ),
    );
  }
}
