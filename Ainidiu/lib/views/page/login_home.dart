import 'dart:async';

import 'package:ainidiu/controllers/login_home_controller.dart';
import 'package:ainidiu/views/components/flat_button_ext/flat_button_ext1.dart';
import 'package:ainidiu/views/components/logo/logo.dart';
import 'package:ainidiu/views/components/raisedbutton_ext/raisedbutton_ext1.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'login_cadastro.dart';
import 'login_login.dart';

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  final _controller = LoginHomeController();
  Logo logo = Logo();

  String _connection = "";
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.mobile) {
      updateText("3G/4G");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      String wifiName = await _connectivity.getWifiName();
      String wifiSsid = await _connectivity.getWifiBSSID();
      String wifiIp = await _connectivity.getWifiIP();
      updateText("Wi-Fi\n$wifiName\n$wifiSsid\n$wifiIp");
    } else {
      updateText("Não Conectado!");
    }
  }

  void updateText(String texto) {
    setState(() {
      _connection = texto;
    });
  }

  double getScreenHeight(
      BuildContext context, double divider, double multiplier) {
    return multiplier * MediaQuery.of(context).size.height / divider;
  }

  double getScreenWidth(
      BuildContext context, double divider, double multiplier) {
    return multiplier * MediaQuery.of(context).size.width / divider;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget buildButton() {
    return FlatButton(
      onPressed: () {
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      color: Colors.blue,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 25, bottom: 25, left: 90, right: 90),
        child: Text(
          'LOGIN',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.blue)),
    );
  }

  Widget buildCadastro() {
    var estilo = TextStyle(fontSize: 18, fontWeight: FontWeight.normal);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => Cadastro()));
            },
            child: Container(
                child: Text(
              'Cadastre-se',
              style: estilo,
            )))
      ],
    );
  }

  

  @override
  Widget build(BuildContext context) {
    if (_connection == "Não Conectado!") {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_wifi_off,
                size: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Text('Sem conexão com a internet')
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //Logo e mensagem inicial
                  _controller.buildText(context),

                  //Botões
                  _controller.buttons(context)
                ],
              ),
            ],
          )),
    );
  }
}
