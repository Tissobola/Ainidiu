import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/listview_with_pagination.dart';
import 'package:ainidiu/src/page/chat_home.dart';
import 'package:ainidiu/src/page/escrever_page.dart';
import 'package:ainidiu/src/page/perfil_page2.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';

class HomePage extends StatefulWidget {
  int inicio;
  User usuario;
  String apelido;
  HomePage(this.inicio, {Key key, this.usuario, this.apelido})
      : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(usuario: usuario, apelido: apelido);
}

class _HomePageState extends State<HomePage> {
  int bottomSelectedIndex;
  User usuario;
  String apelido;

  FbRepository repository = new FbRepository();
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

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

  PageController pageController;

  getQuery() {
    return FirebaseFirestore.instance
        .collection('postagens')
        .orderBy('id', descending: true);
  }

  @override
  void initState() {
    bottomSelectedIndex = this.widget.inicio;
    pageController = PageController(
      initialPage: bottomSelectedIndex,
    );
    super.initState();
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        ChatHome(
          usuario: usuario,
        ),
        ListiviewPagination(usuario: usuario,),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: (bottomSelectedIndex == 1)
            ? FloatingActionButton(
                child: Icon(
                  Icons.add_comment,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Escrever(
                                usuario: usuario,
                              )));
                })
            : null,
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
          0,
          usuario: snapshot.data,
        );
      },
    );
  }
}
