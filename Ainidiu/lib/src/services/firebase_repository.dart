import 'package:cloud_firestore/cloud_firestore.dart';

class FbRepository{

  Firestore getConexao() {
    return Firestore.instance;
  }
}