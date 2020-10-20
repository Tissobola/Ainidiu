///Classe que represenda as informações a serem apresentadas nos cards
class ItemData {
  ///Id da postagem pai, só deve ser difiente de zero, se for comentario
  ///aí nesse campo vai o Id da pastagem a qual pertence o comentário
  int parentId;

  ///Id da postagem
  int id;

  ///Nome ou apelido de quem postou
  String postadoPorNome;

  ///Id do usuário da postagem
  int postadoPorId;

  ///URL da foto da pessoa
  ///Exmeplo: https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png
  String imagemURL;

  ///Texto da postagem
  String texto;

  ///Data e hora da postagem
  DateTime dataHora;
  String data;

  ///Comentarios que essa postagem possui
  List<ItemData> _comentarios;
  List comentarios;

  ///Método construtor
  ItemData(this.id, this.postadoPorId, this.postadoPorNome, this.imagemURL,
      this.texto, this.data, this.parentId, this.comentarios);

  ///Adicionar um comentario
  void addComentario(ItemData comentario) {
    if (this._comentarios == null) this._comentarios = new List<ItemData>();

    this._comentarios.add(comentario);
  }

  ///Adicicionar uma lista de comentários
  void addComentarios(List<ItemData> comentarios) {
    if (this._comentarios == null) this._comentarios = new List<ItemData>();

    this._comentarios.addAll(comentarios);
  }

  /// Retorna a lista de comentários
  List getComentarios() {
    if (this.comentarios == null) this.comentarios = new List();

    return this.comentarios;
  }
}
