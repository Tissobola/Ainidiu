import 'package:ainidiu/src/page/messages_page.dart';
import 'package:ainidiu/src/page/perfil_page.dart';
import 'package:ainidiu/src/page/principal_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomSelectedIndex = 0;

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
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        MessagesPage(),
        PrincipalPage(),
        PerfilPage(),
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
      appBar: AppBar(title: Text(namePage(bottomSelectedIndex))),
      drawer: Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.message), title: Text('Chat')),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Perfil'))
        ],
        onTap: (index) {
          bottomTapped(index);
        },
      ),
      body: buildPageView(),
    );
  }
}
