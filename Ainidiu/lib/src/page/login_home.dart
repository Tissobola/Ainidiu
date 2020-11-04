import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'login_cadastro.dart';
import 'login_login.dart';

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget buildLogo() {
    return Container(
 
      width: 100,
      height:100,
      child: Image.asset("assets/icon/icon.png",
     
     
      )
    );
  }

  Widget buildText() {
    return Column(
  
    crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        buildLogo(),
        SizedBox(
          height: 260,
        ),
        Text(
          'SEJA\nBEM-VINDO AO\nAINIDIU',
          style: TextStyle(fontSize: 35, fontFamily: 'Montserrat'),
        )
      ],
    );
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
          'SIGN IN',
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
                width: 110,
                child: Text(
                  'Cadastre-se',
                  style: estilo,
                )))
      ],
    );
  }

  Widget buildTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[buildButton(), buildCadastro()],
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
              Icon(Icons.signal_wifi_off, size: 40,),
              SizedBox(height: 20,),
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
                children: <Widget>[buildText(), buildTest()],
              ),
            ],
          )),
    );
  }
}
