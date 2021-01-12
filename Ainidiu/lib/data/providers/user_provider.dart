import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ainidiu/data/models/user.dart';
class UserProvider {
  getConexao() {
    return FirebaseFirestore.instance;
  }

  Future<User> carregarDadosDoUsuario(user) async {
    QuerySnapshot dados = await getConexao().collection('usuarios').get();

    User aux;

    for (var item in dados.docs) {
      var data = item.data();

      if (user == data['apelido']) {
        User usuario = new User(
            data['token'],
            data['ImageURL'],
            data['apelido'],
            data['email'],
            data['genero'],
            data['id'],
            data['senha'],
            data['estado'],
            data['cidade'],
            data['nascimento']);
        return usuario;
      }
    }

    return aux;
  }

  Future<User> carregarDadosPorId(int id) async {
    QuerySnapshot userDoc = await getConexao()
        .collection('usuarios')
        .where('id', isEqualTo: id)
        .get();
    Map<String, dynamic> dados = userDoc.docs.last.data();

    User user = new User(
        dados['token'],
        dados['ImageURL'],
        dados['apelido'],
        dados['email'],
        dados['genero'],
        dados['id'],
        dados['senha'],
        dados['estado'],
        dados['cidade'],
        dados['nascimento']);

    return user;
  }
}
