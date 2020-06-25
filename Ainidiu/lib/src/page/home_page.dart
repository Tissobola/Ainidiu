class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final _pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ainidiu')),
      drawer: Drawer(),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
        icon: Icon(Icons.message),
        title: Text('Chat')
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home')
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text('Perfil')
        )
      ]),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Container(color: Colors.red),
          Container(color: Colors.brown),
          Container(color: Colors.green)
        ]
      )
    );
  }
}

