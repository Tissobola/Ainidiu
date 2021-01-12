import 'package:flutter/material.dart';
import 'package:ainidiu/views/components/responsividade/screen.dart';

class Logo {
  final screen = Screen();

  Widget buildLogo(BuildContext context, double width, double divider, double multiplier) {
    return Container(
        width: width,
        height: screen.getScreenHeight(context, divider, multiplier),
        child: Image.asset(
          "assets/icon/icon.png",
        ));
  }
}
