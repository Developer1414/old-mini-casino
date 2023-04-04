import 'dart:ui' as ui;
import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/controllers/crash_controller.dart';
import 'package:mini_casino/controllers/dice_controller.dart';
import 'package:mini_casino/controllers/fortune_prize_controller.dart';
import 'package:mini_casino/controllers/fortune_wheel_controller.dart';
import 'package:mini_casino/controllers/game_button_controller.dart';
import 'package:mini_casino/controllers/limbo_controller.dart';
import 'package:mini_casino/controllers/mines_controller.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/controllers/tasks_controller.dart';
import 'package:mini_casino/firebase_options.dart';
import 'package:mini_casino/screens/fortune_wheel_screen.dart';
import 'package:mini_casino/screens/profile.dart';
import 'package:mini_casino/screens/search_player.dart';
import 'package:mini_casino/screens/sign_in.dart';
import 'package:mini_casino/services/animated_currency_service.dart';
import 'package:mini_casino/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Appodeal.setAppKeys(
    androidAppKey: '8cfbbd108887cd836369dab032429df5cd4d2c7f4ea9ac2e',
  );

  await Appodeal.initialize(
    hasConsent: true,
    adTypes: [
      AdType.mrec,
      AdType.interstitial,
      AdType.reward,
      AdType.nonSkippable
    ],
    testMode: true,
    verbose: true,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(GetMaterialApp(
      translations: AppTranslations(),
      locale: ui.window.locale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static TasksController tasksController = Get.put(TasksController());

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ProfileController profileController = Get.put(ProfileController());

  MinesSettingsController minesController = Get.put(MinesSettingsController());
  FortuneWheelController fortuneWheelController =
      Get.put(FortuneWheelController());
  DiceController diceController = Get.put(DiceController());
  LimboController limboController = Get.put(LimboController());
  FortunePrize prizeController = Get.put(FortunePrize());
  CrashController crashController = Get.put(CrashController());

  TasksController tasksController = Get.put(TasksController());

  GameButtonController gameButtons = GameButtonController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return snapshot.data == null
                ? const SignIn()
                : FutureBuilder<dynamic>(
                    future: profileController.loadData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          backgroundColor: Color.fromARGB(255, 30, 33, 36),
                          body: Center(
                              child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 3))),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return Scaffold(
                          bottomNavigationBar: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Obx(() => profileController.moneys < 10
                                ? Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        gradient: profileController.moneys < 10
                                            ? const LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Colors.orange,
                                                  Colors.orangeAccent,
                                                ],
                                              )
                                            : null),
                                    child: Material(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(
                                              () => const FortuneWheelPrize());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: Text('fortunePrizeTitle'.tr,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(height: 0.0)),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 30, 33, 36),
                          appBar: AppBar(
                            elevation: 0,
                            toolbarHeight: 76,
                            backgroundColor: Colors.transparent,
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 13.0),
                              child: IconButton(
                                splashRadius: 25,
                                onPressed: () async {
                                  Get.to(() => Profile());
                                },
                                icon: Icon(
                                  Icons.person_rounded,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 28,
                                ),
                              ),
                            ),
                            title: Text('mainScreenTitle'.tr,
                                style: GoogleFonts.roboto(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25,
                                )),
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
                            children: [
                              GridView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(15.0),
                                  itemCount: gameButtons.buttons.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 15.0,
                                          childAspectRatio: (1 / .5),
                                          mainAxisSpacing: 15.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(() => gameButtons
                                            .buttons[index].newScreen);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                            gameButtons.buttons[index].gameName,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => const SearchPlayer());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text('Найти игрока',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }

                      return const Scaffold(
                        backgroundColor: Color.fromARGB(255, 30, 33, 36),
                        body: Center(
                            child: SizedBox(
                                width: 60,
                                height: 60,
                                child:
                                    CircularProgressIndicator(strokeWidth: 3))),
                      );
                    });
          }),
    );
  }
}
