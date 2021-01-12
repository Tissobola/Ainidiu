import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/page/confimar_reset.dart';
import 'package:ainidiu/views/page/dados_pessoais.dart';
import 'package:ainidiu/views/page/denuncias_sugestoes_mensagens.dart';
import 'package:ainidiu/views/page/login_home.dart';
import 'package:ainidiu/views/page/sobre_page.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracoes extends StatefulWidget {
  final User usuario;

  Configuracoes({this.usuario});
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState(usuario: usuario);
}

class _ConfiguracoesState extends State<Configuracoes> {
  FbRepository repository = new FbRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  User usuario;

  _ConfiguracoesState({this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Configurações'),
        ),
        body: opcoesListView(context));
  }

  opcoesListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Dados Pessoais'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DadosPessoais(
                          usuario: usuario,
                        )));
          },
        ),
        ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Sobre()));
            }),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sair'),
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('user', null);

            QuerySnapshot userDoc = await repository
                .getConexao()
                .collection('usuarios')
                .where('id', isEqualTo: usuario.id)
                .get();

            repository
                .getConexao()
                .collection('usuarios')
                .doc(userDoc.docs[0].id)
                .update({'token': ''});

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginHome()),
                (route) => false);
          },
        ),
        ListTile(
          leading: Icon(Icons.label_important),
          title: Text('Denúncias, Sugestões ou Mensagens'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OpinionPage(
                          usuario: usuario,
                        )));
          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text(
            'RESET',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfirmarReset(
                          usuario: usuario,
                        )));
          },
        )
      ],
    );
  }
}
