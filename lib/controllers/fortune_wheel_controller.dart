import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FortuneWheelController extends GetxController {
  RxBool isStartedGame = false.obs;
  var bet = 1.0.obs;
  var currentX = 0.0.obs;
  var profit = 0.0.obs;
  RxString selectedX = ''.obs;
  RxList lastColors = [].obs;
}
