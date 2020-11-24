import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  var configuracaoInitAndroid;
  var configuracaoInitIOs;
  var configuracaoInit;

  var serverToken =
      'AAAABtx9LIo:APA91bH6u2CwSsFvSFY0rnreRC6TrQTXMVIuBto8nyxgCdmxefrmhmaIrE-fsw6WtvC_Tk-XitERzgYhupdB9kdUn29PuxgBS-n_anwwjQW1_azNjfzU7AWl7nODEoNPrhAn7srHuAFr';

  mandarNotification(String token, texto) async {
    await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': texto,
              'title': 'Comentário no seu post!',
            },
            'priority': 'high',
            'to': token,
            'data': <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done",
              "message": "My Message",
              "title": "Meu Title"
            },
          },
        ));
  }

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
  ShapeBorder shapeBorder;
  final _formKey = GlobalKey<FormState>();
  TextEditingController msg = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool podeComentar = true;

    return GestureDetector(
        onTap: () async {
          ///Verifica se tem comentários para exibir os detalhes
          ///Métod executado sempre que clicar no card
          if (this.getCurrent().getComentarios().length > 0) { 
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalhePostagemPage(
                        usuario: usuario, postagem: this.getCurrent())));

           
          }
        },
        child: Container(
          decoration: BoxDecoration(
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
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 0.5,
                          color: Colors.grey
                        )
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        
                        Tooltip(
                          message: "Comentar",
                          child: FlatButton(
                              onPressed: () {
                                
                                Scaffold.of(context).showBottomSheet((context) {
                                  return Material(
                                    shadowColor: Colors.blue,
                                    elevation: 20,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                            ),
                                            // height: MediaQuery.of(context).size.height / 2,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: Row(
                                                      children: [
                                                        Text('Em resposta à ',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey)),
                                                        Text(
                                                            this
                                                                .widget
                                                                .current
                                                                .postadoPorNome,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue))
                                                      ],
                                                    ),
                                                  ),
                                                  Form(
                                                    key: _formKey,
                                                    child: TextFormField(
                                                      controller: msg,
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          return 'Escreva algo';
                                                        }
                                                        return null;
                                                      },
                                                      decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          hintText:
                                                              'Digite seu comentário',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey)),
                                                      minLines: 5,
                                                      maxLines: 10,
                                                      maxLength: 500,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      FlatButton(
                                                          child: Text("Voltar"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                      RaisedButton(
                                                        color: Colors.blue,
                                                        child: Text(
                                                          'Comentar',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () async {
                                                          if (podeComentar) {
                                                            podeComentar = false;
                                                            if (_formKey
                                                                .currentState
                                                                .validate()) {
                                                              await Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          600));
                                                              Navigator.pop(
                                                                  context);

                                                              await repository
                                                                  .escreverComentario(
                                                                      current.id,
                                                                      msg.text,
                                                                      this
                                                                          .widget
                                                                          .usuario);

                                                              QuerySnapshot
                                                                  postPai =
                                                                  await repository
                                                                      .getConexao()
                                                                      .collection(
                                                                          'postagens')
                                                                      .where('id',
                                                                          isEqualTo:
                                                                              current.id)
                                                                      .get();

                                                              User userPai = await repository
                                                                  .carregarDadosPorId(postPai
                                                                          .docs.last
                                                                          .data()[
                                                                      'postadoPorId']);

                                                              mandarNotification(
                                                                  userPai.token,
                                                                  msg.text);

                                                              msg.clear();
                                                              podeComentar = true;
                                                              
                                                            }
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.chat_bubble_outline,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  getTotalComentarios()
                                ],
                              )),
                        ),
                        Tooltip(
                          message: "Novo Chat",
                          child: FlatButton(
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
                                              HomePage(0, usuario: usuario)),
                                      (route) => false);
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.label_outline,
                                    //textDirection: TextDirection.rtl,
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
