import 'package:ainidiu/data/providers/user_provider.dart';
import 'package:ainidiu/data/models/user.dart';

class UserRepository {
  static final _provider = UserProvider();

  Future<User> carregarDadosDoUsuario(String user) async {
    var response = await _provider.carregarDadosDoUsuario(user);

    return response;
  }
}
