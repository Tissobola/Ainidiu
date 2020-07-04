import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/components/liste_view_post_card.dart';
import 'package:ainidiu/src/page/escrever_page.dart';
import 'package:flutter/material.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
///Gerando postagens
  List<ItemData> montaListaPostagem() {
    var postagens = new List<ItemData>();

    for (var i = 1; i <= 10; i++) {
      var comentarios = new List<ItemData>();
      if(i % 2 == 0){
        var id = i + 1000;
        comentarios.add(ItemData(id,
          (i+1000),  
          'Comentario $i',
           'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
            'Text do comentário', 
            DateTime.now(),i));

         comentarios.add(ItemData(id,
          (i+1000),  
          'Comentario $i',
           'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
            'Outro texto de comentário, bala bla bla bla Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies. Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies. Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies', 
            DateTime.now(),i));

          comentarios[1].addComentario(ItemData(id,
          (i+1000),  
          'Comentario de Comentário',
           'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
            'Outro texto de comentário, bala bla bla bla Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies. Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies. Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies', 
            DateTime.now(),i));
      }
      postagens.add(ItemData(
          i,
          (i + 100),
          'Apelido $i',
          'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png',
          'Texto da postagem de exemplo $i. Lorem ipsum nam facilisis aenean nam lacus cursus ipsum, nulla sodales sed in rhoncus sapien odio litora, velit primis condimentum lobortis vulputate curabitur fringilla. condimentum laoreet ligula imperdiet cras aliquam vehicula suscipit aliquet in ultricies',
          DateTime.now(),0));
      
      postagens[(i-1)].addComentarios(comentarios);
    }
    return postagens;
  }

  ///Construindo um método Future, para vincular ao componente
  ///pois o componente espera os dados Futuros, 
  ///ideal para usar com Firebase e webservices
  Future<List<ItemData>> getFutureDados() async =>
      await Future.delayed(Duration(seconds: 5), () {
        return montaListaPostagem();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        ///Usando o componente ListViewPostCard, passando como parâmetro a fonte de dados
        body: ListViewPostCard(getFutureDados()),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Escrever()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add_comment),
      ),);
  }
}
