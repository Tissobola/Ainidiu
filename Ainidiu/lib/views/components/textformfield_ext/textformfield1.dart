import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFieldExt1 extends StatelessWidget {
  String _labelText;
  Icon _prefixIcon;
  TextEditingController _controller;
  TextInputType _keyboardType;
  bool _obscureText;
  Function(String) _validator;

  TextFormFieldExt1(
      {String labelText,
      Icon prefixIcon,
      TextEditingController controller,
      TextInputType keyboardType,
      bool obscureText,
      Function(String) validator}) {
    this._labelText = labelText;
    this._prefixIcon = prefixIcon;
    this._controller = controller;
    this._keyboardType = keyboardType;
    this._obscureText = obscureText;
    this._validator = validator;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        keyboardType: _keyboardType,
        controller: _controller,
        decoration:
            InputDecoration(labelText: _labelText,prefixIcon: _prefixIcon, border: OutlineInputBorder()),
            obscureText: _obscureText,
        validator: _validator,
      ),
    );
  }
}
