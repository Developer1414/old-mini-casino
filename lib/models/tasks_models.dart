import 'package:get/get.dart';

class MinesTask extends GetxController {
  RxBool isNowWorks = false.obs;
  bool isCompleted = false;
  String text;
  double bet;
  int minesCount;
  int brilliantsCount;
  double prize;

  MinesTask(
      {required this.isNowWorks,
      this.isCompleted = false,
      this.text = '',
      this.bet = 0.0,
      this.minesCount = 0,
      this.prize = 0.0,
      this.brilliantsCount = 0});
}

class DefaultTask extends GetxController {
  RxBool isNowWorks = false.obs;
  bool isCompleted = false;
  String text;
  double bet;
  double multiplier;
  double prize;

  DefaultTask(
      {required this.isNowWorks,
      this.isCompleted = false,
      this.text = '',
      this.bet = 0.0,
      this.multiplier = 0.0,
      this.prize = 0.0});
}
