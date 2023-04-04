import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/limbo_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/controllers/tasks_controller.dart';
import 'package:mini_casino/models/tasks_models.dart';
import 'package:mini_casino/screens/tasks.dart';
import 'package:mini_casino/services/animated_currency_service.dart';

class Limbo extends StatelessWidget {
  const Limbo({Key? key}) : super(key: key);

  static TextEditingController betController = TextEditingController(text: '2');

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final LimboController controller = Get.find();
    final TasksController taskController = Get.find();

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
          backgroundColor: const Color.fromARGB(255, 30, 33, 36),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, bottom: 15.0, top: 15.0),
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          Task().showTask(CurrentGame.Limbo);
                        },
                        child: Center(
                          child: Icon(
                            Icons.task_rounded,
                            color: Colors.white.withOpacity(0.9),
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {
                        if (betController.text.isEmpty ||
                            double.tryParse(betController.text) == null) {
                          return;
                        }

                        if (double.parse(betController.text).isNegative) {
                          return;
                        }

                        if (profileController.moneys.value <
                            double.parse(betController.text)) {
                          return;
                        }

                        if (double.tryParse(betController.text) == 0) {
                          return;
                        }

                        profileController.minusMoneys(controller.bet.value);
                        profileController.plusTotalGame('limbo');

                        if (controller.placeABet()) {
                          profileController.plusMoneys(controller.bet.value *
                              controller.multiplier.value);
                          profileController.plusWin(
                              value: controller.bet.value *
                                  controller.multiplier.value,
                              currentX: controller.currentNumber.value,
                              gameName: 'limbo');
                        } else {
                          profileController.plusLoose(
                              controller.bet.value, 'limbo');
                        }

                        if (taskController.currentLimboTasks.isNowWorks.value) {
                          if (controller.bet.value ==
                                  taskController.currentLimboTasks.bet &&
                              !taskController.currentLimboTasks.isCompleted &&
                              controller.currentNumber.value >=
                                  taskController.currentLimboTasks.multiplier) {
                            taskController.taskCompleted(
                                taskController.currentLimboTasks.prize);
                            taskController.currentLimboTasks =
                                DefaultTask(isNowWorks: false.obs);
                          }
                        }
                      },
                      child: Text(
                        'buttonBet'.tr,
                        style: GoogleFonts.roboto(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 76,
            backgroundColor: Colors.transparent,
            title: Text('Limbo',
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
                  child: Obx(() => currencyNormalFormat(
                      context, profileController.moneys.value)),
                ),
              ),
            ],
          ),
          body: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                              '${'textProfit'.tr} (${controller.multiplier.isNaN ? '0.00' : controller.multiplier.toStringAsFixed(2)}x):',
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              )),
                        ),
                        Obx(
                          () => currencyNormalFormat(
                              context,
                              (controller.bet * controller.multiplier.value)
                                      .isNaN
                                  ? 0
                                  : controller.bet *
                                      controller.multiplier.value,
                              textStyle: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 160),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedFlipCounter(
                              duration: const Duration(milliseconds: 200),
                              fractionDigits: 2,
                              value: controller.currentNumber.value,
                              textStyle: GoogleFonts.roboto(
                                color: controller.currentTextColor.value,
                                fontWeight: FontWeight.w900,
                                fontSize: 50,
                              )),
                          Text('x',
                              style: GoogleFonts.roboto(
                                color: controller.currentTextColor.value,
                                fontWeight: FontWeight.w900,
                                fontSize: 50,
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 160),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                          onSubmitted: (value) => placeABet(value),
                          onChanged: (value) => placeABet(value),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('sliderMultiplier'.tr,
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                )),
                            Obx(
                              () => Text(
                                  '${controller.multiplier.value.toStringAsFixed(2)}x',
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
                          value: controller.multiplier.value.clamp(1.02, 98.0),
                          max: 98.0,
                          min: 1.02,
                          onChanged: (double value) {
                            controller.multiplier.value = value;
                            controller.chance.value = 100 / value;
                          },
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
                              () => Text(
                                  '${controller.chance.value.toStringAsFixed(2)}%',
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
                          value: controller.chance.value.clamp(1.02, 98.0),
                          max: 98.0,
                          min: 1.02,
                          onChanged: (double value) {
                            controller.multiplier.value = 100 / value;
                            controller.chance.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
