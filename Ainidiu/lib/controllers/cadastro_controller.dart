import 'package:ainidiu/data/models/localidades.dart';
import 'package:ainidiu/data/repositories/cadastro_repository.dart';
import 'package:ainidiu/views/page/login_login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CadastroController {
  final _repository = CadastroRepository();

  final localidades = Localidades();

  bool _loading = false;

  bool mas = false;
  bool fem = false;
  bool neu = false;

  String currGenero = 'Selecionar';
  List<String> generos = ["Masculino", "Feminino", "Outro", "Selecionar"];

  String currEstado = 'Selecionar';
  String currCidade = 'Selecionar';

  String avatar =
      'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_960_720.png';

  final formKey = GlobalKey<FormState>();

  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController controladorSenha = TextEditingController();
  final TextEditingController controladorConfirmarSenha =
      TextEditingController();
  final TextEditingController controladorNascimento = TextEditingController();

  String get email {
    return controladorEmail.text;
  }

  String get senha {
    return controladorSenha.text;
  }

  String get confirmarSenha {
    return controladorConfirmarSenha.text;
  }

  String get nascimento {
    return controladorNascimento.text;
  }

  set nascimento(String value) {
    this.controladorNascimento.text = value;
  }

  bool get loading {
    return _loading;
  }

  set setLoading(bool value) {
    _loading = !loading;
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

  String confirmarSenhaValidator(String value) {
    if (confirmarSenha.isEmpty) {
      return 'A senha não pode ser vazia';
    } else if (confirmarSenha.length < 6) {
      return 'Senha inválida';
    } else if (confirmarSenha != senha) {
      return 'As duas senhas não são iguais';
    }

    return null;
  }

  Future<void> cadastro(BuildContext context) async {

    int response;
    String token;

    if (formKey.currentState.validate() &&
        currEstado != "Selecionar" &&
        currCidade != "Selecionar" &&
        currGenero != "Selecionar") {
      try {
        token = await _repository.getToken();

        response = await _repository.cadastro(token, email, senha, currGenero,
            avatar, currEstado, currCidade, nascimento);

        if (response == 0) {
          FocusScope.of(context).requestFocus(new FocusNode());
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Cadastro realizado!'),
            backgroundColor: Colors.blue,
          ));

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
        } else {
          FocusScope.of(context).requestFocus(new FocusNode());

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Email já em uso!'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        return null;
      }
    }
  }
}
