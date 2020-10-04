import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:flutter/material.dart';

class DadosPessoais extends StatefulWidget {
  User usuario;
  DadosPessoais({this.usuario});
  @override
  _DadosPessoaisState createState() => _DadosPessoaisState(usuario: usuario);
}

class _DadosPessoaisState extends State<DadosPessoais> {
  User usuario;
  _DadosPessoaisState({this.usuario});

  FbRepository repository = new FbRepository();

  List<Widget> dados = new List<Widget>();

  String senha(String senha) {
    String password = '';

    for (int i = 0; i < senha.length; i++) {
      password += '*';
    }

    return password;
  }

  @override
  void initState() {
    dados = [
      ListTile(
        title: Text('Apelido'),
        subtitle: Text(usuario.apelido),
      ),
      ListTile(
        title: Text('Seu ID'),
        subtitle: Text(usuario.id.toString()),
      ),
      Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 27,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(usuario.imageURL),
                backgroundColor: Colors.white,
              ),
            ),
            FlatButton(
              onPressed: () async {
                await repository.updateDados(usuario, 'foto');
              },
              child: Text(
                'Editar',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            )
          ],
        ),
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Stack(
            children: [
              ListTile(
                title: Text('Gênero'),
                subtitle: Text(usuario.genero),
                focusColor: Colors.red,
                hoverColor: Colors.red,
              ),
              Positioned(
                right: 15,
                top: 10,
                child: FlatButton(
                  onPressed: () async {
                    await repository.updateDados(usuario, 'genero');
                  },
                  child: Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Stack(
            children: [
              ListTile(
                title: Text('Email'),
                subtitle: Text(usuario.email),
                focusColor: Colors.red,
                hoverColor: Colors.red,
              ),
              Positioned(
                right: 15,
                top: 10,
                child: FlatButton(
                  onPressed: () async {
                    await repository.updateDados(usuario, 'email');
                  },
                  child: Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Stack(
            children: [
              ListTile(
                title: Text('Senha'),
                subtitle: Text(senha(usuario.senha)),
                focusColor: Colors.red,
                hoverColor: Colors.red,
              ),
              Positioned(
                right: 15,
                top: 10,
                child: FlatButton(
                  onPressed: () async {
                    await repository.updateDados(usuario, 'senha');
                  },
                  child: Text(
                    'Editar',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Pessoais'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dados.length,
          itemBuilder: (context, index) {
            return dados[index];
          },
        ),
      ),
    );
  }
}
