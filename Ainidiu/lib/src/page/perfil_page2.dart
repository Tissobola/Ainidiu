import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/configuracoes_page.dart';
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
    return Container(
      color: corFundo,
      child: Stack(
        children: <Widget>[
          Container(height: 230, color: Colors.blue[300]),
          Column(
            children: <Widget>[
              SizedBox(
                height: 120,
              ),
              GestureDetector(
                onVerticalDragUpdate: (d) {
                  setState(() {
                    corFundo = Colors.red;
                  });
                },
                onHorizontalDragUpdate: (d) {
                  setState(() {
                    corFundo = Colors.black;
                  });
                },
                child: ClipOval(
                  child: Container(
                    height: 200,
                    width: 480,
                    //color: Colors.blue[300],
                    decoration:
                        BoxDecoration(color: Colors.blue[300], boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        spreadRadius: 50,
                        blurRadius: 70,
                        offset: Offset(0, 0),
                      )
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                onPressed: () async {
                  await repository.resetPosts();
                },
                color: Colors.red,
                child: Container(
                  child: Text(
                    'RESET',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
                                colors: [Colors.blue[200], Colors.blue[300]],
                                stops: [0, 1])),
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
    );
  }
}
