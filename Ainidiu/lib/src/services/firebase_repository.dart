import 'dart:math';

import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FbRepository {
  Firestore getConexao() {
    return Firestore.instance;
  }

  mandarMensagem(texto) async {
    QuerySnapshot dados = await getConexao().collection('chat').getDocuments();
    int id = dados.documents.length;
    int env;
    if (id % 2 == 0) {
      env = 0;
    } else {
      env = 1;
    }

    getConexao()
        .collection('chat')
        .document('${id + 1}')
        .setData({'env': env, 'texto': texto, 'id': id + 1});
  }

  filtro() async {
    QuerySnapshot dados =
        await getConexao().collection('blacklist').getDocuments();

    List aux = new List();

    for (var item in dados.documents) {
      aux = item.data['blacklist'];
    }

    List<String> blacklist = new List<String>();

    aux.forEach((element) {
      blacklist.add(element);
    });

    print(blacklist);

    return blacklist;
  }

  resetPosts() async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    for (var item in dados.documents) {
      await getConexao()
          .collection('postagens')
          .document('${item.documentID}')
          .delete();
    }
  }

  Future<User> carregarDadosDoUsuario(user) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    User usuario;

    for (var item in dados.documents) {
      var data = item.data;

      if (user == data['apelido']) {
        //print(dataem.data.values.toList()[5]);
        usuario = new User(data['ImageURL'], data['apelido'], data['email'],
            data['genero'], data['id'], data['senha']);
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
      if (item.data['id'] > lastId) {
        lastId = item.data['id'];
      }
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
      if (item.data['parentId'] == 0) {
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
          aux.addComentario(await carregarPost(comentarios[i]));
        }

        postagens.add(aux);
      }
    }

    return postagens;
  }

  carregarPost(com) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    ItemData aux;

    for (var item in dados.documents) {
      if (item.data['id'] == com) {
        var post = item.data;
        aux = ItemData(
          post['id'],
          post['postadoPorId'],
          post['postadoPorNome'],
          post['imagemURL'],
          post['texto'],
          post['dataHora'],
          post['parentId'],
        );

        List coms = new List();
        coms = post['comentarios'];

        for (int i = 0; i < coms.length; i++) {
          aux.addComentario(await carregarPost(coms[i]));
        }
      }
    }

    return aux;
  }

  carregarComentario(id) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    ItemData comentario;
    List<ItemData> aux = new List<ItemData>();

    for (var item in dados.documents) {
      if (id == item.data['parentId']) {
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
      aux.add(comentario);
    }

    return aux;
  }

  escreverComentario(idPost, msg, User user) async {
    QuerySnapshot dados;

    dados = await getConexao().collection('postagens').getDocuments();

    int lastId = 0;

    for (var item in dados.documents) {
      if (item.data['id'] > lastId) {
        lastId = item.data['id'];
      }
    }

    lastId++;

    var hora = '${DateTime.now().hour}:${DateTime.now().minute}';

    getConexao().collection('postagens').document('post$lastId').setData({
      'dataHora': hora,
      'id': lastId,
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
        comentarios.add(lastId);
        getConexao().collection('postagens').document('post$idPost').setData({
          'dataHora': item.data['dataHora'],
          'id': item.data['id'],
          'imagemURL': item.data['imagemURL'],
          'parentId': item.data['parentId'],
          'postadoPorId': item.data['postadoPorId'],
          'postadoPorNome': item.data['postadoPorNome'],
          'texto': item.data['texto'],
          'comentarios': comentarios
        });
      }
    }
  }

  Future<String> login(email, senha) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    for (var item in dados.documents) {
      if (email == item.data['email']) {
        if (senha == item.data['senha']) {
          //dados corretos
          return item.data['apelido'];
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
      if (email == item.data['email']) {
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
    String nomeDoPost;
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    for (var item in dados.documents) {
      var data = item.data;
      if (data['id'] == idDoPost) {
        nomeDoPost = item.documentID;
      }
    }

    return nomeDoPost;
  }

  void denunciar(int idDoPost, String texto, User autor) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    for (var item in dados.documents) {
      var data = item.data;
      if (data['id'] == idDoPost) {
        enviarDenuncia(idDoPost, data, texto, autor);

        if (data['parentId'] != 0) {
          var pai = await getConexao()
              .collection('postagens')
              .document('post${data['parentId']}')
              .snapshots()
              .first;

          List aux = new List();
          List aux2 = new List();

          aux = pai.data['comentarios'];
          for (int i = 0; i < aux.length; i++) {
            if (aux[i] != idDoPost) {
              aux2.add(aux[i]);
            }
          }

          getConexao()
              .collection('postagens')
              .document('post${data['parentId']}')
              .updateData({'comentarios': aux2});
        }
      }
    }
  }

  void enviarDenuncia(
      int idDoPost, Map<String, dynamic> data, texto, User autor) async {
    print('object');

    String time = '${DateTime.now().hour}:${DateTime.now().minute}';

    getConexao().collection('denuncias').document('denuncia$idDoPost').setData({
      'dataHora': time,
      'id': idDoPost,
      'parentId': data['id'],
      'textoDaPostagem': data['texto'],
      'motivoDaDenuncia': texto,
      'ID do autor da denuncia': autor.id,
      'Apelido do autor da denuncia': autor.apelido
    });

    getConexao().collection('postagens').document('post$idDoPost').delete();
    print('ok');
  }
}
