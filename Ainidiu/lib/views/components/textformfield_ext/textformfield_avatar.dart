import 'package:ainidiu/data/repositories/cadastro_repository.dart';
import 'package:ainidiu/views/components/responsividade/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarFormField extends StatefulWidget {
  String _avatar;
  BuildContext _context;
  String _currGenero;
  List<String> _urls = new List<String>();
  List<String> _urlsMan = new List<String>();
  List<String> _urlsWoman = new List<String>();

  AvatarFormField(
      {String avatar, context, urls, urlsMan, urlsWoman, currGenero}) {
    this._avatar = avatar;
    this._context = context;
    this._urls = urls;
    this._urlsMan = urlsMan;
    this._urlsWoman = urlsWoman;
    this._currGenero = currGenero;
  }

  @override
  _AvatarFormFieldState createState() => _AvatarFormFieldState(
      avatar: _avatar,
      context: _context,
      urls: _urls,
      urlsMan: _urlsMan,
      urlsWoman: _urlsWoman,
      currGenero: _currGenero);
}

class _AvatarFormFieldState extends State<AvatarFormField> {
  CadastroRepository cadastroRepository = CadastroRepository();

  String _avatar;
  BuildContext _context;
  String _currGenero;
  List<String> _urls = new List<String>();
  List<String> _urlsMan = new List<String>();
  List<String> _urlsWoman = new List<String>();

  _AvatarFormFieldState(
      {String avatar, context, urls, urlsMan, urlsWoman, currGenero}) {
    this._avatar = avatar;
    this._context = context;
    this._urls = urls;
    this._urlsMan = urlsMan;
    this._urlsWoman = urlsWoman;
    this._currGenero = currGenero;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              Text('Avatar'),
              FlatButton(
                child: Text('Selecionar Foto'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FutureBuilder(
                          future: getUrl(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Carregando Imagens'),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CircularProgressIndicator()
                                  ],
                                ),
                              );
                            } else {
                              return AlertDialog(
                                elevation: 5,
                                content: escolherFoto(),
                              );
                            }
                          },
                        );
                      });
                },
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(_avatar),
              )
            ],
          ),
        ),
      ),
    );
  }

  getUrl() async {
    _urls = await cadastroRepository.getAllURLS();
    _urlsMan = await cadastroRepository.getURLSMan();
    _urlsWoman = await cadastroRepository.getURLSWoman();

    return _urls;
  }

  Widget escolherFoto() {
    if (_currGenero == "Feminino") {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                exibirFoto(_urlsWoman[0]),
                exibirFoto(_urlsWoman[1]),
                exibirFoto(_urlsWoman[2]),
              ],
            ),
            Row(
              children: [
                exibirFoto(_urlsWoman[3]),
                exibirFoto(_urlsWoman[4]),
                exibirFoto(_urlsWoman[5]),
              ],
            ),
          ],
        ),
      );
    } else if (_currGenero == "Masculino") {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              exibirFoto(_urlsMan[0]),
              exibirFoto(_urlsMan[1]),
              exibirFoto(_urlsMan[2]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urlsMan[3]),
              exibirFoto(_urlsMan[4]),
              exibirFoto(_urlsMan[5]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urlsMan[6]),
            ],
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              exibirFoto(_urls[0]),
              exibirFoto(_urls[1]),
              exibirFoto(_urls[2]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urls[3]),
              exibirFoto(_urls[4]),
              exibirFoto(_urls[5]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urls[6]),
              exibirFoto(_urls[7]),
              exibirFoto(_urls[8]),
            ],
          ),
          Row(
            children: [
              exibirFoto(_urls[9]),
              exibirFoto(_urls[10]),
              exibirFoto(_urls[11]),
            ],
          ),
        ],
      );
    }
  }

  Widget exibirFoto(url) {
    return FlatButton(
      onPressed: () {
        setState(() {
          _avatar = url;
        });
        Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: Screen().getScreenHeight(context, 100, 3),
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}
