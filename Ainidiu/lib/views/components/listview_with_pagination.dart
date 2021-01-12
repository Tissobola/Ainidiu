import 'package:ainidiu/data/models/item.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/components/post_card.dart';
import 'package:ainidiu/views/page/denunciar_postagem_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ListiviewPagination extends StatefulWidget {
  ListiviewPagination({this.usuario, this.collection, this.postPai});

  final User usuario;
  final String collection;

  final ItemData postPai;
 
  @override
  _ListiviewPaginationState createState() => _ListiviewPaginationState();
}

class _ListiviewPaginationState extends State<ListiviewPagination> {
  @override
  Widget build(BuildContext context) {
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();

    return FutureBuilder(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          ));
        } else {
          return new RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  refreshChangeListener.refreshed = true;
                });
              });
            },
            child: PaginateFirestore(
                itemBuilder: (index, context, docSnap) {
                  var item = docSnap.data();

                  

                  ItemData post = new ItemData(
                      item['id'],
                      item['postadoPorId'],
                      item['postadoPorNome'],
                      item['imagemURL'],
                      item['texto'],
                      item['dataHora'],
                      item['parentId'],
                      item['comentarios']);

                  return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Denunciar(
                                      usuario: widget.usuario,
                                      id: post.id,
                                    )));
                      },
                      child: PostCard(context, post, widget.usuario));
                },
                listeners: [refreshChangeListener],
                query: (widget.collection == 'comentarios')
                    ? FirebaseFirestore.instance
                        .collection(widget.collection)
                        .where('parentId', isEqualTo: widget.postPai.id)
                    : FirebaseFirestore.instance
                        .collection('postagens')
                        .orderBy('id', descending: true),
                itemsPerPage: 10,
                itemBuilderType: PaginateBuilderType.listView),
          );
        }
      },
    );
  }

  future() async {
    await Future.delayed(Duration(milliseconds: 300));
    return 1;
  }
}


class ListviewMinhasPostagens extends StatefulWidget {
  ListviewMinhasPostagens({this.usuario, this.collection, this.postPai});

  final User usuario;
  final String collection;

  final ItemData postPai;
 
  @override
  _ListviewMinhasPostagensState createState() => _ListviewMinhasPostagensState();
}

class _ListviewMinhasPostagensState extends State<ListviewMinhasPostagens> {
  @override
  Widget build(BuildContext context) {
    PaginateRefreshedChangeListener refreshChangeListener =
        PaginateRefreshedChangeListener();

    return FutureBuilder(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          ));
        } else {
          return new RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  refreshChangeListener.refreshed = true;
                });
              });
            },
            child: PaginateFirestore(
                itemBuilder: (index, context, docSnap) {
                  var item = docSnap.data();

                  

                  ItemData post = new ItemData(
                      item['id'],
                      item['postadoPorId'],
                      item['postadoPorNome'],
                      item['imagemURL'],
                      item['texto'],
                      item['dataHora'],
                      item['parentId'],
                      item['comentarios']);

                  return Dismissible(
                      background: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Denunciar(
                                      usuario: widget.usuario,
                                      id: post.id,
                                    )));
                      },
                      child: PostCard(context, post, widget.usuario));
                },
                listeners: [refreshChangeListener],
                query: FirebaseFirestore.instance.collection('postagens').where('postadoPorId', isEqualTo: widget.usuario.id),
                itemsPerPage: 10,
                itemBuilderType: PaginateBuilderType.listView),
          );
        }
      },
    );
  }

  future() async {
    await Future.delayed(Duration(milliseconds: 300));
    return 1;
  }
}