
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _page = 1;
  

  Widget filho() {
    final larguraTela = MediaQuery.of(context).size.width;
    final alturaTela = MediaQuery.of(context).size.height;
    if (_page == 1) {
      return Container(
        width: larguraTela,
        height: alturaTela,
        child: Stack(
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            )
          ],
        ),
      );
    } else if (_page == 2) {
      return Center(
        child: Text('Page $_page'),
      );
    } else if (_page == 3) {
      return Center(
        child: Text('Page $_page'),
      );
    } else if (_page == 4) {
      return Center(
        child: Text('Page $_page'),
      );
    }
    return null;
  }

  bolinha(page) {
    var c1 = Colors.black;
    var c2 = Colors.black;
    var c3 = Colors.black;
    var c4 = Colors.black;

    if (page == 1) {
      c1 = Colors.red;
    } else if (page == 2) {
      c2 = Colors.red;
    } else if (page == 3) {
      c3 = Colors.red;
    } else {
      c4 = Colors.red;
    }

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c1,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c2,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c3,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c4,
            ),
          )
        ],
      ),
    );
  }

  var cor = Colors.red;
  var back;
  var next;

  barra() {
    if (_page == 1) {
      back = '';
    } else {
      back = 'BACK';
    }

    if (_page == 4) {
      next = 'DONE';
    } else {
      next = 'NEXT';
    }

    return AnimatedContainer(
        duration: Duration(seconds: 1),
        color: cor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  if (_page == 1) {
                  } else if (_page == 2) {
                    setState(() {
                      _page = 1;
                      cor = Colors.red;
                    });
                  } else if (_page == 3) {
                    setState(() {
                      _page = 2;
                      cor = Colors.green;
                    });
                  } else if (_page == 4) {
                    setState(() {
                      _page = 3;
                      cor = Colors.yellow;
                    });
                  }
                },
                child: Text(
                  back,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            bolinha(_page),
            FlatButton(
                onPressed: () {
                  //print('page = $_page');
                  if (_page == 1) {
                    setState(() {
                      cor = Colors.green;
                      _page = 2;
                    });
                  } else if (_page == 2) {
                    setState(() {
                      cor = Colors.yellow;
                      _page = 3;
                    });
                  } else if (_page == 3) {
                    setState(() {
                      cor = Colors.blue;
                      _page = 4;
                    });
                  } else {
                    print('DONE');
                  }
                },
                child: Text(
                  next,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: barra(),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        color: cor,
        child: filho(),
      ),
    );
  }
}
