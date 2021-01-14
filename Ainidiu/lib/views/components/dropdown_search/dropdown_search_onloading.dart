import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownSearchLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              Text(
                'Aguarde...',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
