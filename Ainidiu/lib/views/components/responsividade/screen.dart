import 'package:flutter/material.dart';

class Screen{

  double getScreenHeight(
      BuildContext context, double divider, double multiplier) {
    return multiplier * MediaQuery.of(context).size.height / divider;
  }

}