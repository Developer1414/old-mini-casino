import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/fortune_wheel_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/controllers/tasks_controller.dart';
import 'package:mini_casino/fortune_wheel/board_view.dart';
import 'package:mini_casino/fortune_wheel/model.dart';
import 'package:mini_casino/models/tasks_models.dart';
import 'package:mini_casino/screens/tasks.dart';
import 'package:mini_casino/services/animated_currency_service.dart';

class FortuneWheel extends StatefulWidget {
  const FortuneWheel({Key? key}) : super(key: key);

  static TextEditingController betController = TextEditingController(text: '2');

  @override
  State<FortuneWheel> createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel>
    with SingleTickerProviderStateMixin {
  dynamic wheelResult = 0;

  double _angle = 0;
  double _current = 0;

  late AnimationController _ctrl;
  late Animation _ani;

  final ProfileController profileController = Get.find();
  final FortuneWheelController controller = Get.find();
  final TasksController taskController = Get.find();

  final List<Luck> _items = [
    Luck("30x", Colors.green),
    Luck("2x", Colors.blueGrey),
    Luck("3x", Colors.orangeAccent),
    Luck("2x", Colors.blueGrey),
    Luck("5x", Colors.redAccent),
    Luck("2x", Colors.blueGrey),
    Luck("3x", Colors.orangeAccent),
    Luck("2x", Colors.blueGrey),
    Luck("5x", Colors.redAccent),
    Luck("2x", Colors.blueGrey),
    Luck("3x", Colors.orangeAccent),
    Luck("2x", Colors.blueGrey),
    Luck("5x", Colors.redAccent),
    Luck("2x", Colors.blueGrey),
    Luck("3x", Colors.orangeAccent),
    Luck("2x", Colors.blueGrey),
    Luck("5x", Colors.redAccent),
    Luck("2x", Colors.blueGrey),
    Luck("3x", Colors.orangeAccent),
    Luck("2x", Colors.blueGrey),
  ];

  @override
  void initState() {
    super.initState();
    var duration = const Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    FortuneWheel.betController =
        TextEditingController(text: controller.bet.toStringAsFixed(0));
    FortuneWheel.betController.selection = TextSelection(
        baseOffset: 0, extentOffset: FortuneWheel.betController.text.length);

    placeABet(String value) {
      if (FortuneWheel.betController.text.isEmpty ||
          double.tryParse(FortuneWheel.betController.text) == null) {
        return;
      }

      if (double.parse(FortuneWheel.betController.text).isNegative ||
          double.parse(FortuneWheel.betController.text) == 0) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 0,
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
                                Task().showTask(CurrentGame.FortuneWheel);
                              },
                              child: Center(
                                child: Icon(
                                  Icons.task_rounded,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 28,
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: !controller.isStartedGame.value
                                  ? () => selectX('2x')
                                  : null,
                              child: Text(
                                '2x',
                                style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    color: controller.isStartedGame.value
                                        ? const Color.fromARGB(255, 72, 80, 87)
                                        : Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: !controller.isStartedGame.value
                                  ? () => selectX('3x')
                                  : null,
                              child: Text(
                                '3x',
                                style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    color: controller.isStartedGame.value
                                        ? const Color.fromARGB(255, 72, 80, 87)
                                        : Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: !controller.isStartedGame.value
                                  ? () => selectX('5x')
                                  : null,
                              child: Text(
                                '5x',
                                style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    color: controller.isStartedGame.value
                                        ? const Color.fromARGB(255, 72, 80, 87)
                                        : Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onPressed: !controller.isStartedGame.value
                                  ? () => selectX('30x')
                                  : null,
                              child: Text(
                                '30x',
                                style: GoogleFonts.roboto(
                                    fontSize: 22,
                                    color: controller.isStartedGame.value
                                        ? const Color.fromARGB(255, 72, 80, 87)
                                        : Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
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
            title: Text('FW',
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
                  onPressed: () =>
                      controller.isStartedGame.value ? null : Get.back(),
                  icon: Obx(
                    () => Icon(
                      Icons.arrow_back_rounded,
                      color: controller.isStartedGame.value
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white.withOpacity(0.9),
                      size: 28,
                    ),
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
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${'textProfit'.tr}:',
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                )),
                            Obx(() => currencyNormalFormat(
                                context, controller.profit.value,
                                textStyle: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                      animation: _ani,
                      builder: (context, child) {
                        wheelResult = _ani.value;
                        final angle = wheelResult * _angle;
                        return Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            BoardView(
                                items: _items, current: _current, angle: angle),
                            _buildResult(wheelResult)
                          ],
                        );
                      }),
                  Column(
                    children: [
                      Container(
                        height: 45,
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: const Color.fromARGB(255, 62, 68, 75),
                              width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Obx(
                            () => ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.lastColors.length,
                                itemBuilder: (ctx, index) {
                                  var list = controller.lastColors.reversed;

                                  return Container(
                                    width: 10,
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 5.0,
                                        right: 3.0,
                                        left: 3.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: list.toList()[index]),
                                  );
                                }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          child: Obx(
                            () => TextField(
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom *
                                          20),
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
                              controller: FortuneWheel.betController,
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 76, 83, 92),
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            ),
                          ),
                        ),
                      ),
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

  _animation() {
    if (!_ctrl.isAnimating) {
      var random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
      });
    }
  }

  int _calIndex(value) {
    var base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((base + value) % 1) * _items.length).floor();
  }

  _buildResult(value) {
    var index = _calIndex(value * _angle + _current);

    if (!_ctrl.isAnimating) {
      if (controller.selectedX.value.isNotEmpty) {
        Future.delayed(Duration.zero, () async {
          var myProfit = controller.bet *
              double.parse(_items[index].value.replaceAll('x', ''));

          if (_items[index].value == controller.selectedX.value) {
            profileController.plusMoneys(myProfit);
            profileController.plusWin(
                value: myProfit,
                currentX: double.parse(_items[index].value.replaceAll('x', '')),
                gameName: 'fortuneWheel');
            controller.profit.value = myProfit.isNaN ? 0 : myProfit;
          } else {
            profileController.plusLoose(controller.bet.value, 'fortuneWheel');
          }

          switch (_items[index].value) {
            case '2x':
              controller.lastColors.add(Colors.blueGrey);
              break;
            case '3x':
              controller.lastColors.add(Colors.orangeAccent);
              break;
            case '5x':
              controller.lastColors.add(Colors.redAccent);
              break;
            case '30x':
              controller.lastColors.add(Colors.green);
              break;
          }

          int taskX =
              taskController.currentFortuneWheelTasks.multiplier.toInt();

          if (taskController.currentFortuneWheelTasks.isNowWorks.value) {
            if (controller.bet.value ==
                    taskController.currentFortuneWheelTasks.bet &&
                !taskController.currentFortuneWheelTasks.isCompleted &&
                controller.selectedX.value == '${taskX}x' &&
                _items[index].value == '${taskX}x') {
              taskController
                  .taskCompleted(taskController.currentFortuneWheelTasks.prize);
              taskController.currentFortuneWheelTasks =
                  DefaultTask(isNowWorks: false.obs);
            }
          }

          controller.isStartedGame.value = false;
          controller.selectedX.value = '';
        });
      }
    }

    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: SizedBox(
        height: 72,
        width: 72,
        child: Center(
          child: Text(
            _items[index].value,
            style: GoogleFonts.roboto(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }

  selectX(String myX) async {
    if (controller.isStartedGame.value) {
      return;
    }

    if (FortuneWheel.betController.text.isEmpty ||
        double.tryParse(FortuneWheel.betController.text) == null) {
      return;
    }

    if (double.tryParse(FortuneWheel.betController.text)!.isNegative) {
      return;
    }

    if (profileController.moneys >=
        double.parse(FortuneWheel.betController.text)) {
      profileController
          .minusMoneys(double.parse(FortuneWheel.betController.text));
      controller.selectedX.value = myX;
      controller.isStartedGame.value = true;
      controller.profit.value = 0;
      _animation();
      profileController.plusTotalGame('fortuneWheel');
    }
  }
}
