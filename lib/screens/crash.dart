import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/crash_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/services/animated_currency_service.dart';

class LinePainter extends CustomPainter {
  final double progress;

  LinePainter({this.progress = 0.0});

  final Paint _paint = Paint()
    ..color = Colors.blueAccent
    ..strokeWidth = 8.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(progress * 570, size.height / 2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class Crash extends StatefulWidget {
  const Crash({super.key});

  @override
  State<Crash> createState() => _CrashState();
}

class _CrashState extends State<Crash> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;

  double randX = 0.0;

  final CrashController controller = Get.find();

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 6000));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller!)
      ..addListener(() {
        setState(() {
          if (_animation!.status == AnimationStatus.completed) {
            controller.isStartedGame.value = false;
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

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
          backgroundColor: const Color.fromARGB(255, 30, 33, 36),
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
                onPressed: controller.isStartedGame.value
                    ? null
                    : () async {
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

                        profileController.minusMoneys(controller.bet.value);

                        randX = Random().nextDouble() * 1.0;

                        _controller!.reset();
                        _controller!.forward();
                        controller.isStartedGame.value = true;
                      },
                child: Text(
                  'buttonBet'.tr,
                  style: GoogleFonts.roboto(
                      fontSize: 25,
                      color: controller.isStartedGame.value
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 76,
            backgroundColor: Colors.transparent,
            title: Text('Crash',
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
                  onPressed:
                      controller.isStartedGame.value ? null : () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: controller.isStartedGame.value
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white.withOpacity(0.9),
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
                          '${'textProfit'.tr} (${controller.coefficient.value.toStringAsFixed(2)}x):',
                          style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          )),
                    ),
                    Obx(
                      () => currencyNormalFormat(
                          context,
                          (controller.bet.value * controller.coefficient.value)
                                  .isNaN
                              ? 0
                              : controller.bet.value *
                                  controller.coefficient.value,
                          textStyle: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 120.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Transform.rotate(
                      angle: -0.75,
                      child: CustomPaint(
                        size: Size(Get.width / 2, 0),
                        painter: LinePainter(progress: _animation!.value),
                      ),
                    ),
                  ),
                ),
              ),
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
                              '${controller.coefficient.value.toStringAsFixed(2)}x',
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
                      value: controller.coefficient.value.clamp(1.0, 98.0),
                      max: 100.0,
                      min: 1,
                      onChanged: controller.isStartedGame.value
                          ? null
                          : (double value) {
                              controller.coefficient.value = value;
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
