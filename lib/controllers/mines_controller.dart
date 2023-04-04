import 'dart:math';

import 'package:get/get.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/controllers/tasks_controller.dart';
import 'package:mini_casino/main.dart';
import 'package:mini_casino/models/tasks_models.dart';

class MinesSettingsController extends GetxController {
  RxBool isStartedGame = false.obs;
  RxBool isWonned = false.obs;

  RxList mines = [].obs;
  RxList brilliants = [].obs;
  RxList clickedItems = [].obs;

  RxInt countMines = 1.obs;

  RxDouble bet = 2.0.obs;
  double finishedProfit = 0;
  RxDouble currentCoefficient = 0.0.obs;
  RxDouble currentSliderValue = 1.0.obs;

  final ProfileController profileController = Get.find();

  checkItem(int index) {
    if (clickedItems.contains(index)) return;

    clickedItems.add(index);

    if (mines.contains(index)) {
      isStartedGame.value = false;
      profileController.plusLoose(bet.value, 'mines');
      profileController.plusTotalGame('mines');
    } else {
      brilliants.add(index);
      calculateCoefficient();
    }

    if (brilliants.length == (25 - countMines.value)) {
      cashout();
    }

    if (MyApp.tasksController.currentMinesTask.isNowWorks.value) {
      if (bet.value == MyApp.tasksController.currentMinesTask.bet &&
          currentSliderValue.value ==
              MyApp.tasksController.currentMinesTask.minesCount.toDouble() &&
          brilliants.length ==
              MyApp.tasksController.currentMinesTask.brilliantsCount) {
        MyApp.tasksController
            .taskCompleted(MyApp.tasksController.currentMinesTask.prize);
        MyApp.tasksController.currentMinesTask =
            MinesTask(isNowWorks: false.obs);
      }
    }
  }

  startGame() {
    isStartedGame.value = true;
    isWonned.value = false;

    mines.clear();
    brilliants.clear();
    clickedItems.clear();

    calculateCoefficient();

    int rand = 0;

    while (mines.length != countMines.value) {
      rand = Random().nextInt(25);

      if (!mines.contains(rand)) {
        mines.add(rand);
      }
    }
  }

  autoMove() {
    int rand = 0;
    bool successed = false;

    while (!successed) {
      rand = Random().nextInt(25);

      if (!clickedItems.contains(rand)) {
        checkItem(rand);
        successed = true;
      }
    }
  }

  double factorial(double fact) {
    double num = fact;

    for (double i = fact - 1; i >= 1; i--) {
      num *= i;
    }
    return num;
  }

  double combination(double n, double d) {
    if (n == d) return 1;
    return factorial(n) / (factorial(d) * factorial(n - d));
  }

  void calculateCoefficient() {
    double n = 25;
    double x = 25 - double.parse(countMines.value.toString());
    double d = double.parse(clickedItems.length.toString());

    double first = combination(n, d);
    double second = combination(x, d);

    currentCoefficient.value = 0.99 * (first / second);
  }

  cashout() async {
    isWonned.value = true;
    isStartedGame.value = false;

    var val = bet * currentCoefficient.value;

    if (clickedItems.isNotEmpty) {
      if (!currentCoefficient.value.isNaN) {
        finishedProfit = val;
        profileController.plusMoneys(bet.value * currentCoefficient.value);
        profileController.plusWin(
            value: bet.value * currentCoefficient.value,
            currentX: currentCoefficient.value,
            gameName: 'mines');
        profileController.plusTotalGame('mines');
      }
    } else {
      finishedProfit = 0;
      currentCoefficient.value = 0;
      profileController.plusMoneys(bet.value);
    }
  }
}
