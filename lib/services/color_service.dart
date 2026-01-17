import 'package:flutter/material.dart';

class ColorService {
  Color hexToColor(String code) {
    code = code.replaceAll("#", "");

    if (code.length == 6) {
      code = "FF$code";
    }

    return Color(int.parse(code, radix: 16));
  }

  Color lighten(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      color.alpha,
      color.red + ((255 - color.red) * amount).toInt(),
      color.green + ((255 - color.green) * amount).toInt(),
      color.blue + ((255 - color.blue) * amount).toInt(),
    );
  }

  Color darken(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - amount)).toInt(),
      (color.green * (1 - amount)).toInt(),
      (color.blue * (1 - amount)).toInt(),
    );
  }
}
