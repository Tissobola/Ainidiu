import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CadastroFirebaseProvider {
  FirebaseFirestore getConexao() {
    return FirebaseFirestore.instance;
  }

  var storage = FirebaseStorage.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<int> cadastro(
      token, email, senha, genero, imageURL, estado, cidade, nascimento) async {
    try {
      QuerySnapshot dados = await getConexao().collection('usuarios').get();

      QuerySnapshot test;
      int id;

      do {
        id = Random().nextInt(1000);

        test = await getConexao()
            .collection('usuarios')
            .where('id', isEqualTo: id)
            .get();
      } while (test.docs.isNotEmpty);

      for (var item in dados.docs) {
        if (email == item.data()['email']) {
          return 1;
        }
      }

      getConexao().collection('usuarios').doc().set({
        'apelido': 'Usuário $id',
        'email': email,
        'genero': genero,
        'senha': senha,
        'id': id,
        'ImageURL': imageURL,
        'token': token,
        'estado': estado,
        'cidade': cidade,
        'nascimento': nascimento
      });

      return 0;
    } catch (ex) {
      return null;
    }
  }

  Future<int> reCadastro(token, email, senha, genero, imageURL, String estado,
      String cidade, String nascimento) async {
    try {
      QuerySnapshot test;
      int id;

      do {
        id = Random().nextInt(1000);

        test = await getConexao()
            .collection('usuarios')
            .where('id', isEqualTo: id)
            .get();
      } while (test.docs.isNotEmpty);

      getConexao().collection('usuarios').doc().set({
        'apelido': 'Usuário $id',
        'email': email,
        'genero': genero,
        'senha': senha,
        'id': id,
        'ImageURL': imageURL,
        'token': '',
        'estado': estado,
        'cidade': cidade,
        'nascimento': nascimento
      });

      return 0;
    } catch (ex) {
      return null;
    }
  }

  Future<String> getToken() async {
    try {
      var token = await _firebaseMessaging.getToken();

      return token;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getURLSMan() async {
    try {
      List<String> urls = new List<String>();

      for (var i = 1; i <= 7; i++) {
        String aux = await storage
            .ref()
            .child('avatares/man/man ($i).png')
            .getDownloadURL();
        urls.add(aux);
      }

      return urls;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getURLSWoman() async {
    try {
      List<String> urls = new List<String>();

      for (var i = 1; i <= 6; i++) {
        String aux = await storage
            .ref()
            .child('avatares/woman/woman ($i).png')
            .getDownloadURL();
        urls.add(aux);
      }

      return urls;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getAllURLS() async {
    try {
      List<String> urls = new List<String>();

      for (var i = 1; i <= 7; i++) {
        String aux = await storage
            .ref()
            .child('avatares/man/man ($i).png')
            .getDownloadURL();
        urls.add(aux);
      }

      for (var i = 1; i <= 6; i++) {
        String aux = await storage
            .ref()
            .child('avatares/woman/woman ($i).png')
            .getDownloadURL();
        urls.add(aux);
      }

      return urls;
    } catch (e) {
      return null;
    }
  }
}
