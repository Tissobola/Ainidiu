import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/liste_view_post_card.dart';
import 'package:ainidiu/src/page/escrever_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class PrincipalPage extends StatefulWidget {
  User usuario;
  PrincipalPage({Key key, this.usuario}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState(usuario: usuario);
}

class _PrincipalPageState extends State<PrincipalPage> {
  User usuario;
  _PrincipalPageState({this.usuario});

  FbRepository repository = FbRepository();

  List<ItemData> montaListaPostagem() {
    var postagens = new List<ItemData>();

    for (var i = 1; i <= 10; i++) {
      var comentarios = new List<ItemData>();
      if (i % 2 == 0) {
        var id = i + 1000;
        comentarios.add(ItemData(
            id,
            (i + 1000),
            'Comentario $i',
            'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
            'Text do comentário',
            'DateTime.now()',
            i));

        comentarios.add(ItemData(
            id,
            (i + 1000),
            'Comentario $i',
            'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
            'Outro texto de comentário, bala bla bla bla Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies. Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies. Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies',
            'DateTime.now()',
            i));

        comentarios[1].addComentario(
            ItemData(1, 1, 'postadoPorNome', 'imagemURL', 'texto', 'data', 1));
      }
      postagens.add(
          ItemData(1, 1, 'postadoPorNome', 'imagemURL', 'texto', 'data', 1));

      postagens[(i - 1)].addComentarios(comentarios);
    }
    return postagens;
  }

  ///Construindo um método Future, para vincular ao componente
  ///pois o componente espera os dados Futuros,
  ///ideal para usar com Firebase e webservices
  Future<List<ItemData>> getFutureDados() async =>
      await Future.delayed(Duration(seconds: 0), () async {
        List<ItemData> aux = await repository.carregarPostagens();
        return aux;
      });

  Future<List<ItemData>> postagens;

  @override
  void initState() {
    postagens = getFutureDados();
    super.initState();
  }

  Future<void> _reload() async {
    Future<List<ItemData>> aux = await Future.delayed(Duration(seconds: 3), () => getFutureDados());
    setState(() {
      postagens = aux;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Usando o componente ListViewPostCard, passando como parâmetro a fonte de dados
      body: RefreshIndicator(
        child: ListViewPostCard(postagens),
        onRefresh: _reload,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Escrever(
                        usuario: usuario.apelido,
                      )));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add_comment),
      ),
    );
  }
}
