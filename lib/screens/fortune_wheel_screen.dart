import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/fortune_prize_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/fortune_wheel/board_view.dart';
import 'package:mini_casino/fortune_wheel/model.dart';
import 'package:intl/intl.dart';

class FortuneWheelPrize extends StatefulWidget {
  const FortuneWheelPrize({Key? key}) : super(key: key);

  @override
  State<FortuneWheelPrize> createState() => _FortuneWheelPrizeState();
}

class _FortuneWheelPrizeState extends State<FortuneWheelPrize>
    with SingleTickerProviderStateMixin {
  dynamic wheelResult = 0;

  double _angle = 0;

  double _current = 0;

  late AnimationController _ctrl;

  late Animation _ani;

  final FortunePrize controller = Get.find();
  final ProfileController profileController = Get.find();

  String locale = Platform.localeName;

  final List<Luck> _items = [
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(300),
        Colors.orangeAccent),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(1000),
        Colors.green),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(100),
        Colors.blueGrey),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(300),
        Colors.orangeAccent),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(100),
        Colors.blueGrey),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(500),
        Colors.redAccent),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(100),
        Colors.blueGrey),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(300),
        Colors.orangeAccent),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(100),
        Colors.blueGrey),
    Luck(NumberFormat.simpleCurrency(locale: Platform.localeName).format(500),
        Colors.redAccent),
  ];

  @override
  void initState() {
    super.initState();
    controller.againsCount.value = 2;
    var duration = const Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0),
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
                      onPressed: !controller.isSpinned.value &&
                              controller.againsCount.value > 0
                          ? () {
                              _animation();
                              controller.isSpinned.value = true;
                              controller.againsCount.value--;
                            }
                          : null,
                      child: Text(
                        '${'fortunePrizeButtonSpin'.tr} (${controller.againsCount})',
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            color: !controller.isSpinned.value &&
                                    controller.againsCount.value > 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, bottom: 15.0, top: 15.0),
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
                      onPressed: !controller.isSpinned.value &&
                              controller.againsCount.value < 2
                          ? () async {
                              profileController
                                  .plusMoneys(controller.deposit.value);
                              Get.back();
                            }
                          : null,
                      child: Text(
                        'fortunePrizeButtonGet'.tr,
                        style: GoogleFonts.roboto(
                            fontSize: 22,
                            color: !controller.isSpinned.value &&
                                    controller.againsCount.value < 2
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
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
          title: Text('fortunePrizeTitle'.tr,
              style: GoogleFonts.roboto(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w700,
                fontSize: 25,
              )),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 35.0),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                          animation: _ani,
                          builder: (context, child) {
                            wheelResult = _ani.value;
                            final angle = wheelResult * _angle;
                            return Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                BoardView(
                                    items: _items,
                                    current: _current,
                                    angle: angle),
                                _buildResult(wheelResult)
                              ],
                            );
                          }),
                    ],
                  ),
                ),
                Obx(
                  () => Text(controller.currentNumber.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      )),
                ),
              ],
            ),
          ),
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
      Future.delayed(Duration.zero, () async {
        var myProfit =
            double.parse(_items[index].value.replaceAll(RegExp('[^0-9]'), ''));

        controller.deposit.value = myProfit / 100;
        controller.isSpinned.value = false;
      });
    }

    Future.delayed(Duration.zero,
        () => controller.currentNumber.value = _items[index].value);

    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: SizedBox(
        height: 72,
        width: 72,
        child: Center(
          child: Text(
            '?',
            style: GoogleFonts.roboto(
                fontSize: 25,
                color: Colors.black87,
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
