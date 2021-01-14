import 'package:ainidiu/data/providers/cadastro_firebase_provider.dart';

class CadastroRepository {
  final _provider = CadastroFirebaseProvider();

  Future<int> cadastro(String token, String email, String senha, String genero,
      String imageURL, String estado, String cidade, String nascimento) async {
    int response;

    try {
      response = await _provider.cadastro(
          token, email, senha, genero, imageURL, estado, cidade, nascimento);

      return response;
    } catch (ex) {
      return null;
    }
  }

  Future<int> reCadastro(
      String token,
      String email,
      String senha,
      String genero,
      String imageURL,
      String estado,
      String cidade,
      String nascimento) async {
    int response;

    try {
      response = await _provider.reCadastro(
          token, email, senha, genero, imageURL, estado, cidade, nascimento);

      return response;
    } catch (ex) {
      return null;
    }
  }

  Future<String> getToken() async {
    String token;

    try {
      token = await _provider.getToken();
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getURLSMan() async {
    try {
      List<String> response = List<String>();
      response = await _provider.getURLSMan();

      return response;
    } catch (ex) {
      return null;
    }
  }

  Future<List<String>> getURLSWoman() async {
    try {
      List<String> response = List<String>();
      response = await _provider.getURLSWoman();

      return response;
    } catch (ex) {
      return null;
    }
  }

  Future<List<String>> getAllURLS() async {
    try {
      List<String> response = List<String>();
      response = await _provider.getAllURLS();

      return response;
    } catch (ex) {
      return null;
    }
  }
}
