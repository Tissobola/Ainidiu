import 'package:ainidiu/data/repositories/login_repository.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/data/repositories/user_repository.dart';
import 'package:ainidiu/views/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final loginRepository = LoginRepository();
  final userRepository = UserRepository();

  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController controladorSenha = TextEditingController();

  String get email {
    return controladorEmail.text;
  }

  String get senha {
    return controladorSenha.text;
  }

  login(BuildContext context) async {
    String aux = await loginRepository.login(this.email, this.senha);

    User user = await userRepository.carregarDadosDoUsuario(aux);

    if (aux != '1' && aux != '2') {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('user', user.apelido);

      var token = await loginRepository.getUserToken();

      loginRepository.registrarToken(token, user.id);

      FocusScope.of(context).requestFocus(new FocusNode());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(0, usuario: user)),
          (route) => false);
    } else if (aux == '1') {
      FocusScope.of(context).requestFocus(new FocusNode());

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Email não registrado!'),
        backgroundColor: Colors.red,
      ));
    } else {
      FocusScope.of(context).requestFocus(new FocusNode());

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Senha incorreta!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  redirecionarParaCadastro() {}
}
