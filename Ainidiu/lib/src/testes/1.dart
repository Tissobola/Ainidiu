class Contato {
  int id;
  String nome;
  String email;

  Contato(this.email, this.id, this.nome);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'nome': nome, 'email': email};
    return map;
  }

  Contato.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    email = map['email'];
  }
}
