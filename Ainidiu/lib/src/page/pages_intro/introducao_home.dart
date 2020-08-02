import 'package:ainidiu/src/services/firebase_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _page = 1;
  String _backgroundURL = '';

  @override
  initState() {
    getBackground();
    super.initState();
  }

  Future getBackground() async {
    var storage = FirebaseStorage.instance;
    String url;
  
     url = await storage
          .ref()
          .child('background/fundo_azul.png')
          .getDownloadURL();

    return url;
  }

  Widget filho() {
    final larguraTela = MediaQuery.of(context).size.width;
    final alturaTela = MediaQuery.of(context).size.height;

    Widget background() {
      altura(p, h) {
        if (p == 1) {
          return null;
        } else if (p == 2) {
          return h / 4;
        } else if (p == 3) {
          return h / 2;
        } else {
          return h - 48;
        }
      }

      return FutureBuilder(
        future: getBackground(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!(snapshot.connectionState == ConnectionState.done)) {
            return null;
          } else {
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(snapshot.data), fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: altura(_page, MediaQuery.of(context).size.height),
                    color: Colors.white,
                  )
                ],
              ),
            );
          }
        },
      );
    }

    if (_page == 1) {
      return Center(
        child: background(),
      );
    } else if (_page == 2) {
      return Center(
        child: background(),
      );
    } else if (_page == 3) {
      return Center(
        child: background(),
      );
    } else if (_page == 4) {
      return Center(
        child: background(),
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

  var cor = Colors.white;
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

    var backPage = () {
      if (_page == 1) {
        //cor = Colors.black;
      } else if (_page == 2) {
        setState(() {
          _page = 1;
          //cor = Colors.red;
        });
      } else if (_page == 3) {
        setState(() {
          _page = 2;
          //cor = Colors.green;
        });
      } else if (_page == 4) {
        setState(() {
          _page = 3;
          //cor = Colors.yellow;
        });
      }
    };

    var nextPage = () {
      if (_page == 1) {
        setState(() {
          //cor = Colors.green;
          _page = 2;
        });
      } else if (_page == 2) {
        setState(() {
          //cor = Colors.yellow;
          _page = 3;
        });
      } else if (_page == 3) {
        setState(() {
          //cor = Colors.blue;
          _page = 4;
        });
      } else {
        print('DONE');
      }
    };

    return AnimatedContainer(
        duration: Duration(seconds: 1),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
                onPressed: backPage,
                child: Text(
                  back,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
            bolinha(_page),
            FlatButton(
                onPressed: nextPage,
                child: Text(
                  next,
                  style: TextStyle(color: Colors.white, fontSize: 15),
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
        child: Dismissible(
          resizeDuration: null,
          key: ValueKey(_page),
          child: filho(),
          onDismissed: (direction) {
            var backPage = () {
              if (_page == 1) {
                setState(() {
                  _page = 1;
                  //cor = Colors.red;
                });
              } else if (_page == 2) {
                setState(() {
                  _page = 1;
                  //cor = Colors.red;
                });
              } else if (_page == 3) {
                setState(() {
                  _page = 2;
                  //cor = Colors.green;
                });
              } else if (_page == 4) {
                setState(() {
                  _page = 3;
                  //cor = Colors.yellow;
                });
              }
            };

            var nextPage = () {
              if (_page == 1) {
                setState(() {
                  //cor = Colors.green;
                  _page = 2;
                });
              } else if (_page == 2) {
                setState(() {
                  //cor = Colors.yellow;
                  _page = 3;
                });
              } else if (_page == 3) {
                setState(() {
                  //cor = Colors.blue;
                  _page = 4;
                });
              } else {
                print('DONE');
              }
            };

            if (direction == DismissDirection.endToStart) {
              nextPage();
            } else if (direction == DismissDirection.startToEnd) {
              backPage();
            }
          },
        ),
      ),
    );
  }
}
