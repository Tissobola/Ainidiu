import 'package:ainidiu/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ainidiu/data/providers/user_provider.dart';

class LoginFirebaseProvider {
  final userProvider = UserProvider();

  FirebaseFirestore getConexao() {
    return FirebaseFirestore.instance;
  }

  Future<String> getUserToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    var token = await _firebaseMessaging.getToken();

    return token;
  }

  Future<void> registrarToken(String token, int userId) async {
    QuerySnapshot userDoc = await getConexao()
        .collection('usuarios')
        .where('id', isEqualTo: userId)
        .get();

    await getConexao()
        .collection('usuarios')
        .doc(userDoc.docs[0].id)
        .update({'token': token});
  }

  Future<User> loginAuto() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user;

    if (preferences.getString('user') != null) {
      user = await userProvider
          .carregarDadosDoUsuario(preferences.getString('user'));
    } else {
      return null;
    }

    return user;
  }

  Future<String> login(email, senha) async {
    QuerySnapshot dados = await getConexao().collection('usuarios').get();

    for (var item in dados.docs) {
      if (email == item.data()['email']) {
        if (senha == item.data()['senha']) {
          //dados corretos
          return item.data()['apelido'];
        } else {
          //senha incorreta
          return '2';
        }
      }
    }
    //email não registrado
    return '1';
  }
}
