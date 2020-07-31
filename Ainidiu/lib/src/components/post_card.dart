import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/page/comentar_page.dart';
import 'package:flutter/material.dart';

import 'detalhe_postagem_page.dart';

///Componente de Card, compoente que monta e apresenta a postagem
class PostCard extends StatefulWidget {
  BuildContext context;
  ItemData current;

  PostCard(this.context, this.current);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          ///Verifica se tem comentários para exibir os detalhes
          ///Métod executado sempre que clicar no card
          if (this.getCurrent().getComentarios().length > 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetalhePostagemPage(this.getCurrent())));
          }
        },
        child: Dismissible(
          key: Key(this.getCurrent().id.toString()),
          background: Container(
            color: Colors.red[200],
            child: Align(
              alignment: Alignment(-0.9, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete_sweep,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Me senti ofendido com esse conteúdo',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          direction: DismissDirection.endToStart,
          //Ação para deuninciar a publicação
          onDismissed: (direcao) {
            print('Clicou em denunciar a postagem');
          },

          child: Card(
            shape: exibeTarjaAzul(),
            elevation: 1,
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

                            /*
                                Codigo que coloca borda no campo de mensagem
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(const Radius.circular(8)),
                        ),
                        */
                            child: TextField(
                                onTap: () {
                                  ///Verifica se tem comentários para exibir os detalhes
                                  ///Métod executado sempre que clicar no card
                                  if (this
                                          .getCurrent()
                                          .getComentarios()
                                          .length >
                                      0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetalhePostagemPage(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Comentar()));
                            print('Clicou em comentar');
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.insert_comment),
                              SizedBox(
                                width: 10,
                              ),
                              getTotalComentarios()
                            ],
                          )),
                      FlatButton(
                          onPressed: () {
                            print('Clicou em Chat');
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

denunciarPostagem() {
  
}

/*
Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 10, 1),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          exibeTarjaAzul(),

                          //Foto
                          Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          this.getCurrent().imagemURL)),
                                  border: Border.all(color: Colors.grey))),

                          SizedBox(width: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              //Apelido
                              Container(
                                width: (MediaQuery.of(context).size.width -
                                    espacamento),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      this.getCurrent().postadoPorNome,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      this.getCurrent().dataHora.toString(),
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
                                    espacamento),
                                height: alturaDoCard,
                                /*
                                Codigo que coloca borda no campo de mensagem
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(const Radius.circular(8)),
                        ),
                        */
                                child: TextField(
                                    readOnly: true,
                                    controller: textoController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        border: InputBorder.none)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      //Botoes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Comentar()));
                                print('Clicou em comentar');
                              },
                              child: Row(
                                children: <Widget>[
                                  Text('Comentar '),
                                  getTotalComentarios()
                                ],
                              )),
                          FlatButton(
                              onPressed: () {
                                print('Clicou em Chat');
                              },
                              child: Row(
                                children: <Widget>[Text('Chat')],
                              ))
                        ],
                      )
                    ],
                  ),
            ),
          ),
        */
