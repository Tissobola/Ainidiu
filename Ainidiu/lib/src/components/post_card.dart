import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/comentar_page.dart';
import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/page/principal_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    return GestureDetector(
        onTap: () async {
          ///Verifica se tem comentários para exibir os detalhes
          ///Métod executado sempre que clicar no card
          if (this.getCurrent().getComentarios().length > 0) {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalhePostagemPage(
                        usuario: usuario, postagem: this.getCurrent())));

            try {
              if (result) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              1,
                              usuario: usuario,
                              apelido: usuario.apelido,
                            )));
              }
            } catch (ex) {}
          }
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
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
                        backgroundImage: NetworkImage(usuario.imageURL),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Tooltip(
                        message: "Comentar",
                        child: FlatButton(
                            onPressed: () {
                              Scaffold.of(context).hideCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40))),
                                  elevation: 50.0,
                                  duration: Duration(minutes: 5),
                                  backgroundColor: Colors.white,
                                  content: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          (MediaQuery.of(context).size.height *
                                                  0.15) +
                                              14,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Em resposta a ',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  this
                                                      .widget
                                                      .current
                                                      .postadoPorNome,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                            Form(
                                              key: _formKey,
                                              child: TextFormField(
                                                minLines: 2,
                                                maxLines: 3,
                                                controller: msg,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Escreva algo';
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: new InputDecoration(
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.0),
                                                    ),
                                                    hintText:
                                                        'Digite seu comentário',
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                RaisedButton(
                                                  child: Text('Comentar'),
                                                  onPressed: () async {
                                                    if (_formKey.currentState
                                                        .validate()) {
                                                      
                                                      repository
                                                          .escreverComentario(
                                                              current.id,
                                                              msg.text,
                                                              this
                                                                  .widget
                                                                  .usuario); 
                                                      QuerySnapshot postPai =
                                                          await repository
                                                              .getConexao()
                                                              .collection(
                                                                  'postagens')
                                                              .where('id',
                                                                  isEqualTo:
                                                                      current
                                                                          .id)
                                                              .get();

                                                      User userPai = await repository
                                                          .carregarDadosPorId(
                                                              postPai.docs.last
                                                                      .data()[
                                                                  'postadoPorId']);

                                                      mandarNotification(
                                                          userPai.token,
                                                          msg.text);

                                                      msg.clear();
                                                      Scaffold.of(context)
                                                          .hideCurrentSnackBar();
                                                    }
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )));
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
