import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/chat_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  User usuario;
  ChatHome({Key key, this.usuario}) : super(key: key);
  @override
  _ChatHomeState createState() => _ChatHomeState(usuario: usuario);
}

class _ChatHomeState extends State<ChatHome> {
  User usuario;
  bool canTap = true;

  FbRepository repository = new FbRepository();
  _ChatHomeState({this.usuario});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: repository.minhasConversas(usuario.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text('Você ainda não tem nenhuma conversa :('),
            );
          } else {
            return Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var outroId = (snapshot.data[index].ids[0] == usuario.id)
                      ? snapshot.data[index].ids[1]
                      : snapshot.data[index].ids[0];

                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey, width: 0.5))),
                    child: ListTile(
                      onTap: () async {
                        print('canTap = $canTap');
                        if (canTap) {
                          canTap = false;
                          User user = await repository.carregarDadosDoUsuario(
                              snapshot.data[index].apelido);

                          try {
                            DocumentSnapshot userDoc = await repository
                                .getConexao()
                                .collection('chat')
                                .doc('${usuario.id}_$outroId')
                                .get();

                            List lidoPor = await userDoc.data()['lidaPor'];

                            if (!(lidoPor.contains(usuario.id))) {
                              await repository
                                  .getConexao()
                                  .collection('chat')
                                  .doc(userDoc.id)
                                  .update({
                                'lidaPor': [usuario.id, outroId]
                              });
                            }
                          } catch (ex) {
                            DocumentSnapshot userDoc = await repository
                                .getConexao()
                                .collection('chat')
                                .doc('${outroId}_${usuario.id}')
                                .get();

                            List lidoPor = await userDoc.data()['lidaPor'];

                            if (!(lidoPor.contains(usuario.id))) {
                              repository
                                  .getConexao()
                                  .collection('chat')
                                  .doc(userDoc.id)
                                  .update({
                                'lidaPor': [usuario.id, outroId]
                              });
                            }
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Chat(
                                        user: user,
                                        userEu: usuario,
                                        myId: usuario.id,
                                        id: outroId,
                                      ))).then((value) {
                            setState(() {
                              canTap = true;
                            });
                          });
                        }
                      },
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            snapshot.data[index].data,
                            style: TextStyle(
                                color: (snapshot.data[index].lidaPor
                                        .contains(usuario.id))
                                    ? Colors.grey
                                    : Colors.blue,
                                fontSize: 14.0),
                          ),
                          (snapshot.data[index].lidaPor.contains(usuario.id))
                              ? Text('')
                              : Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: (snapshot.data[index].lidaPor
                                              .contains(usuario.id))
                                          ? Colors.white
                                          : Colors.blue,
                                      shape: BoxShape.circle),
                                  child: (snapshot.data[index].lidaPor
                                          .contains(usuario.id))
                                      ? null
                                      : Center(
                                          child: Text(
                                          '!',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                )
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 27,
                        child: CircleAvatar(
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(snapshot.data[index].foto),
                          radius: 25,
                        ),
                      ),
                      title: Text(
                        snapshot.data[index].apelido,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          snapshot.data[index].conversa.toString(),
                          style: (snapshot.data[index].lidaPor
                                  .contains(usuario.id))
                              ? TextStyle(color: Colors.grey, fontSize: 15.0)
                              : TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> profilePicture(String apelido) async {
    FbRepository repository = new FbRepository();
    User user = await repository.carregarDadosDoUsuario(apelido);
    return user.imageURL;
  }
}
