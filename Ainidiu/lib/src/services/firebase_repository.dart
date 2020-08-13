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
      var it = item.data;

      if (user == it['apelido']) {
        //print(item.data.values.toList()[5]);
        usuario = new User(it['ImageURL'], it['apelido'], it['email'],
            it['genero'], it['id'], it['senha']);
      }
    }

    return usuario;
  }

  escreverPostagens(DateTime data, imagemURL, parentId, postadoPorId,
      postadoPorNome, texto) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    var hora = '${data.hour}:${data.minute}';
    int lastId = 0;

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
      'texto': texto,
      'comentarios': []
    });
  }

  Future<List<ItemData>> carregarPostagens() async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    var postagens = new List<ItemData>();

    for (var item in dados.documents) {
      //print('a = ${item.data.values.toList()[6]}');
      var post = item.data;
      ItemData aux = ItemData(
        post['id'],
        post['postadoPorId'],
        post['postadoPorNome'],
        post['imagemURL'],
        post['texto'],
        post['dataHora'],
        post['parentId'],
      );

      List comentarios = post['comentarios'];

      for (int i = 0; i < comentarios.length; i++) {
        aux.addComentario(await carregarComentario(comentarios[i]));
      }

      postagens.add(aux);
    }

    return postagens;
  }

  carregarComentario(id) async {
    QuerySnapshot dados =
        await getConexao().collection('comentarios').getDocuments();

    ItemData comentario;

    for (var item in dados.documents) {
      if (id == item.data['id']) {
        comentario = ItemData(
          item.data['id'],
          item.data['postadoPorId'],
          item.data['postadoPorNome'],
          item.data['imagemURL'],
          item.data['texto'],
          item.data['dataHora'],
          item.data['parentId'],
        );
      }
    }

    return comentario;
  }

  escreverComentario(idPost, msg, User user) async {
    QuerySnapshot dados;

    dados = await getConexao().collection('comentarios').getDocuments();

    print('tamanho = ${dados.documents.length}');

    int id = dados.documents.length + 1;
    var hora = '${DateTime.now().hour}:${DateTime.now().minute}';

    getConexao().collection('comentarios').document('comentario$id').setData({
      'dataHora': hora,
      'id': id,
      'imagemURL': user.imageURL,
      'parentId': idPost,
      'postadoPorId': user.id,
      'postadoPorNome': user.apelido,
      'texto': msg,
      'comentarios': []
    });

    dados = await getConexao().collection('postagens').getDocuments();

    List aux = new List();
    List comentarios = new List();

    for (var item in dados.documents) {
      if (idPost == item.data['id']) {
        aux = item.data['comentarios'];

        for (int i = 0; i < aux.length; i++) {
          comentarios.add(aux[i]);
        }
        comentarios.add(id);
        getConexao()
            .collection('postagens')
            .document('post$idPost')
            .setData(
              {
      'dataHora': item.data['dataHora'],
      'id': item.data['id'],
      'imagemURL': item.data['imagemURL'],
      'parentId': item.data['parentId'],
      'postadoPorId': item.data['postadoPorId'],
      'postadoPorNome': item.data['postadoPorNome'],
      'texto': item.data['texto'],
      'comentarios': comentarios
    }
            );
      }
    }

    print('aux = $aux');
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

  Future acharPost(int idDoPost) async {
    print(idDoPost);
    String nomeDoPost;
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    for (var item in dados.documents) {
      var lista = item.data.values.toList();
      if (lista[3] == idDoPost) {
        nomeDoPost = item.documentID;
        print('Did = ${item.documentID}');
      }
    }

    return nomeDoPost;
  }

  void denunciar(int idDoPost, String texto) async {
    print(idDoPost);
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    for (var item in dados.documents) {
      var lista = item.data.values.toList();
      if (lista[3] == idDoPost) {
        getConexao().collection('postagens').document(item.documentID).delete();

        enviarDenuncia(idDoPost, lista, texto);
      }
    }
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
      'motivoDaDenuncia': texto
    });
  }
}
