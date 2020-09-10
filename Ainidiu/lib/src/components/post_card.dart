import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/chat_home.dart';
import 'package:ainidiu/src/page/comentar_page.dart';
import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'detalhe_postagem_page.dart';

///Componente de Card, compoente que monta e apresenta a postagem
class PostCard extends StatefulWidget {
  BuildContext context;
  ItemData current;
  User usuario;

  PostCard(this.context, this.current, this.usuario);

  @override
  _PostCardState createState() =>
      _PostCardState(usuario: usuario, current: current);
}

class _PostCardState extends State<PostCard> {
  ItemData current;
  User usuario;

  _PostCardState({this.usuario, this.current});

  ///Controler do texto da mensagem
  final textoController = TextEditingController();

  ///Espaçamento no final da largura do campo mensagem
  final espacamento = 150;

  ///Altura do card
  var alturaDoCard = 120.0;

  @override
  void initState() {
    super.initState();
    textoController.text = this.getCurrent().texto;
  }

  ///Verifica se esse card apresenta uma postagem ou um comentário
  bool ehComentario() {
    return this.getCurrent().parentId != 0;
  }

  ///Retorta o registro atual que esta sendo aprensentado
  ItemData getCurrent() {
    return this.widget.current;
  }

  ///Monta a notificação de comentarios, ao lado do botão comentar
  Widget getTotalComentarios() {
    var total = this.getCurrent().getComentarios().length;
    if (total > 0) return Text('($total)');
    return SizedBox();
  }

  ///Exibe a tarja azual quando é comentário

  Border exibeTarjaAzul() {
    if (this.ehComentario()) {
      return Border(left: BorderSide(color: Colors.blue, width: 3));
    }
    return Border();
  }

  Widget exibeEspaco() {
    if (this.ehComentario()) {
      return SizedBox(
        width: 3,
      );
    }
    return SizedBox();
  }

  FbRepository repository = FbRepository();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          ///Verifica se tem comentários para exibir os detalhes
          ///Métod executado sempre que clicar no card
          if (this.getCurrent().getComentarios().length > 0) {
            print('user = ${usuario.apelido}');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalhePostagemPage(
                        usuario: usuario, postagem: this.getCurrent())));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.grey)
            )
          ),
          child: Card(
            
            shape: exibeTarjaAzul(),
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      exibeEspaco(),

                      //Foto
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        backgroundImage:
                            NetworkImage(this.getCurrent().imagemURL),
                      ),

                      SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Apelido
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  this.getCurrent().postadoPorNome + "  -",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${this.getCurrent().data}",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          //Campo mensagem
                          Container(
                            width: (MediaQuery.of(context).size.width -
                                espacamento +
                                45),

                          
                            child: TextField(
                                onTap: () {
                                  ///Verifica se tem comentários para exibir os detalhes
                                  ///Métod executado sempre que clicar no card
                                  if (this.getCurrent().getComentarios().length >
                                      0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetalhePostagemPage(
                                                    usuario: usuario,
                                                    postagem:
                                                        this.getCurrent())));
                                  }
                                },
                                readOnly: true,
                                controller: textoController,
                                keyboardType: TextInputType.multiline,
                                textAlign: TextAlign.justify,
                                maxLines: null,
                                decoration:
                                    InputDecoration(border: InputBorder.none)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  //Botoes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            print(current.id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Comentar(
                                          usuario: current.postadoPorNome,
                                          current: current,
                                        )));
                            print('Clicou em comentar');
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.insert_comment,
                                
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              getTotalComentarios()
                            ],
                          )),
                      FlatButton(
                          onPressed: () async {
                            if (usuario.id == this.current.postadoPorId) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Você não pode falar com você mesmo ;-;')));
                            } else {
                              await repository.criarChat(
                                  usuario.id, this.current.postadoPorId);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(usuario: usuario)),
                                  (route) => false);
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.reply,
                                textDirection: TextDirection.rtl,
                                
                              )
                            ],
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
