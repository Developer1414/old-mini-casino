import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/fortune_wheel_controller.dart';
import 'package:mini_casino/controllers/limbo_controller.dart';
import 'package:mini_casino/controllers/mines_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/models/tasks_models.dart';
import 'package:mini_casino/screens/fortune_wheel.dart';
import 'package:mini_casino/screens/limbo.dart';
import 'package:mini_casino/screens/mines.dart';
import 'package:intl/intl.dart';

enum CurrentGame { Mines, Limbo, FortuneWheel }

int random(int min, int max) {
  return min + Random().nextInt(max - min);
}

class TasksController extends GetxController {
  final ProfileController profileController = Get.find();

  final MinesSettingsController minesController = Get.find();
  final LimboController limboController = Get.find();
  final FortuneWheelController fortuneWheelController = Get.find();

  RxBool isAvailableWork = false.obs;

  var currentTask;

  MinesTask currentMinesTask = MinesTask(isNowWorks: false.obs);
  DefaultTask currentLimboTasks = DefaultTask(isNowWorks: false.obs);
  DefaultTask currentFortuneWheelTasks = DefaultTask(isNowWorks: false.obs);
  DefaultTask currentDiceTasks = DefaultTask(isNowWorks: false.obs);

  int randBrilliants = 0;
  int randMines = 0;
  int randBet = 0;
  int randMultiplier = 0;
  int randChance = 0;
  int randFortune = 0;
  int randFortuneMultiplier = 0;
  int randLimboMultiplier = 0;

  String endSymbols(String number, {String lang = 'ru_RU'}) {
    String lastNum = number[number.length - 1];
    String result = '';

    var ending;

    if (lang == 'ru_RU') {
      Map<String, String> endingRU = {
        '0': 'ов',
        '1': '',
        '2': 'а',
        '3': 'а',
        '4': 'а',
        '5': 'ов',
        '6': 'ов',
        '7': 'ов',
        '8': 'ов',
        '9': 'ов',
      };
      ending = endingRU;
    } else if (lang == 'en_US') {
      Map<String, String> endingUS = {
        '0': 's',
        '1': '',
        '2': 's',
        '3': 's',
        '4': 's',
        '5': 's',
        '6': 's',
        '7': 's',
        '8': 's',
        '9': 's',
      };
      ending = endingUS;
    }

    ending.forEach((key, value) {
      if (key == lastNum) {
        result = value;
      }
    });

    return result;
  }

  void taskCompleted(double prize) {
    Get.snackbar(
      '',
      '',
      duration: const Duration(milliseconds: 1800),
      titleText: Text('notificationTaskCompleted'.tr,
          style: GoogleFonts.roboto(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w700)),
      messageText: Text(
          '+${NumberFormat.simpleCurrency(locale: Platform.localeName).format(prize.toDouble())}',
          style: GoogleFonts.roboto(
              fontSize: 15,
              color: Colors.white70,
              fontWeight: FontWeight.w700)),
    );

    profileController.plusMoneys(prize);
  }

  void generateRandomNumbers() {
    randBrilliants = random(1, 12);
    randMines = random(1, 12);
    randBet = random(10, 100);
    randMultiplier = random(1, 101);
    randChance = random(2, 25);
    randFortune = random(1, 5);

    randFortuneMultiplier = randMultiplier <= 25
        ? 2
        : randFortune <= 50
            ? 3
            : randFortune <= 75
                ? 5
                : randFortune <= 100
                    ? 30
                    : 0;

    randLimboMultiplier = randMultiplier <= 10
        ? random(2, 11)
        : randMultiplier > 10 && randMultiplier <= 20
            ? random(10, 21)
            : randMultiplier > 20 && randMultiplier <= 30
                ? random(20, 31)
                : randMultiplier > 30 && randMultiplier <= 40
                    ? random(30, 41)
                    : randMultiplier > 40 && randMultiplier <= 50
                        ? random(40, 51)
                        : randMultiplier > 50 && randMultiplier <= 60
                            ? random(50, 61)
                            : randMultiplier > 60 && randMultiplier <= 70
                                ? random(60, 71)
                                : randMultiplier > 70 && randMultiplier <= 80
                                    ? random(70, 81)
                                    : randMultiplier > 80 &&
                                            randMultiplier <= 100
                                        ? random(80, 101)
                                        : 0;
  }

  void selectTask(CurrentGame currentGame) {
    switch (currentGame) {
      case CurrentGame.Mines:
        currentMinesTask = currentTask;
        currentMinesTask.isNowWorks.value = true;

        minesController.currentSliderValue.value =
            currentMinesTask.minesCount.toDouble();
        minesController.countMines.value = currentMinesTask.minesCount;
        Mines.betController.text = currentMinesTask.bet.toStringAsFixed(0);
        minesController.bet.value = currentMinesTask.bet;
        break;
      case CurrentGame.Limbo:
        currentLimboTasks = currentTask;
        currentLimboTasks.isNowWorks.value = true;

        limboController.multiplier.value = currentLimboTasks.multiplier;
        Limbo.betController.text = currentLimboTasks.bet.toStringAsFixed(0);
        limboController.bet.value = currentLimboTasks.bet;
        break;
      case CurrentGame.FortuneWheel:
        currentFortuneWheelTasks = currentTask;
        currentFortuneWheelTasks.isNowWorks.value = true;

        fortuneWheelController.currentX.value =
            currentFortuneWheelTasks.multiplier;
        FortuneWheel.betController.text =
            currentFortuneWheelTasks.bet.toStringAsFixed(0);
        fortuneWheelController.bet.value = currentFortuneWheelTasks.bet;
        break;
    }
  }

  void deselectTask(CurrentGame currentGame) {
    switch (currentGame) {
      case CurrentGame.Mines:
        currentMinesTask.isNowWorks.value = false;
        break;
      case CurrentGame.Limbo:
        currentLimboTasks.isNowWorks.value = false;
        break;
      case CurrentGame.FortuneWheel:
        currentFortuneWheelTasks.isNowWorks.value = false;
        break;
    }
  }

  bool generateTasks(CurrentGame game) {
    if (game == CurrentGame.Mines) {
      if (currentMinesTask.isNowWorks.value) {
        currentTask = currentMinesTask;
        return false;
      }

      generateRandomNumbers();

      double resultBet =
          profileController.moneys.value / (2 + Random().nextDouble() * 6) +
              (1 + Random().nextDouble() * 2);

      currentTask = MinesTask(
          isNowWorks: false.obs,
          text:
              '${'tasksGuessWord'.tr} $randBrilliants ${'tasksBrilliantsWord'.tr}${endSymbols(randBrilliants.toString(), lang: Platform.localeName)} ${'tasksQuantityMinsWord'.tr} $randMines\n${'betWord'.tr} ${NumberFormat.simpleCurrency(locale: Platform.localeName).format(resultBet.roundToDouble())}',
          bet: resultBet.roundToDouble(),
          minesCount: randMines,
          brilliantsCount: randBrilliants,
          prize: resultBet * (2 + Random().nextDouble() * 5) / 1.2);

      currentMinesTask = currentTask;

      return true;
    }

    if (game == CurrentGame.Limbo) {
      if (currentLimboTasks.isNowWorks.value) {
        currentTask = currentLimboTasks;
        return false;
      }

      generateRandomNumbers();

      double resultBet = profileController.moneys.value /
          (double.parse(randMultiplier.toString()) * random(2, 4));

      currentTask = DefaultTask(
          isNowWorks: false.obs,
          text:
              '${'knockWord'.tr} x >= $randLimboMultiplier\n${'betWord'.tr} ${NumberFormat.simpleCurrency(locale: Platform.localeName).format(resultBet.roundToDouble())}',
          bet: resultBet.roundToDouble(),
          multiplier: double.parse(randLimboMultiplier.toString()),
          prize:
              resultBet * double.parse(randLimboMultiplier.toString()) / 1.2 +
                  random(10, 1000) /
                      (resultBet *
                              double.parse(randLimboMultiplier.toString()) /
                              1.2 +
                          random(10, 1000)));

      currentLimboTasks = currentTask;

      return true;
    }

    if (game == CurrentGame.FortuneWheel) {
      if (currentFortuneWheelTasks.isNowWorks.value) {
        currentTask = currentFortuneWheelTasks;
        return false;
      }

      generateRandomNumbers();

      double resultBet = profileController.moneys.value /
              (randFortuneMultiplier * random(2, 4)) +
          (1 + Random().nextDouble() * profileController.moneys.value / 3.5);

      currentTask = DefaultTask(
          isNowWorks: false.obs,
          text:
              '${'knockWord'.tr} ${randFortuneMultiplier}x\n${'betWord'.tr} ${NumberFormat.simpleCurrency(locale: Platform.localeName).format(resultBet.roundToDouble())}',
          bet: resultBet.roundToDouble(),
          multiplier: double.parse(randFortuneMultiplier.toString()),
          prize: resultBet * random(2, 5) / 1.2 + random(10, 1000));

      currentFortuneWheelTasks = currentTask;

      return true;
    }

    return false;
  }
}
