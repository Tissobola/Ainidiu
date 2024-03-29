import 'package:ainidiu/data/models/item.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/components/post_card.dart';
import 'package:ainidiu/views/page/denunciar_postagem_page.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:flutter/material.dart';

///Compoente de ira listar todas as postagem
///Com rolagem
class ListViewPostCard extends StatefulWidget {
  final Future<List<ItemData>> handleGetDataSoource;
  final User usuario;

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
            var count = snapshot.data.length + 1;
            return Container(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: count,
                itemBuilder: (context, i) {
                
                  if (i == count - 1) {
                    return Container(
                      height: 120,
                      width: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Arraste para baixo para atualizar'),
                          Icon(Icons.arrow_downward, size: 40,)
                        ],
                      )
                    );
                  }

                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.delete_sweep,
                            color: Colors.white,
                          ),
                          Text(
                            'Me senti ofendido...',
                            style: TextStyle(color: Colors.white),
                          ),
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
  final Future<List<ItemData>> handleGetDataSoource;
  final User usuario;

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
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete_sweep,
                          color: Colors.white,
                        ),
                        Text(
                          'Me senti ofendido...',
                          style: TextStyle(color: Colors.white),
                        ),
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
