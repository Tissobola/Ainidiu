import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/liste_view_post_card.dart';
import 'package:ainidiu/src/page/configuracoes_page.dart';
import 'package:ainidiu/src/page/meus_posts.dart';
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
        print(ex);
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
      radius: 70,
      backgroundColor: Colors.black,
      child: CircleAvatar(
        radius: 65,
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
    ThemeData localTheme = Theme.of(context);
    return Container(

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
  }
}


