import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ainidiu/controllers/login_controller.dart';
import 'package:ainidiu/views/components/logo/logo.dart';
import 'package:ainidiu/views/components/flat_button_ext/flat_button_ext1.dart';
import 'package:ainidiu/views/components/textformfield_ext/textformfield1.dart';
import 'package:ainidiu/views/components/raisedbutton_ext/raisedbutton_ext1.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = LoginController();

  final logo = Logo();

  bool _loading = false;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Builder(
        builder: (context) => Container(
            height: double.infinity,
            color: Colors.white,
            child: Form(
              key: loginController.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: loginController.screen
                          .getScreenHeight(context, 30, 1),
                    ),
                    logo.buildLogo(context, 100, 5, 1),
                    SizedBox(
                      height: loginController.screen
                          .getScreenHeight(context, 90, 2),
                    ),
                    TextFormFieldExt1(
                      obscureText: false,
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      controller: loginController.controladorEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: loginController.emailValidator,
                    ),
                    SizedBox(
                      height: loginController.screen
                          .getScreenHeight(context, 100, 1),
                    ),
                    TextFormFieldExt1(
                      obscureText: true,
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.vpn_key),
                      controller: loginController.controladorSenha,
                      keyboardType: TextInputType.visiblePassword,
                      validator: loginController.senhaValidator,
                    ),
                    SizedBox(
                      height: loginController.screen
                          .getScreenHeight(context, 20, 1),
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        if (_loading) {
                          return CircularProgressIndicator();
                        } else {
                          return RaisedButtonExt1(
                            text: 'Login',
                            backgroundColor: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).secondaryHeaderColor,
                            onPressed: () async {
                              if (loginController.formKey.currentState
                                  .validate()) {
                                setState(() {
                                  _loading = true;
                                });

                                await loginController.login(context);

                                setState(() {
                                  _loading = false;
                                });
                              }
                            },
                          );
                        }
                      },
                    ),
                    FlatButtonExt1(
                      texto: 'Cadastre-se',
                      onPressed: () {
                        loginController.redirecionarParaCadastro(context);
                      },
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
