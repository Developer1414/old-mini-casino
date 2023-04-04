import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/mines_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/controllers/tasks_controller.dart';
import 'package:mini_casino/screens/tasks.dart';
import 'package:mini_casino/services/animated_currency_service.dart';
import 'package:intl/intl.dart';

class Mines extends StatelessWidget {
  const Mines({Key? key}) : super(key: key);

  static TextEditingController betController = TextEditingController(text: '2');

  @override
  Widget build(BuildContext context) {
    final MinesSettingsController controller = Get.find();
    final ProfileController profileController = Get.find();

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
                          Task().showTask(CurrentGame.Mines);
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
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 15.0, top: 15.0),
                  child: Obx(
                    () => SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: controller.isStartedGame.value
                            ? () {
                                controller.autoMove();
                              }
                            : null,
                        child: Text(
                          'minesButtonAuto'.tr,
                          style: GoogleFonts.roboto(
                              fontSize: 25,
                              color: !controller.isStartedGame.value
                                  ? const Color.fromARGB(255, 72, 80, 87)
                                  : Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 15.0, bottom: 15.0, top: 15.0),
                  child: Obx(
                    () => SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: !controller.isStartedGame.value
                            ? () {
                                if (controller.isStartedGame.value) return;

                                if (betController.text.isEmpty ||
                                    double.tryParse(betController.text) ==
                                        null) {
                                  return;
                                }

                                if (double.tryParse(betController.text)!
                                    .isNegative) {
                                  return;
                                }

                                if (profileController.moneys >=
                                    double.parse(betController.text)) {
                                  profileController.minusMoneys(
                                      double.parse(betController.text));
                                  controller.startGame();
                                }
                              }
                            : () => controller.cashout(),
                        child: Text(
                          controller.isStartedGame.value
                              ? 'minesButtonCashout'.tr
                              : 'buttonBet'.tr,
                          style: GoogleFonts.roboto(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 30, 33, 36),
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 76,
            backgroundColor: Colors.transparent,
            title: Text('Mines',
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
                              '${'textProfit'.tr} (${controller.currentCoefficient.isNaN ? '0.00' : controller.currentCoefficient.toStringAsFixed(2)}x):',
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              )),
                        ),
                        Obx(() => currencyNormalFormat(
                            context,
                            (controller.bet *
                                        controller.currentCoefficient.value)
                                    .isNaN
                                ? 0
                                : controller.isStartedGame.value
                                    ? controller.bet *
                                        controller.currentCoefficient.value
                                    : controller.finishedProfit,
                            textStyle: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ))),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.563,
                          width: double.infinity,
                          padding: const EdgeInsets.all(15.0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: 25,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Obx(
                                () => Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: const Color.fromARGB(255, 44, 48, 53),
                                  elevation: 0,
                                  child: InkWell(
                                    onTap: () {
                                      if (!controller.isStartedGame.value) {
                                        return;
                                      }

                                      controller.checkItem(index);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: controller.isStartedGame.value
                                          ? controller.clickedItems
                                                  .contains(index)
                                              ? Image.asset(
                                                  'lib/assets/mines/${controller.mines.contains(index) ? 'bomb.png' : 'brilliant.png'}',
                                                  height: 60,
                                                  width: 60,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container()
                                          : Image.asset(
                                              'lib/assets/mines/${controller.mines.contains(index) ? 'bomb.png' : 'brilliant.png'}',
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              color: Colors.white.withOpacity(
                                                  controller.mines.isNotEmpty
                                                      ? !controller.clickedItems
                                                              .contains(index)
                                                          ? 0.4
                                                          : 1
                                                      : 0),
                                              colorBlendMode:
                                                  BlendMode.modulate),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                      Obx(
                        () => controller.isWonned.value
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 15.0),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.528,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color.fromARGB(255, 54, 58, 65)
                                      .withOpacity(0.8),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('minesCongratulations'.tr,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 45,
                                          )),
                                      Text(
                                          '${'textProfit'.tr}: ${NumberFormat.simpleCurrency(locale: Platform.localeName).format((controller.finishedProfit))}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 25,
                                          )),
                                      Text(
                                          '${controller.currentCoefficient.value.toStringAsFixed(2)}x',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22,
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('sliderMinesCount'.tr,
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                )),
                            Obx(
                              () => Text(
                                  controller.currentSliderValue.value
                                      .round()
                                      .toString(),
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
                          value: double.parse(
                              controller.currentSliderValue.value.toString()),
                          max: 24,
                          min: 1,
                          divisions: 23,
                          onChanged: (double value) {
                            if (controller.isStartedGame.value) return;
                            controller.currentSliderValue.value = value;
                            controller.countMines.value = value.round();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15.0),
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
                      )
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
