import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/dice_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/controllers/tasks_controller.dart';
import 'package:mini_casino/models/tasks_models.dart';
import 'package:mini_casino/services/animated_currency_service.dart';

class Dice extends StatelessWidget {
  const Dice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final DiceController controller = Get.find();
    final TasksController taskController = Get.find();

    TextEditingController betController =
        TextEditingController(text: controller.bet.value.toStringAsFixed(0));

    betController.selection =
        TextSelection(baseOffset: 0, extentOffset: betController.text.length);

    placeABet(String value) {
      if (betController.text.isEmpty ||
          double.tryParse(betController.text) == null) {
        return;
      }

      if (double.parse(betController.text).isNegative) {
        return;
      }

      controller.bet.value = double.parse(value);
    }

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => SizedBox(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: !controller.isStartedGame.value
                                          ? () async {
                                              if (controller
                                                  .isStartedGame.value) {
                                                return;
                                              }

                                              if (betController.text.isEmpty ||
                                                  double.tryParse(
                                                          betController.text) ==
                                                      null) {
                                                return;
                                              }

                                              if (double.tryParse(
                                                      betController.text)!
                                                  .isNegative) {
                                                return;
                                              }

                                              int rand =
                                                  Random().nextInt(1000000);

                                              if (profileController.moneys >=
                                                  double.parse(
                                                      betController.text)) {
                                                profileController.minusMoneys(
                                                    double.parse(
                                                        betController.text));

                                                controller.currentNumber.value =
                                                    rand;

                                                if (rand >= 0 &&
                                                    rand <=
                                                        controller
                                                            .lessNumber.value) {
                                                  controller.currentTextColor
                                                          .value =
                                                      Colors.greenAccent;
                                                  profileController.plusMoneys(
                                                      double.parse(betController
                                                              .text) *
                                                          controller.coefficient
                                                              .value);
                                                  profileController.plusWin(
                                                      value: double.parse(
                                                              betController
                                                                  .text) *
                                                          controller.coefficient
                                                              .value,
                                                      currentX: controller
                                                          .coefficient.value,
                                                      gameName: 'dice');
                                                } else {
                                                  controller.currentTextColor
                                                      .value = Colors.redAccent;
                                                  profileController.plusLoose(
                                                      controller.bet.value,
                                                      'dice');
                                                }

                                                profileController
                                                    .plusTotalGame('dice');

                                                if (taskController
                                                    .currentDiceTasks
                                                    .isNowWorks
                                                    .value) {
                                                  if (controller.bet.value ==
                                                          taskController
                                                              .currentDiceTasks
                                                              .bet &&
                                                      !taskController
                                                          .currentDiceTasks
                                                          .isCompleted &&
                                                      controller.currentNumber
                                                              .value >=
                                                          taskController
                                                              .currentDiceTasks
                                                              .multiplier) {
                                                    taskController.taskCompleted(
                                                        taskController
                                                            .currentDiceTasks
                                                            .prize);
                                                    taskController
                                                            .currentDiceTasks =
                                                        DefaultTask(
                                                            isNowWorks:
                                                                false.obs);
                                                  }
                                                }
                                              }
                                            }
                                          : null,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '<',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Obx(
                                              () => Text(
                                                '${controller.lessNumber} - 999999',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    color: controller
                                                            .isStartedGame.value
                                                        ? const Color.fromARGB(
                                                            255, 72, 80, 87)
                                                        : Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    onPressed: !controller.isStartedGame.value
                                        ? () async {
                                            if (controller
                                                .isStartedGame.value) {
                                              return;
                                            }

                                            if (betController.text.isEmpty ||
                                                double.tryParse(
                                                        betController.text) ==
                                                    null) {
                                              return;
                                            }

                                            if (double.tryParse(
                                                    betController.text)!
                                                .isNegative) {
                                              return;
                                            }

                                            int rand =
                                                Random().nextInt(1000000);

                                            if (profileController.moneys >=
                                                double.parse(
                                                    betController.text)) {
                                              profileController.minusMoneys(
                                                  double.parse(
                                                      betController.text));

                                              controller.currentNumber.value =
                                                  rand;

                                              if (rand >= 0 &&
                                                  rand <=
                                                      controller
                                                          .lessNumber.value) {
                                                controller.currentTextColor
                                                    .value = Colors.greenAccent;
                                                profileController.plusMoneys(
                                                    double.parse(betController
                                                            .text) *
                                                        controller
                                                            .coefficient.value);
                                                profileController.plusWin(
                                                    value: double.parse(
                                                            betController
                                                                .text) *
                                                        controller
                                                            .coefficient.value,
                                                    currentX: controller
                                                        .coefficient.value,
                                                    gameName: 'dice');
                                              } else {
                                                controller.currentTextColor
                                                    .value = Colors.redAccent;
                                                profileController.plusLoose(
                                                    controller.bet.value,
                                                    'dice');
                                              }

                                              profileController
                                                  .plusTotalGame('dice');

                                              if (taskController
                                                  .currentDiceTasks
                                                  .isNowWorks
                                                  .value) {
                                                if (controller.bet.value ==
                                                        taskController
                                                            .currentDiceTasks
                                                            .bet &&
                                                    !taskController
                                                        .currentDiceTasks
                                                        .isCompleted &&
                                                    controller.currentNumber
                                                            .value >=
                                                        taskController
                                                            .currentDiceTasks
                                                            .multiplier) {
                                                  taskController.taskCompleted(
                                                      taskController
                                                          .currentDiceTasks
                                                          .prize);
                                                  taskController
                                                          .currentDiceTasks =
                                                      DefaultTask(
                                                          isNowWorks:
                                                              false.obs);
                                                }
                                              }
                                            }
                                          }
                                        : null,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '>',
                                            style: GoogleFonts.roboto(
                                                fontSize: 25,
                                                color: controller
                                                        .isStartedGame.value
                                                    ? const Color.fromARGB(
                                                        255, 72, 80, 87)
                                                    : Colors.white,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          Obx(
                                            () => Text(
                                              '0 - ${controller.lessNumber}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  color: controller
                                                          .isStartedGame.value
                                                      ? const Color.fromARGB(
                                                          255, 72, 80, 87)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              backgroundColor: const Color.fromARGB(255, 30, 33, 36),
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 76,
                backgroundColor: Colors.transparent,
                title: Text('Dice',
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    )),
                //leadingWidth: 40,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: IconButton(
                      splashRadius: 25,
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 28,
                      )),
                ),
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Obx(
                        () => currencyNormalFormat(
                            context, profileController.moneys.value),
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                              '${'textProfit'.tr} (${controller.coefficient.isNaN ? '0.00' : controller.coefficient.toStringAsFixed(2)}x):',
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              )),
                        ),
                        Obx(() => currencyNormalFormat(
                            context,
                            (controller.bet * controller.coefficient.value)
                                    .isNaN
                                ? 0
                                : controller.bet * controller.coefficient.value,
                            textStyle: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SizedBox(
                      height: 200,
                      child: Obx(
                        () => AnimatedFlipCounter(
                            duration: const Duration(milliseconds: 200),
                            value: controller.currentNumber.value,
                            textStyle: GoogleFonts.roboto(
                              color: controller.currentTextColor.value,
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                            )),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Obx(
                          () => TextField(
                            style: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                            onSubmitted: (value) => placeABet(value),
                            onChanged: (value) => placeABet(value),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            readOnly: controller.isStartedGame.value,
                            controller: betController,
                            decoration: InputDecoration(
                              hintText: 'textFieldBet'.tr,
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 62, 68, 75),
                                      width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 76, 83, 92),
                                      width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('sliderChance'.tr,
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                )),
                            Obx(
                              () => Text('${controller.percent.value.round()}%',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Slider(
                          value:
                              double.parse(controller.percent.value.toString()),
                          max: 95,
                          min: 1,
                          onChanged: (double value) {
                            if (controller.isStartedGame.value) return;
                            controller.percent.value = value.round();

                            controller.lessNumber.value = value.round() * 9999;
                            controller.moreNumber.value =
                                1000000 - (value.round() * 10000);
                            controller.coefficient.value = 100 / value;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
