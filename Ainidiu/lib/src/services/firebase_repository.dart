import 'package:ainidiu/src/api/item.dart';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/conversas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FbRepository {
  FirebaseFirestore getConexao() {
    return Firestore.instance;
  }

  Future<User> loginAuto() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user;
    print('get = ${preferences.getString('user')}');

    if (preferences.getString('user') != null) {
      user = await carregarDadosDoUsuario(preferences.getString('user'));
    } else {
      return null;
    }

    return user;
  }

  criarChat(int myId, int outroId) async {
    if (!(myId == outroId)) {
      print('oi');
      QuerySnapshot dados =
          await getConexao().collection('chat').getDocuments();

      var ok = true;

      for (var item in dados.documents) {
        if (item.documentID == '${myId}_$outroId' ||
            item.documentID == '${outroId}_$myId') {
          ok = false;
        } else {}
      }
      if (ok) {
        getConexao()
            .collection('chat')
            .document('${myId}_$outroId')
            .setData({'conversa': 'Última Mensagem'});
      }
    }
  }

  Future teste(int myId, String con) async {
    String aux = '';
    String aux2 = '';
    bool jaPassou = false;
    for (int i = 0; i < con.length; i++) {
      if (con[i] == '_') {
        jaPassou = true;
      } else {
        if (!jaPassou) {
          aux += con[i];
        } else {
          aux2 += con[i];
        }
      }
    }

    if (myId.toString() == aux) {
      User user = await carregarDadosDoUsuario("Usuário $aux2");

      return user;
    } else {
      if (myId.toString() == aux2) {
        User user = await carregarDadosDoUsuario("Usuário $aux");
        return user;
      }

      return 1;
    }
  }

  minhasConversas(myId) async {
    QuerySnapshot dados = await getConexao().collection('chat').getDocuments();
    List<Conversas> conversas = new List<Conversas>();

    for (var item in dados.documents) {
      var data = item.data();

      if (await teste(myId, item.documentID) != 1) {
        User outro = await teste(myId, item.documentID);
        print(outro);
        Conversas aux =
            new Conversas(outro.apelido, data['conversa'], data['foto']);
        conversas.add(aux);
      }
    }

    return conversas;
  }

  mandarMensagem(texto, userid, myId) async {
    int primeiro = userid;
    int segundo = myId;
    if (userid > myId) {
      primeiro = myId;
      segundo = userid;
    }

    QuerySnapshot dados = await getConexao()
        .collection('/chat/conversas/${primeiro}_$segundo')
        .getDocuments();
    int id = dados.documents.length;

    getConexao()
        .collection('/chat/conversas/${primeiro}_$segundo')
        .document('${id + 1}')
        .setData({'env': myId, 'texto': texto, 'id': id + 1});
  }

  filtro() async {
    QuerySnapshot dados =
        await getConexao().collection('blacklist').getDocuments();

    List aux = new List();

    for (var item in dados.documents) {
      aux = item.data()['blacklist'];
    }

    List<String> blacklist = new List<String>();

    aux.forEach((element) {
      blacklist.add(element);
    });

    print(blacklist);

    return blacklist;
  }

  resetPosts(User usuario) async {
    await getConexao().collection('usuarios').doc('user${usuario.id}').update({
      'apelido': '',
      'email': '',
      'genero': '',
      'senha': '',
      'id': '',
      'ImageURL': ''
    });

    QuerySnapshot dados = await getConexao().collection('postagens').get();

    for (var item in dados.docs) {
      if (item.data()['postadoPorId'] == usuario.id) {
        getConexao()
            .collection('postagens')
            .doc('post${item.data()['id']}')
            .delete();
      }
    }

    dados = await getConexao().collection('chat').get();

    for (var item in dados.docs) {
      if (item.id.contains(usuario.id.toString())) {
        await getConexao().collection('chat').doc(item.id).delete();

        var data = await getConexao()
            .collection('chat')
            .doc('conversas')
            .collection(item.id)
            .get();

        for (var it in data.docs) {
          print('a = ${it.id}');
          await getConexao()
              .collection('chat')
              .doc('conversas')
              .collection(item.id)
              .doc(it.id)
              .delete();
        }
      }
    }

    await cadastro(
        usuario.email, usuario.senha, usuario.genero, usuario.imageURL);
  }

  Future<User> carregarDadosDoUsuario(user) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    User aux;

    print('apelid: $user');

    for (var item in dados.documents) {
      var data = item.data();

      if (user == data['apelido']) {
        print('test = ${data['id']}');
        User usuario = new User(data['ImageURL'], data['apelido'],
            data['email'], data['genero'], data['id'], data['senha']);
        return usuario;
      }
    }

    return aux;
  }

  escreverPostagens(DateTime data, imagemURL, parentId, postadoPorId,
      postadoPorNome, texto) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    var hora = '${data.hour}:${data.minute}';
    int lastId = 0;

    for (var item in dados.documents) {
      if (item.data()['id'] > lastId) {
        lastId = item.data()['id'];
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
    QuerySnapshot dados = await getConexao()
        .collection('postagens')
        .orderBy('id', descending: true)
        .getDocuments();

    var postagens = new List<ItemData>();

    for (var item in dados.documents) {
      if (item.data()['parentId'] == 0) {
        var post = item.data();
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

  carregarMinhasPostagens(authorId) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    var postagens = new List<ItemData>();

    for (var item in dados.documents) {
      var data = item.data();

      if (item.data()['parentId'] == 0) {
        if (authorId == item.data()['postadoPorId']) {
          var post = item.data();
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
    }
    return postagens;
  }

  carregarPost(com) async {
    QuerySnapshot dados =
        await getConexao().collection('postagens').getDocuments();

    ItemData aux;

    for (var item in dados.documents) {
      if (item.data()['id'] == com) {
        var post = item.data();
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
      if (id == item.data()['parentId']) {
        comentario = ItemData(
          item.data()['id'],
          item.data()['postadoPorId'],
          item.data()['postadoPorNome'],
          item.data()['imagemURL'],
          item.data()['texto'],
          item.data()['dataHora'],
          item.data()['parentId'],
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
      if (item.data()['id'] > lastId) {
        lastId = item.data()['id'];
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
      if (idPost == item.data()['id']) {
        aux = item.data()['comentarios'];

        for (int i = 0; i < aux.length; i++) {
          comentarios.add(aux[i]);
        }
        comentarios.add(lastId);
        getConexao().collection('postagens').document('post$idPost').setData({
          'dataHora': item.data()['dataHora'],
          'id': item.data()['id'],
          'imagemURL': item.data()['imagemURL'],
          'parentId': item.data()['parentId'],
          'postadoPorId': item.data()['postadoPorId'],
          'postadoPorNome': item.data()['postadoPorNome'],
          'texto': item.data()['texto'],
          'comentarios': comentarios
        });
      }
    }
  }

  Future<String> login(email, senha) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    for (var item in dados.documents) {
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

  Future<int> cadastro(email, senha, genero, imageURL) async {
    QuerySnapshot dados =
        await getConexao().collection('usuarios').getDocuments();

    for (var item in dados.documents) {
      if (email == item.data()['email']) {
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
      var data = item.data();
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
      var data = item.data();
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

          aux = pai.data()['comentarios'];
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
