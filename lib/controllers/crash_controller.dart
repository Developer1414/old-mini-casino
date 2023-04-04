import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CrashController extends GetxController {
  RxBool isStartedGame = false.obs;
  RxDouble bet = 1.0.obs;
  RxDouble coefficient = 2.0.obs;
  RxDouble mainNumber = 0.0.obs;
  var currentTextColor = Colors.blueAccent.obs;
}
