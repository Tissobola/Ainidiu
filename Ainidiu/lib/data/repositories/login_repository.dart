import 'package:ainidiu/data/providers/login_firebase_provider.dart';

class LoginRepository {
  static final _provider = LoginFirebaseProvider();

  Future<String> login(String email, String senha) async {
    var response = await _provider.login(email, senha);

    return response;
  }

  getUserToken() async {
    var token = await _provider.getUserToken();

    return token;
  }

  registrarToken(String token, int userId) async {
    await _provider.registrarToken(token, userId);
  }

}
