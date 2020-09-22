import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/conversas.dart';
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
  _ChatHomeState({this.usuario});
  @override
  Widget build(BuildContext context) {
    FbRepository repository = new FbRepository();
   

    return Container(
      //color: Colors.pink,
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
                  var outroId = outroid(snapshot.data[index].apelido);

                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey, width: 0.5))),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat(
                                      apelido: snapshot.data[index].apelido,
                                      myId: usuario.id,
                                      id: outroId,
                                    )));
                      },
                      leading: CircleAvatar(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png'),
                        radius: 25,
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
                            style: TextStyle(
                                color: Colors.grey, fontSize: 14.0),
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

  outroid(String apelido) {
    String id = '';
    bool jaPassou = false;
    for (int i = 0; i < apelido.length; i++) {
      if (apelido[i] == ' ') {
        jaPassou = true;
      } else {
        if (jaPassou) {
          id += apelido[i];
        }
      }
    }
    print('id = $id');
    return int.parse(id);
  }
}
