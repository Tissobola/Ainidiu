import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class NascimentoFormField extends StatelessWidget {
  Function _onTap;
  TextEditingController _controller;

  NascimentoFormField({controller, onTap}) {
    this._onTap = onTap;
    this._controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: TextFormField(
        onTap: _onTap,
        controller: _controller,
        keyboardType: TextInputType.datetime,
        readOnly: true,
        decoration: InputDecoration(
            labelText: 'Data de Nascimento', border: OutlineInputBorder()),
        validator: (value) {
          if (value.isEmpty) {
            return 'Campo obrigatório';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
