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

  String formatarHora(DateTime hora) {
    String horaFormatada;

    if (hora.hour < 10) {
      if (hora.minute < 10) {
        horaFormatada = '0${hora.hour}:0${hora.minute}';
      } else {
        horaFormatada = '0${hora.hour}:${hora.minute}';
      }
    } else if (hora.minute < 10) {
      horaFormatada = '${hora.hour}:0${hora.minute}';
    } else {
      horaFormatada = '${hora.hour}:${hora.minute}';
    }

    return horaFormatada;
  }

  FbRepository repository = new FbRepository();
  _ChatHomeState({this.usuario});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: repository.carregarConversas(usuario.id),
        builder: (context, snapshot) {
          QuerySnapshot snap = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Você ainda não tem nenhuma conversa :('),
            );
          } else {
            return Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var outroId =
                      (snap.docs[index].data()['ids'][0] == usuario.id)
                          ? snap.docs[index].data()['ids'][1]
                          : snap.docs[index].data()['ids'][0];
                          
                  
                  DateTime date = snap.docs[index].data()['data'].toDate();

                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey, width: 0.5))),
                    child: ListTile(
                      onTap: () async {
                        if (canTap) {
                          canTap = false;
                          User user =
                              await repository.carregarDadosPorId(outroId);

                          try {
                            DocumentSnapshot userDoc = await repository
                                .getConexao()
                                .collection('chatHome')
                                .doc('${usuario.id}_$outroId')
                                .get();

                            List lidoPor = await userDoc.data()['lidaPor'];

                            if (!(lidoPor.contains(usuario.id))) {
                              await repository
                                  .getConexao()
                                  .collection('chatHome')
                                  .doc(userDoc.id)
                                  .update({
                                'lidaPor': [usuario.id, outroId]
                              });
                            }
                          } catch (ex) {
                            DocumentSnapshot userDoc = await repository
                                .getConexao()
                                .collection('chatHome')
                                .doc('${outroId}_${usuario.id}')
                                .get();

                            List lidoPor = await userDoc.data()['lidaPor'];

                            if (!(lidoPor.contains(usuario.id))) {
                              repository
                                  .getConexao()
                                  .collection('chatHome')
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
                            formatarHora(date),
                            style: TextStyle(
                                color: (snap.docs[index]
                                        .data()['lidaPor']
                                        .contains(usuario.id))
                                    ? Colors.grey
                                    : Colors.blue,
                                fontSize: 14.0),
                          ),
                          (snap.docs[index]
                                  .data()['lidaPor']
                                  .contains(usuario.id))
                              ? Text('')
                              : Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: (snap.docs[index]
                                              .data()['lidaPor']
                                              .contains(usuario.id))
                                          ? Colors.white
                                          : Colors.blue,
                                      shape: BoxShape.circle),
                                  child: (snap.docs[index]
                                          .data()['lidaPor']
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
                          backgroundImage: NetworkImage(snap.docs[index].data()['foto'][outroId.toString()],),
                          radius: 25,   
                        ),
                      ),
                      title: Text(
                        snap.docs[index].data()['apelido'][outroId.toString()],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          snap.docs[index].data()['conversa'],
                          style: (snap.docs[index]
                                  .data()['lidaPor']
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
