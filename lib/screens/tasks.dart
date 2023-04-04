import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/controllers/tasks_controller.dart';
import 'package:mini_casino/screens/profile.dart';
import 'package:intl/intl.dart';

class Task extends GetxController {
  final ProfileController profileController = Get.find();
  final TasksController controller = Get.find();

  void showTask(CurrentGame currentGame) {
    bool isGenerated = controller.generateTasks(currentGame);

    Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 270,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 41, 45, 49),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 15.0, bottom: 15.0),
                child: Text('buttonTask'.tr,
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customDivider(color: const Color.fromARGB(255, 41, 45, 49)),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(controller.currentTask.text,
                        style: GoogleFonts.roboto(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Text('${'taskPrize'.tr} ',
                            style: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            )),
                        Text(
                            NumberFormat.simpleCurrency(
                                    locale: Platform.localeName)
                                .format(controller.currentTask.prize),
                            style: GoogleFonts.roboto(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                  customDivider(color: const Color.fromARGB(255, 41, 45, 49)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 15.0,
                          bottom: 15.0,
                          top: 15.0,
                          right: !isGenerated ? 15.0 : 0),
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                isGenerated ? Colors.green : Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (isGenerated) {
                                controller.selectTask(currentGame);
                                isGenerated = false;
                                Navigator.pop(context);
                              } else {
                                controller.deselectTask(currentGame);
                                isGenerated = true;
                              }
                            });
                          },
                          child: Text(
                            isGenerated
                                ? 'buttonTaskStart'.tr
                                : 'buttonTaskCancel'.tr,
                            style: GoogleFonts.roboto(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                  !isGenerated ? Container() : const SizedBox(width: 15.0),
                  !isGenerated
                      ? Container()
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 15.0, bottom: 15.0, top: 15.0),
                            child: SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    controller.generateTasks(currentGame);
                                  });
                                },
                                child: Text(
                                  'Дальше',
                                  style: GoogleFonts.roboto(
                                      fontSize: 25,
                                      color: !isGenerated
                                          ? Colors.white.withOpacity(0.4)
                                          : Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

/*void showDialog(String title, String message, Color titleColor) {
  Get.defaultDialog(
      backgroundColor: const Color.fromARGB(255, 62, 68, 75),
      titlePadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      title: title,
      titleStyle: GoogleFonts.roboto(
          fontSize: 25, color: titleColor, fontWeight: FontWeight.w700),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width / 1.3,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ));
}*/
