import 'package:ainidiu/src/api/item.dart';
import 'dart:math';
import 'package:ainidiu/src/api/user.dart';
import 'package:ainidiu/src/components/conversas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FbRepository {
  FirebaseFirestore getConexao() {
    return FirebaseFirestore.instance;
  }

  String formatarHora(DateTime hora) {
    String horaFormatada;

    if (hora.hour < 10) {
      if (hora.minute < 10) {
        horaFormatada = '0${hora.hour}:0${hora.minute}';
      } else {
        horaFormatada = '0${hora.hour}:${hora.minute}';
      }
    } else if (hora.minute < 10) {
      horaFormatada = '${hora.hour}:0${hora.minute}';
    } else {
      horaFormatada = '${hora.hour}:${hora.minute}';
    }

    return horaFormatada;
  }

  Future<int> updateDados(User usuario, String option,
      {String senhaAntiga,
      String senhaNova,
      String email,
      String cidade,
      String nascimento,
      String genero}) async {
    QuerySnapshot userDoc = await getConexao()
        .collection('usuarios')
        .where('id', isEqualTo: usuario.id)
        .get();

    switch (option) {
      case 'cidade':
        getConexao()
            .collection('usuarios')
            .doc(userDoc.docs.last.id)
            .update({'cidade': cidade, 'token': ''});

        return 0;

        break;

      case 'nascimento':
        getConexao()
            .collection('usuarios')
            .doc(userDoc.docs.last.id)
            .update({'nascimento': nascimento, 'token': ''});

        return 0;

        break;

      case 'foto':
        print('Voce quer editar $option');
        break;

      case 'genero':
        print('Voce quer editar $option');
        break;

      case 'email':
        var emails = await getConexao()
            .collection('usuarios')
            .where('email', isEqualTo: email)
            .get();

        if (emails.docs.length > 0) {
          //Email já existente
          return 1;
        }

        getConexao()
            .collection('usuarios')
            .doc(userDoc.docs.last.id)
            .update({'email': email, 'token': ''});

        return 0;

        break;

      case 'senha':
        if (userDoc.docs[0].data()['senha'] == senhaAntiga) {
          getConexao()
              .collection('usuarios')
              .doc(userDoc.docs[0].id)
              .update({'senha': senhaNova});
          return 0;
        } else {
          //Senha antiga incorreta
          return 1;
        }

        break;

      default:
        return 1;
    }
  }

  Future<User> loginAuto() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user;

    if (preferences.getString('user') != null) {
      user = await carregarDadosDoUsuario(preferences.getString('user'));
    } else {
      return null;
    }

    return user;
  }

  criarChat(int myId, int outroId) async {
    if (!(myId == outroId)) {
      QuerySnapshot dados = await getConexao().collection('chat').get();

      var ok = true;

      for (var item in dados.docs) {
        if (item.id == '${myId}_$outroId' || item.id == '${outroId}_$myId') {
          ok = false;
        } else {}
      }
      if (ok) {
        getConexao().collection('chat').doc('${outroId}_$myId').set({
          'conversa': '',
          'data': Timestamp.now(),
          'ids': [myId, outroId],
          //ID de quem enviou a última mensagem
          'ultimaMensagemId': 0,
          'lidaPor': []
        });
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
    QuerySnapshot dados = await getConexao().collection('chat').get();
    List<Conversas> conversas = new List<Conversas>();

    for (var item in dados.docs) {
      var data = item.data();

      if (await teste(myId, item.id) != 1) {
        User outro = await teste(myId, item.id);

        try {
          DocumentSnapshot t = await getConexao()
              .collection('chat')
              .doc('${myId}_${outro.id}')
              .get();

          DateTime hora = t.data()['data'].toDate();

          Conversas aux = new Conversas(
              outro.apelido,
              t.data()['conversa'],
              outro.imageURL,
              '${hora.hour}:${hora.minute}',
              t.data()['ids'],
              t.data()['ultimaMensagemId'],
              t.data()['lidaPor']);
          conversas.add(aux);
        } catch (ex) {
          try {
            DocumentSnapshot t = await getConexao()
                .collection('chat')
                .doc('${outro.id}_$myId')
                .get();

            DateTime hora = t.data()['data'].toDate();

            Conversas aux = new Conversas(
                outro.apelido,
                t.data()['conversa'],
                outro.imageURL,
                formatarHora(hora),
                t.data()['ids'],
                t.data()['ultimaMensagemId'],
                t.data()['lidaPor']);

            conversas.add(aux);
          } catch (ex) {
            print(ex);
          }
        }
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
        .get();
    int id = dados.docs.length;

    getConexao()
        .collection('/chat/conversas/${primeiro}_$segundo')
        .doc('${id + 1}')
        .set({
      'env': myId,
      'texto': texto,
      'id': id + 1,
      'data': formatarHora(DateTime.now())
    });

    //Testa se o documento existe
    var test =
        await getConexao().collection('chat').doc('${primeiro}_$segundo').get();

    if (test.data() == null) {
      getConexao().collection('chat').doc('${segundo}_$primeiro').update({
        'conversa': texto,
        'data': Timestamp.now(),
        'ultimaMensagemId': myId,
        'lidaPor': [myId]
      });
    } else {
      getConexao().collection('chat').doc('${primeiro}_$segundo').update({
        'conversa': texto,
        'data': Timestamp.now(),
        'ultimaMensagemId': myId,
        'lidaPor': [myId]
      });
    }
  }

  filtro() async {
    QuerySnapshot dados = await getConexao().collection('blacklist').get();

    List aux = new List();

    for (var item in dados.docs) {
      aux = item.data()['blacklist'];
    }

    List<String> blacklist = new List<String>();

    aux.forEach((element) {
      blacklist.add(element);
    });

    return blacklist;
  }

  resetPosts(User usuario) async {
    QuerySnapshot dados = await getConexao().collection('postagens').get();

    //Deleta as postagens
    for (var item in dados.docs) {
      if (item.data()['postadoPorId'] == usuario.id) {
        getConexao()
            .collection('postagens')
            .doc('post${item.data()['id']}')
            .delete();
      }
    }

    //Deleta os chats
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
          await getConexao()
              .collection('chat')
              .doc('conversas')
              .collection(item.id)
              .doc(it.id)
              .delete();
        }
      }
    }

    //Fazendo uma cópia dos dados do usuário
    User userCopia = new User(
        usuario.token,
        usuario.imageURL,
        '',
        usuario.email,
        usuario.genero,
        usuario.id,
        usuario.senha,
        usuario.cidade,
        usuario.nascimento);

    //encontrando o usuário que queremos deletar
    var userWithId = await getConexao()
        .collection('usuarios')
        .where('id', isEqualTo: usuario.id)
        .get();

    //Recasdastrando a pesso com um apelido diferente
    await reCadastro(userCopia.token, userCopia.email, userCopia.senha,
        userCopia.genero, userCopia.imageURL);

    //Deletando conta antiga
    getConexao().collection('usuarios').doc(userWithId.docs[0].id).delete();
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
        dados['imageURL'],
        dados['apelido'],
        dados['email'],
        dados['genero'],
        dados['id'],
        dados['senha'],
        dados['cidade'],
        dados['nascimento']);

    return user;
  }

  escreverPostagens(DateTime data, imagemURL, parentId, postadoPorId,
      postadoPorNome, texto) async {
    QuerySnapshot dados = await getConexao().collection('postagens').get();

    int lastId = 0;

    for (var item in dados.docs) {
      if (item.data()['id'] > lastId) {
        lastId = item.data()['id'];
      }
    }
    getConexao().collection('postagens').doc('post${lastId + 1}').set({
      'dataHora': formatarHora(data),
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
        .get();

    var postagens = new List<ItemData>();

    for (var item in dados.docs) {
      if (item.data()['parentId'] == 0) {
        var post = item.data();

        List comentarios = post['comentarios'];

        ItemData aux = ItemData(
            post['id'],
            post['postadoPorId'],
            post['postadoPorNome'],
            post['imagemURL'],
            post['texto'],
            post['dataHora'],
            post['parentId'],
            comentarios);

        postagens.add(aux);
      }
    }

    return postagens;
  }

  carregarMinhasPostagens(authorId) async {
    QuerySnapshot dados = await getConexao().collection('postagens').get();

    var postagens = new List<ItemData>();

    for (var item in dados.docs) {
      if (item.data()['parentId'] == 0) {
        if (authorId == item.data()['postadoPorId']) {
          var post = item.data();
          List comentarios = post['comentarios'];
          ItemData aux = ItemData(
              post['id'],
              post['postadoPorId'],
              post['postadoPorNome'],
              post['imagemURL'],
              post['texto'],
              post['dataHora'],
              post['parentId'],
              comentarios);

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
    QuerySnapshot dados = await getConexao().collection('postagens').get();

    ItemData aux;

    for (var item in dados.docs) {
      if (item.data()['id'] == com) {
        var post = item.data();

        List coms = new List();
        coms = post['comentarios'];

        aux = ItemData(
            post['id'],
            post['postadoPorId'],
            post['postadoPorNome'],
            post['imagemURL'],
            post['texto'],
            post['dataHora'],
            post['parentId'],
            coms);

        for (int i = 0; i < coms.length; i++) {
          aux.addComentario(await carregarPost(coms[i]));
        }
      }
    }

    return aux;
  }

  carregarComentario(id) async {
    QuerySnapshot dados = await getConexao().collection('postagens').get();

    ItemData comentario;
    List<ItemData> aux = new List<ItemData>();

    for (var item in dados.docs) {
      if (id == item.data()['parentId']) {
        comentario = ItemData(
            item.data()['id'],
            item.data()['postadoPorId'],
            item.data()['postadoPorNome'],
            item.data()['imagemURL'],
            item.data()['texto'],
            item.data()['dataHora'],
            item.data()['parentId'],
            item.data()['comentarios']);
      }
      aux.add(comentario);
    }

    return aux;
  }

  Future<List<ItemData>> exibirComentarios(ItemData post) async {
    List<ItemData> coms = new List<ItemData>();

for (int i = 0; i < post.comentarios.length; i++) {
      var item = await getConexao()
          .collection('postagens')
          .doc('post${post.comentarios[i]}')
          .get();

      ItemData aux = new ItemData(
          item.data()['id'],
          item.data()['postadoPorId'],
          item.data()['postadoPorNome'],
          item.data()['imagemURL'],
          item.data()['texto'],
          item.data()['dataHora'],
          item.data()['parentId'],
          item.data()['comentarios']);

      coms.add(aux);
    }

    return coms;
  }

  escreverComentario(idPost, msg, User user) async {
    QuerySnapshot dados;

    dados = await getConexao().collection('postagens').get();

    int lastId = 0;

    for (var item in dados.docs) {
      if (item.data()['id'] > lastId) {
        lastId = item.data()['id'];
      }
    }

    lastId++;

    getConexao().collection('postagens').doc('post$lastId').set({
      'dataHora': formatarHora(DateTime.now()),
      'id': lastId,
      'imagemURL': user.imageURL,
      'parentId': idPost,
      'postadoPorId': user.id,
      'postadoPorNome': user.apelido,
      'texto': msg,
      'comentarios': []
    });

    dados = await getConexao().collection('postagens').get();

    List aux = new List();
    List comentarios = new List();

    for (var item in dados.docs) {
      if (idPost == item.data()['id']) {
        aux = item.data()['comentarios'];

        for (int i = 0; i < aux.length; i++) {
          comentarios.add(aux[i]);
        }
        comentarios.add(lastId);
        getConexao().collection('postagens').doc('post$idPost').set({
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

  Future<int> cadastro(
      token, email, senha, genero, imageURL, cidade, nascimento) async {
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
      'cidade': cidade,
      'nascimento': nascimento
    });

    return 0;
  }

  Future<int> reCadastro(token, email, senha, genero, imageURL) async {
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
      'token': ''
    });

    return 0;
  }

  Future acharPost(int idDoPost) async {
    String nomeDoPost;
    QuerySnapshot dados = await getConexao().collection('postagens').get();

    for (var item in dados.docs) {
      var data = item.data();
      if (data['id'] == idDoPost) {
        nomeDoPost = item.id;
      }
    }

    return nomeDoPost;
  }

  void denunciar(int idDoPost, String texto, User autor) async {
    QuerySnapshot dados = await getConexao().collection('postagens').get();

    for (var item in dados.docs) {
      var data = item.data();
      if (data['id'] == idDoPost) {
        enviarDenuncia(idDoPost, data, texto, autor);

        if (data['parentId'] != 0) {
          var pai = await getConexao()
              .collection('postagens')
              .doc('post${data['parentId']}')
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
              .doc('post${data['parentId']}')
              .update({'comentarios': aux2});
        }
      }
    }
  }

  void enviarDenuncia(
      int idDoPost, Map<String, dynamic> data, texto, User autor) async {
    getConexao().collection('denuncias').doc('denuncia$idDoPost').set({
      'dataHora': formatarHora(DateTime.now()),
      'id': idDoPost,
      'parentId': data['id'],
      'textoDaPostagem': data['texto'],
      'motivoDaDenuncia': texto,
      'ID do autor da denuncia': autor.id,
      'Apelido do autor da denuncia': autor.apelido
    });

    getConexao().collection('postagens').doc('post$idDoPost').delete();
  }
}
