import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/components/post_card.dart';
import 'package:ainidiu/src/page/denunciar_postagem_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

///Compoente de ira listar todas as postagem
///Com rolagem
class ListViewPostCard extends StatefulWidget {
  Future<List<ItemData>> handleGetDataSoource;

  ListViewPostCard(this.handleGetDataSoource);

  @override
  _ListViewPostCardState createState() => _ListViewPostCardState();
}

class _ListViewPostCardState extends State<ListViewPostCard> {
  FbRepository repository = FbRepository();

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
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Me senti ofendido...'),
                        Icon(Icons.delete)
                      ],
                    ),
                  ),
                  key: UniqueKey(),
                  child: PostCard(context, snapshot.data[i]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {});
                    
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Denunciar(snapshot.data[i].id)));
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