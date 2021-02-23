import 'package:ainidiu/controllers/cadastro_controller.dart';
import 'package:ainidiu/views/components/dropdown_search/dropdown_search.dart';
import 'package:ainidiu/views/components/dropdown_search/dropdown_search_onloading.dart';
import 'package:ainidiu/views/components/flat_button_ext/flat_button_ext1.dart';
import 'package:ainidiu/views/components/logo/logo.dart';
import 'package:ainidiu/views/components/raisedbutton_ext/raisedbutton_ext1.dart';
import 'package:ainidiu/views/components/textformfield_ext/textformfield1.dart';
import 'package:ainidiu/views/components/textformfield_ext/textformfield_avatar.dart';
import 'package:ainidiu/views/components/textformfield_ext/textformfield_data_de_nascimento.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  
  final _controller = CadastroController();
  Logo logo = Logo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Builder(
        builder: (context) => Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  //Logo
                  logo.buildLogo(context, 100, 5, 1),

                  //Email
                  TextFormFieldExt1(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    controller: _controller.controladorEmail,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: _controller.emailValidator,
                  ),

                  //Senha
                  TextFormFieldExt1(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.vpn_key),
                    controller: _controller.controladorSenha,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: _controller.senhaValidator,
                  ),

                  //Confirmar Senha
                  TextFormFieldExt1(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(Icons.vpn_key),
                    controller: _controller.controladorConfirmarSenha,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: _controller.confirmarSenhaValidator,
                  ),

                  //Estado
                  FutureBuilder(
                    future: _controller.localidades.getEstado(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return DropdownSearchLoading();
                      } else {
                        return DropdownSearchExt(
                            Mode.BOTTOM_SHEET,
                            true,
                            true,
                            snapshot.data,
                            "Estado",
                            "Selecionar estado", (value) {
                          setState(() {
                            _controller.currEstado = value;
                          });
                        }, _controller.currEstado);
                      }
                    },
                  ),

                  //Cidade
                  FutureBuilder(
                    future: _controller.localidades
                        .getCidades(_controller.currEstado),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return DropdownSearchLoading();
                      } else {
                        return DropdownSearchExt(
                            Mode.BOTTOM_SHEET,
                            true,
                            true,
                            snapshot.data,
                            "Cidade",
                            "Selecionar cidade", (value) {
                          setState(() {
                            _controller.currCidade = value;
                          });
                        }, _controller.currCidade);
                      }
                    },
                  ),

                  //Data de Nascimento
                  NascimentoFormField(
                    onTap: () async {
                      DateTime date = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.input,
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      initializeDateFormatting();
                      setState(() {
                        _controller.nascimento =
                            DateFormat('dd/MM/yyyy').format(date);
                      });
                    },
                    controller: _controller.controladorNascimento,
                  ),

                  //Gênero
                  DropdownSearchExt(
                      Mode.BOTTOM_SHEET,
                      true,
                      false,
                      ["Masculino", "Feminino", "Neutro", "Outro"],
                      "Gênero",
                      "Selecionar gênero", (value) {
                    setState(() {
                      _controller.currGenero = value;
                    });
                  }, _controller.currGenero),

                  //Avatar
                  AvatarFormField(
                    avatar: _controller.avatar,
                    context: context,
                    currGenero: _controller.currGenero,
                  ),

                  SizedBox(
                    height: 50,
                  ),

                  //Botão Cadastro
                  Builder(
                    builder: (context) {
                      if (_controller.loading) {
                        return CircularProgressIndicator();
                      } else {
                        return RaisedButtonExt1(
                          text: 'Cadastrar',
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              _controller.setLoading = !_controller.loading;
                            });

                            await _controller.cadastro(context);

                            setState(() {
                              _controller.setLoading = !_controller.loading;
                            });
                          },
                        );

                      }
                    },
                  ),

                  //Botão de login
                  FlatButtonExt1(
                      texto: 'Já tem uma conta? Login', onPressed: () => _controller.login(context))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
