import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiceController extends GetxController {
  RxBool isStartedGame = false.obs;
  RxDouble bet = 1.0.obs;
  RxDouble coefficient = 2.0.obs;
  RxInt percent = 50.obs;
  RxInt currentNumber = 0.obs;
  RxInt lessNumber = 499950.obs;
  RxInt moreNumber = 499950.obs;

  var currentTextColor = Colors.white.obs;
}
