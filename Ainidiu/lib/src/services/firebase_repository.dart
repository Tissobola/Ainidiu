import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/page/escrever_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FbRepository {
  Firestore getConexao() {
    return Firestore.instance;
  }

  Future<User> carregarDadosDoUsuario(user) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    User usuario;

    //[0] Senha
    //[1] Apelido
    //[2] Genero
    //[3] Foto
    //[4] id
    //[5] Email

    for (var item in dados.documents) {
      var lista = item.data.values.toList();

      if (user == item.data.values.toList()[1]) {
        //print(item.data.values.toList()[5]);
        usuario = new User(
            lista[3], lista[1], lista[5], lista[2], lista[4], lista[0]);
      }
    }

    return usuario;
  }

  escreverPostagens(DateTime data, imagemURL, int id, parentId, portadoPorId,
      postadoPorNome, texto) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    var hora = '${data.hour}:${data.minute}';

    getConexao()
        .collection('postagens')
        .document('post${dados.documents.length + 1}')
        .setData({
      'dataHora': hora,
      'id': id,
      'imagemURL': imagemURL,
      'parentId': parentId,
      'portadoPorId': portadoPorId,
      'postadoPorNome': postadoPorNome,
      'texto': texto
    });
  }

  Future<List<ItemData>> carregarPostagens() async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    var postagens = new List<ItemData>();

    for (var item in dados.documents) {
      //print('a = ${item.data.values.toList()[6]}');
      var lista = item.data.values.toList();

      //[0] postadoPorNome
      //[1] texto
      //[2] id
      //[3] portadoPorId
      //[4] dataHora
      //[5] imagemURL
      //[6] parentId

      postagens.add(ItemData(
          lista[2], lista[3], lista[0], lista[5], lista[1], lista[4], lista[6]));
  
    }

    return postagens;
  }

  Future<String> login(email, senha) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    for (var item in dados.documents) {
      //print(item.data.values.toList()[5]);

      //[0] Senha
      //[1] Apelido
      //[2] Genero
      //[3] Id
      //[4] Foto
      //[5] Email

      //print(email);

      if (email == item.data.values.toList()[5]) {
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
      if (email == item.data.values.toList()[5]) {
        return 1;
      }
    }

    getConexao()
        .collection('usuarios')
        .document('user${dados.documents.length + 1}')
        .setData({
      'apelido': 'Usuário ${dados.documents.length + 1}',
      'email': email,
      'genero': genero,
      'senha': senha,
      'id': dados.documents.length + 1,
      'ImageURL':
          'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png'
    });

    return 0;
  }
}
