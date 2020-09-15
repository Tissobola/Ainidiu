import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/page/sobre_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracoes extends StatefulWidget {
  User usuario;

  Configuracoes({this.usuario});
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState(usuario: usuario);
}

class _ConfiguracoesState extends State<Configuracoes> {
  FbRepository repository = new FbRepository();

  User usuario;
  _ConfiguracoesState({this.usuario});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Configurações'),
        ),
        body: opcoesListView());
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Você tem certeza?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Isso irá apagar todas as suas postagens, conversas e mudará seu ID de perfil.')
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Voltar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await repository.resetPosts(usuario);
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginHome()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  opcoesListView() {
    return ListView(
      children: <Widget>[
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

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginHome()),
                (route) => false);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text(
            'RESET',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () async {
            //await repository.resetPosts(usuario);
            _showMyDialog();
          },
        )
      ],
    );
  }
}
