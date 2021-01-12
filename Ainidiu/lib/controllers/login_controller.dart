import 'package:ainidiu/views/page/login_cadastro.dart';

import 'package:ainidiu/data/repositories/login_repository.dart';
import 'package:ainidiu/data/models/user.dart';
import 'package:ainidiu/data/repositories/user_repository.dart';
import 'package:ainidiu/views/page/home_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ainidiu/views/components/responsividade/screen.dart';

class LoginController {
  final loginRepository = LoginRepository();
  final userRepository = UserRepository();

  final screen = Screen();

  final formKey = GlobalKey<FormState>();

  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController controladorSenha = TextEditingController();

  String get email {
    return controladorEmail.text;
  }

  String get senha {
    return controladorSenha.text;
  }

  String emailValidator(String value) {
    if (EmailValidator.validate(value)) {
      return null;
    } else {
      return 'Email inválido';
    }
  }

  String senhaValidator(String value) {
    if (senha.isEmpty) {
      return 'A senha não pode ser vazia';
    } else if (senha.length < 6) {
      return 'Senha inválida';
    }

    return null;
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

  redirecionarParaCadastro(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Cadastro()));
  }
}
