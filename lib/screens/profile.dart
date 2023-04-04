import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/screens/sign_in.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  Profile({super.key, this.playerID = ''});

  String playerID = '';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Item> _items = [];

  RxBool isLoading = false.obs;

  final ProfileController profileController = Get.find();

  Future loadData() async {
    isLoading.value = true;
    await profileController
        .loadData(playerID: widget.playerID)
        .whenComplete(() {
      isLoading.value = false;

      _items = [
        Item(
            nameGame: 'Mines',
            biggestX: profileController.minesData.biggestX,
            biggestWinnings: profileController.minesData.biggestWinnings,
            biggestLosses: profileController.minesData.biggestLosses,
            winnigsMoneys: profileController.minesData.winnigsMoneys,
            totalGames: profileController.minesData.totalGames,
            lossesMoneys: profileController.minesData.lossesMoneys),
        Item(
            nameGame: 'Dice',
            biggestX: profileController.diceData.biggestX,
            biggestWinnings: profileController.diceData.biggestWinnings,
            biggestLosses: profileController.diceData.biggestLosses,
            winnigsMoneys: profileController.diceData.winnigsMoneys,
            totalGames: profileController.diceData.totalGames,
            lossesMoneys: profileController.diceData.lossesMoneys),
        Item(
            nameGame: 'Limbo',
            biggestX: profileController.limboData.biggestX,
            biggestWinnings: profileController.limboData.biggestWinnings,
            biggestLosses: profileController.limboData.biggestLosses,
            winnigsMoneys: profileController.limboData.winnigsMoneys,
            totalGames: profileController.limboData.totalGames,
            lossesMoneys: profileController.limboData.lossesMoneys),
        Item(
            nameGame: 'Fortune wheel',
            biggestX: profileController.fortuneWheelData.biggestX,
            biggestWinnings: profileController.fortuneWheelData.biggestWinnings,
            biggestLosses: profileController.fortuneWheelData.biggestLosses,
            winnigsMoneys: profileController.fortuneWheelData.winnigsMoneys,
            totalGames: profileController.fortuneWheelData.totalGames,
            lossesMoneys: profileController.fortuneWheelData.lossesMoneys),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async => false,
        child: Obx(
          () => isLoading.value
              ? const Scaffold(
                  backgroundColor: Color.fromARGB(255, 30, 33, 36),
                  body: Center(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(strokeWidth: 3))),
                )
              : Scaffold(
                  backgroundColor: const Color.fromARGB(255, 30, 33, 36),
                  appBar: AppBar(
                    elevation: 0,
                    toolbarHeight: 76,
                    backgroundColor: Colors.transparent,
                    title: Text(profileController.myName,
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
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 28,
                        ),
                      ),
                    ),
                    actions: widget.playerID.isNotEmpty
                        ? null
                        : [
                            Padding(
                              padding: const EdgeInsets.only(right: 13.0),
                              child: IconButton(
                                splashRadius: 25,
                                onPressed: () async {
                                  isLoading.value = true;
                                  await FirebaseAuth.instance
                                      .signOut()
                                      .whenComplete(() {
                                    isLoading.value = false;
                                    Get.off(() => const SignIn());
                                  });
                                },
                                icon: const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                  ),
                  body: ListView(
                    children: [
                      customDivider(
                          color: const Color.fromARGB(255, 30, 33, 36)),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: ListTile(
                          title: Text('Всего игр:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                                textAlign: TextAlign.center,
                                NumberFormat.compact(
                                        locale: Platform.localeName)
                                    .format((profileController.totalGames)),
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                )),
                          ),
                        ),
                      ),
                      customDivider(
                          color: const Color.fromARGB(255, 30, 33, 36)),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: ListTile(
                          title: Text('Баланс:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                                NumberFormat.simpleCurrency(
                                        locale: Platform.localeName)
                                    .format((widget.playerID ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? profileController.moneys.value
                                        : profileController
                                            .moneysAnotherPlayer)),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                )),
                          ),
                        ),
                      ),
                      customDivider(
                          color: const Color.fromARGB(255, 30, 33, 36)),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: ListTile(
                          title: Text('Выигрыш:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                                NumberFormat.compactSimpleCurrency(
                                        locale: Platform.localeName)
                                    .format((profileController.winningsMoneys)),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                )),
                          ),
                        ),
                      ),
                      customDivider(
                          color: const Color.fromARGB(255, 30, 33, 36)),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: ListTile(
                          title: Text('Проигрыш:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                                NumberFormat.compactSimpleCurrency(
                                        locale: Platform.localeName)
                                    .format((profileController.lossesMoneys)),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                )),
                          ),
                        ),
                      ),
                      customDivider(
                          color: const Color.fromARGB(255, 30, 33, 36)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        child: Text('Статистика:',
                            style: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _items[index].isExpanded = !isExpanded;
                            });
                          },
                          animationDuration: const Duration(milliseconds: 500),
                          elevation: 0,
                          expandedHeaderPadding: const EdgeInsets.all(10.0),
                          dividerColor: const Color.fromARGB(224, 65, 70, 78),
                          children: _items
                              .map((item) => _buildExpansionPanel(item))
                              .toList(),
                        ),
                      )
                    ],
                  )),
        ),
      ),
    );
  }

  ExpansionPanel _buildExpansionPanel(Item item) {
    return ExpansionPanel(
      canTapOnHeader: true,
      backgroundColor: const Color.fromARGB(255, 44, 48, 53),
      isExpanded: item.isExpanded,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(item.nameGame,
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                )),
          ),
        );
      },
      body: Column(
        children: [
          customDivider(),
          ListTile(
            title: Text('Всего игр:',
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                  NumberFormat.compact(locale: Platform.localeName)
                      .format((item.totalGames)),
                  style: GoogleFonts.roboto(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  )),
            ),
          ),
          customDivider(),
          ListTile(
            title: Text('Наибольший X:',
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(item.biggestX,
                  style: GoogleFonts.roboto(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  )),
            ),
          ),
          customDivider(),
          ListTile(
            title: Text('Наибольший выигрыш:',
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                  NumberFormat.compactSimpleCurrency(
                          locale: Platform.localeName)
                      .format((item.biggestWinnings)),
                  style: GoogleFonts.roboto(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  )),
            ),
          ),
          customDivider(),
          ListTile(
            title: Text('Всего выигрыш:',
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                  NumberFormat.compactSimpleCurrency(
                          locale: Platform.localeName)
                      .format((item.winnigsMoneys)),
                  style: GoogleFonts.roboto(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  )),
            ),
          ),
          customDivider(),
          ListTile(
            title: Text('Наибольший проигрыш:',
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                  NumberFormat.compactSimpleCurrency(
                          locale: Platform.localeName)
                      .format((item.biggestLosses)),
                  style: GoogleFonts.roboto(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  )),
            ),
          ),
          customDivider(),
          ListTile(
            title: Text('Всего проигрыш:',
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                  NumberFormat.compactSimpleCurrency(
                          locale: Platform.localeName)
                      .format((item.lossesMoneys)),
                  style: GoogleFonts.roboto(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: customDivider(),
          ),
        ],
      ),
    );
  }
}

class Item {
  Item({
    this.isExpanded = false,
    this.nameGame = '',
    this.biggestX = '',
    this.winnigsMoneys = 0.0,
    this.biggestWinnings = 0.0,
    this.biggestLosses = 0.0,
    this.lossesMoneys = 0.0,
    this.totalGames = 0,
  });

  String nameGame = '';
  String biggestX = '';
  double biggestWinnings = 0.0;
  double biggestLosses = 0.0;
  double winnigsMoneys = 0.0;
  double lossesMoneys = 0.0;
  int totalGames = 0;
  bool isExpanded;
}

Widget customDivider({Color? color}) {
  if (color == null) {
    color = const Color.fromARGB(255, 44, 48, 53);
  } else {
    color = color;
  }

  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: SizedBox(
      width: double.infinity,
      height: 2,
      child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          radius: 100,
          colors: [
            const Color.fromARGB(224, 65, 70, 78),
            color,
          ],
        )),
      ),
    ),
  );
}
