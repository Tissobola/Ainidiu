//Classe que representa o usuário do aplicativo
class User {
  //URL da imagem de perfil
  String imageURL;

  //Apelido do usuário
  String apelido;
 
  //Email do usuário
  String email;

  //Gênero do usuário
  String genero;

  //Indentificador do usuário - Inteiro
  int id;

  //Senha do usuário
  String senha;

  //Identificador do aparelho usado pelo usuário
  String token;

  //Cidade do usuário
  String cidade;

  //Estado do usuário
  String estado;

  //Data de nascimento (DIA/MES/ANO)
  String nascimento;
  
  //Construtor
  User(this.token ,this.imageURL, this.apelido, this.email, this.genero, this.id,
      this.senha, this.cidade, this.nascimento);
}
