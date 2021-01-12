import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/views/page/login_home.dart';
import 'package:ainidiu/views/services/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmarReset extends StatefulWidget {
  final User usuario;
  ConfirmarReset({this.usuario});
  @override
  _ConfirmarResetState createState() => _ConfirmarResetState();
}

class _ConfirmarResetState extends State<ConfirmarReset> {
  bool _loading = false;

  FbRepository repository = new FbRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
              child: AlertDialog(
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
              (_loading)
                  ? Container()
                  : FlatButton(
                      child: Text("Voltar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
              (_loading)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : FlatButton(
                      child: Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('user', null);

                        await repository.resetPosts(widget.usuario);

                        Navigator.of(context).pop();

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginHome()),
                            (route) => false);
                      },
                    ),
            ],
          )),
        ),
      ),
    );
  }
}
