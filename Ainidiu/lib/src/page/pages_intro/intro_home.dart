import 'package:flutter/material.dart';

class IntroHome extends StatefulWidget {
  @override
  _IntroHomeState createState() => _IntroHomeState();
}

class _IntroHomeState extends State<IntroHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ainidiu'),
      ),
      body: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Page2()));
          },
          child: Center(child: Text('data'))),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Widget messageModel(String text, int op) {
    switch (status) {
      case 1:
        text = 'Seja bem vindo ao Ainidiu';
        break;
      case 2:
        text = 'Nós somo um um APP de ...';
        break;
      case 3:
        text = 'Aqui você poderá fazer isso e isso';
        break;
      case 4:
        text = 'Beleza?';
        break;
      case 5:
      text = 'Só Alegria';
        break;
      case 6:
        break;
      default:
    }

    if (op == 1) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                height: 72,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  text,
                  style: TextStyle(color: Colors.white),
                )),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 72,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(text),
              ),
              SizedBox(
                width: 15,
              ),
              CircleAvatar(
                radius: 36,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(100)),
            child: FlatButton(
              child: Text(
                'Vamos lá!',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  status++;
                  mensagens.last = messageModel('Vamos lá', 2);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> mensagens = new List<Widget>();
  int status = 0;
  bool slide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ainidiu'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  mensagens.clear();
                  status = 1;
                });
              })
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (slide) {
            if (details.delta.dx < 0) {
              if (true) {
                if (status == 4) {
                  setState(() {
                    status++;
                    mensagens.add(messageModel('$status', 2));
                    slide = false;
                    Future.delayed(Duration(milliseconds: 200)).then((value) {
                      setState(() {
                        slide = true;
                      });
                    });
                  });
                } else {
                  setState(() {
                    status++;
                    mensagens.add(messageModel('$status', 1));
                    slide = false;
                    Future.delayed(Duration(milliseconds: 200)).then((value) {
                      setState(() {
                        slide = true;
                      });
                    });
                  });
                }
              }
            } else {
              if (status > 0) {
                print(status);
                setState(() {
                  mensagens.removeAt(mensagens.length - 1);
                  status--;
                  slide = false;
                  Future.delayed(Duration(milliseconds: 200)).then((value) {
                    setState(() {
                      slide = true;
                    });
                  });
                });
              }
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mensagens.length,
                itemBuilder: (context, index) {
                  return mensagens[index];
                },
              ),
            ),
            Container(
              child: Text('Desliza para o lado ->'),
            )
          ],
        ),
      ),
    );
  }
}
