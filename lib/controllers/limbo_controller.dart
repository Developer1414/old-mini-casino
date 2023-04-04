import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LimboController extends GetxController {
  RxDouble bet = 1.0.obs;
  RxDouble multiplier = 1.0.obs;
  RxDouble chance = 98.0.obs;
  RxDouble currentNumber = 0.0.obs;
  var currentTextColor = Colors.white.obs;

  bool placeABet() {
    double randChance = Random().nextDouble() * 1000;

    if (randChance >= 980 && randChance < 1000) {
      currentNumber.value = Random().nextDouble() * 1000.00;
    } else if (randChance >= 0 && randChance < 600) {
      currentNumber.value = Random().nextDouble() * 2.80;
    } else if (randChance >= 600 && randChance < 980) {
      currentNumber.value = Random().nextDouble() * 5.70;
    }

    if (currentNumber.value < multiplier.value) {
      currentTextColor.value = Colors.redAccent;
      return false;
    } else {
      currentTextColor.value = Colors.greenAccent;
      return true;
    }
  }
}
