import 'package:ainidiu/src/page/home_page.dart';
import 'package:ainidiu/src/page/login_home.dart';
import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

a() async {
  SharedPreferences a = await SharedPreferences.getInstance();
  // a.setString(key, value)
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FbRepository repository = new FbRepository();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() { 
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ainidiu',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //HomePage() para o app
        //IntroPage() para a introdução
        //LoginHome para login

        //home: HomePage()
        //home: IntroPage(),
        //home: LoginHome(),
        home: FutureBuilder(
          future: repository.loginAuto(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                              body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.data == null) {
                return Center(
                  child: Text('null'),
                );
              } else {
                return HomePage(usuario: snapshot.data,);
              }
            }
          },
        ));
  }
}
