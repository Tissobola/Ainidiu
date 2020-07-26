import 'package:cloud_firestore/cloud_firestore.dart';

class FbRepository {
  Firestore getConexao() {
    return Firestore.instance;
  }

  void inserir_documento() {
    getConexao()
        .collection('mensagens')
        .document('msg1')
        .setData({'de': 'Cláudio', 'text': 'Será que vai dar certo?'});
  }

  Future<String> login(email, senha) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    for (var item in dados.documents) {
      //print(item.data.values.toList()[1]);
      //print(email);

      if (email == item.data.values.toList()[3]) {
        if (item.data.values.toList()[0] == senha) {
          //dados corretos
          return item.data.values.toList()[1];
        } else {
          //senha incorreta
          return '2';
        }
      }
    }
    //email não registrado
    return '1';
  }

  Future<int> cadastro(email, senha, genero) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    for (var item in dados.documents) {
      if (email == item.data.values.toList()[3]) {
        return 1;
      }
    }

    getConexao()
        .collection('usuarios')
        .document('user${dados.documents.length + 1}')
        .setData({'apelido':'Usuário ${dados.documents.length + 1}' ,'email': email, 'genero': genero, 'senha': senha});

    return 0;
  }

}
