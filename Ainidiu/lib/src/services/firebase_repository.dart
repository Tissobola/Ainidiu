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

  escreverPostagens(DateTime data, imagemURL, parentId, postadoPorId,
      postadoPorNome, texto) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    var hora = '${data.hour}:${data.minute}';
    int lastId;

    for (var item in dados.documents) {
      lastId = item.data.values.toList()[3];
    }

    getConexao().collection('postagens').document('post${lastId + 1}').setData({
      'dataHora': hora,
      'id': lastId + 1,
      'imagemURL': imagemURL,
      'parentId': parentId,
      'postadoPorId': postadoPorId,
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
      //[2] postadoPorId
      //[3] id
      //[4] dataHora
      //[5] imagemURL
      //[6] parentId

      postagens.add(ItemData(lista[3], lista[2], lista[0], lista[5], lista[1],
          lista[4], lista[6]));
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

  Future<int> cadastro(email, senha, genero, imageURL) async {
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
      'ImageURL': imageURL
    });

    return 0;
  }

  Future denunciar(int idDoPost, String texto) async {
    print(idDoPost);
    String nomeDoPost;
    print('rodou');
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    for (var item in dados.documents) {
      var lista = item.data.values.toList();
      if (lista[3] == idDoPost) {
        print('achado');
        nomeDoPost = item.documentID;
        print('Did = ${item.documentID}');
        getConexao().collection('postagens').document(item.documentID).delete();

        enviarDenuncia(idDoPost, lista, texto);
      }
    }

    return nomeDoPost;
  }

  void enviarDenuncia(int idDoPost, List lista, texto) async {
    print('ta aqui');
    QuerySnapshot dados =
        await getConexao().collection('denuncias').getDocuments();

    for (var item in dados.documents) {
      for (int i = 0; i < item.data.values.toList().length; i++) {
        print('[$i] = ${item.data.values.toList()[i]}');
      }
    }

    getConexao().collection('denuncias').document('denuncia$idDoPost').setData({
      'dataHora': lista[4],
      'id': idDoPost,
      'parentId': lista[6],
      'postadoPorId': lista[2],
      'postadoPorNome': lista[0],
      'textoDaPostagem': lista[1],
      'textoDaDenuncia': texto
    });
  }
}
