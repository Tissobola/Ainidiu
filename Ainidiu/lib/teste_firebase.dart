import 'package:flutter/material.dart';

/*


class FbRepository {
  Firestore getConexao() {
    return Firestore.instance;
  }
}
*/
class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste do FireBase"),
      ),
    );
  }
}
