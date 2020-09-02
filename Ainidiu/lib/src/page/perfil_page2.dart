import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/liste_view_post_card.dart';
import 'package:ainidiu/src/page/configuracoes_page.dart';
import 'package:ainidiu/src/page/meus_posts.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  User usuario;
  PerfilPage({Key key, this.usuario}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState(apelido: usuario);
}

class _PerfilPageState extends State<PerfilPage> {
  User apelido;
  _PerfilPageState({this.apelido});

  bool view = false;

  FbRepository repository = FbRepository();

  Future<List<ItemData>> getFuruteDados() async {
    List<ItemData> aux = await repository.carregarMinhasPostagens(apelido.id);
    return aux;
  }

  CircleAvatar buildAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.black,
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(apelido.imageURL),
      ),
    );
  }

  Widget test = Icon(
    Icons.favorite,
    color: Colors.white,
    size: 100,
  );

  var corFundo = Colors.white;

  @override
  Widget build(BuildContext context) {
    ThemeData localTheme = Theme.of(context);
    return Container(
      color: corFundo,
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(height: 200, color: Colors.blue[300]),
              Column(
                children: <Widget>[
                  Center(
                      child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: IconButton(
                            icon: Icon(
                              Icons.settings,
                              size: 45,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Configuracoes()));
                            }),
                        top: 0,
                        right: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Center(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 90,
                                ),
                                Text(
                                  '${apelido.apelido}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                              ],
                            ),
                            height: 150,
                            width: 350,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.blue[200],
                                  Colors.blue[300]
                                ],
                                    stops: [
                                  0,
                                  1
                                ])),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(child: buildAvatar()),
                      )
                    ],
                  )),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom:
                    BorderSide(width: 2.0, color: Colors.lightBlue.shade600),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Minhas Postagens',
                      style: localTheme.textTheme.title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: RaisedButton(
                        color: corFundo,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MeusPosts(usuario: apelido,)));
                        },
                        child: Text('Ver todas')),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 451,
            child: ListViewMeusPostCards(
              usuario: apelido,
              handleGetDataSoource: getFuruteDados(),
            ),
          )
        ],
      ),
    );
  }
}
