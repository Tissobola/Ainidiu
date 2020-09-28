import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/chat_home.dart';
import 'package:ainidiu/src/page/perfil_page2.dart';
import 'package:ainidiu/src/page/principal_page.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  User usuario;
  String apelido;
  HomePage({Key key, this.usuario, this.apelido}) : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(usuario: usuario, apelido: apelido);
}

class _HomePageState extends State<HomePage> {
  int bottomSelectedIndex = 0;
  User usuario;
  String apelido;

  FbRepository repository = new FbRepository();

  _HomePageState({this.usuario, this.apelido});

  String namePage(bottomSelectedIndex) {
    String name;

    if (bottomSelectedIndex == 0) {
      name = 'Chat';
    } else if (bottomSelectedIndex == 1) {
      name = 'Ainidiu';
    } else {
      name = 'Perfil';
    }
    return name;
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    print('asd');
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        ChatHome(
          usuario: usuario,
        ),
        PrincipalPage(
          usuario: usuario,
        ),
        PerfilPage(
          usuario: usuario,
        ),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void lucasgay() {
    print('Lucas não é gay');
  }

  @override
  Widget build(BuildContext context) {
    print('testes = $usuario');

    return Scaffold(
        
        appBar: AppBar(
            title: Text(
          namePage(bottomSelectedIndex),
          style: TextStyle(color: Colors.white),
        )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomSelectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.message), title: Text('Chat')),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Perfil'))
          ],
          onTap: (index) {
            bottomTapped(index);
          },
        ),
        body: buildPageView());
  }
}

class Home extends StatefulWidget {
  String apelido;

  Home({this.apelido});

  @override
  _HomeState createState() => _HomeState(apelido: apelido);
}

class _HomeState extends State<Home> {
  String apelido;

  _HomeState({this.apelido});

  FbRepository repository = new FbRepository();

  @override
  Widget build(BuildContext context) {
    print('apelido = $apelido');

    return FutureBuilder(
      future: repository.carregarDadosDoUsuario(apelido),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return HomePage(
          usuario: snapshot.data,
        );
      },
    );
  }
}
