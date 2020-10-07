import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/chat_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  User usuario;
  ChatHome({Key key, this.usuario}) : super(key: key);
  @override
  _ChatHomeState createState() => _ChatHomeState(usuario: usuario);
}

class _ChatHomeState extends State<ChatHome> {
  User usuario;

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
                        //outro
                        User user = await repository.carregarDadosDoUsuario(
                            snapshot.data[index].apelido);
                      
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat(
                                      user: user,
                                      userEu: usuario,
                                      myId: usuario.id,
                                      id: outroId,
                                    )));
                      },
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            snapshot.data[index].apelido,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data[index].data,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0),
                          )
                        ],
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          snapshot.data[index].conversa.toString(),
                          style:
                              new TextStyle(color: Colors.grey, fontSize: 15.0),
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
