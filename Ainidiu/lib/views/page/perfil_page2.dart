import 'package:ainidiu/data/models/item.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/components/listview_with_pagination.dart';
import 'package:ainidiu/views/page/configuracoes_page.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  final User usuario;
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

  dynamic _retornaFoto(String caminho) {
    //return AssetImage('images/no_photo.png');
    if (caminho == null) {
      return AssetImage('assets/img/img (7).jpg');
    } else {
      try {
        return NetworkImage(caminho);
      } catch (ex) {
        
        return AssetImage('assets/img/img (7).jpg');
      }
    }
  }

  image(url) {
    try {
      return NetworkImage(url);
    } catch (e) {
      return NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/ainidiu-app.appspot.com/o/avatares%2Fimg%20(7).jpg?alt=media&token=c8a91725-86eb-49fe-9516-cc7c92048640");
    }
  }

  CircleAvatar buildAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.black,
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
        backgroundImage: _retornaFoto(apelido.imageURL),
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
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 3.0),
              width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                )
              ]),
              child: Stack(
                              children: 
                              [
                              Row(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 58,
                      backgroundImage: NetworkImage(apelido.imageURL),
                      backgroundColor: Colors.white,
                      
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(fontSize: 28),
                        ),
                        Text(
                          apelido.apelido,
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        )
                      ],
                    )
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(icon: Icon(Icons.settings, size: 35,), onPressed: () {
                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Configuracoes(usuario: apelido,)));
                  })
                  )
                ]
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  //borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
                  ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18, left: 20, bottom: 18),
                      child: Text(
                        'Minhas Postagens',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 500,
                      child: ListviewMinhasPostagens(usuario: apelido, collection: 'minhas postagens',),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*
Container(

      child: Column(

        children: [
          Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              height: 220.0,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.cyan,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(icon: Icon(Icons.settings, size: 40,), onPressed: () {}),
                      )
                    ],
                  ),
                  Center(child: buildAvatar()),
                ],
              ),
              
            ),
          ),
        ),
      ),
        ],

      ),

    );
*/

/**
 * Container(
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
                                  builder: (context) => MeusPosts(
                                        usuario: apelido,
                                      )));
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
 */
