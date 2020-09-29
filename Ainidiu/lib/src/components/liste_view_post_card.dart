import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/post_card.dart';
import 'package:ainidiu/src/page/denunciar_postagem_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

///Compoente de ira listar todas as postagem
///Com rolagem
class ListViewPostCard extends StatefulWidget {
  Future<List<ItemData>> handleGetDataSoource;
  User usuario;

  ListViewPostCard({Key key, this.usuario, this.handleGetDataSoource})
      : super(key: key);

  @override
  _ListViewPostCardState createState() =>
      _ListViewPostCardState(usuario: usuario);
}

class _ListViewPostCardState extends State<ListViewPostCard> {
  FbRepository repository = FbRepository();
  User usuario;
  _ListViewPostCardState({this.usuario});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemData>>(
        future: getDataSource(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Carregando as postagens...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          } else {
            var last = snapshot.data.length - 1;
            return Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  if (i == last) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.delete_sweep),
                            Text('Me senti ofendido...'),
                          ],
                        ),
                      ),
                      key: UniqueKey(),
                      child: PostCard(context, snapshot.data[i], usuario),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Denunciar(
                                    usuario: usuario, id: snapshot.data[i].id)));
                      },
                  ),
                    );
                  }

                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.delete_sweep),
                          Text('Me senti ofendido...'),
                        ],
                      ),
                    ),
                    key: UniqueKey(),
                    child: PostCard(context, snapshot.data[i], usuario),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Denunciar(
                                  usuario: usuario, id: snapshot.data[i].id)));
                    },
                  );
                },
              ),
            );
          }
        });
  }

  Future<List<ItemData>> getDataSource() {
    return this.widget.handleGetDataSoource;
  }
}

class ListViewMeusPostCards extends StatefulWidget {
  Future<List<ItemData>> handleGetDataSoource;
  User usuario;

  ListViewMeusPostCards({Key key, this.usuario, this.handleGetDataSoource})
      : super(key: key);

  @override
  _ListViewMeusPostCardsState createState() =>
      _ListViewMeusPostCardsState(usuario: usuario);
}

class _ListViewMeusPostCardsState extends State<ListViewMeusPostCards> {
  FbRepository repository = FbRepository();
  User usuario;
  _ListViewMeusPostCardsState({this.usuario});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemData>>(
        future: getDataSource(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Carregando as postagens...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          } else {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
              itemCount: (snapshot.data.length >= 3) ? snapshot.data.length : snapshot.data.length,
              itemBuilder: (context, i) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.delete_sweep),
                        Text('Me senti ofendido...', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  key: UniqueKey(),
                  child: PostCard(context, snapshot.data[i], usuario),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Denunciar(
                                usuario: usuario, id: snapshot.data[i].id)));
                  },
                );
              },
            );
          }
        });
  }

  Future<List<ItemData>> getDataSource() {
    return this.widget.handleGetDataSoource;
  }
}
