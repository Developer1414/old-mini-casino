import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_casino/controllers/profile_controller.dart';
import 'package:mini_casino/main.dart';
import 'package:mini_casino/screens/fortune_wheel_screen.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  static TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxBool isLoading = false.obs;
    final ProfileController profileController = Get.find();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Obx(
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
                    centerTitle: true,
                    title: Text('Вход',
                        style: GoogleFonts.roboto(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        )),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15.0),
                        child: TextField(
                          style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(12),
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-z A-Z 0-9]'))
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.name,
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Ваше имя...',
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
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () {
                              isLoading.value = true;

                              signInWithGoogle().whenComplete(() async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get()
                                    .then((value) {
                                  if (value.exists) {
                                    isLoading.value = false;
                                    Get.to(() => const MyApp());
                                  } else {
                                    if (nameController.text.isEmpty) {
                                      showDialog('Ошибка', 'Вы не вписали имя!',
                                          Colors.redAccent);
                                      isLoading.value = false;
                                      return;
                                    }

                                    if (nameController.text.length < 2) {
                                      showDialog(
                                          'Ошибка',
                                          'Имя слишком короткое!',
                                          Colors.redAccent);
                                      isLoading.value = false;
                                      return;
                                    }

                                    List<String> splitList =
                                        nameController.text.trim().split(' ');
                                    List<String> indexList = [];

                                    for (int i = 0; i < splitList.length; i++) {
                                      for (int y = 1;
                                          y < splitList[i].length + 1;
                                          y++) {
                                        indexList.add(splitList[i]
                                            .substring(0, y)
                                            .toLowerCase());
                                      }
                                    }

                                    var data = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid);

                                    data.set({
                                      'id': data.id,
                                      'name': nameController.text.trim(),
                                      'searchIndex': indexList,
                                      'balance': 0
                                    }).whenComplete(() async {
                                      await profileController
                                          .addGamesToDatabase()
                                          .whenComplete(() {
                                        isLoading.value = false;
                                        Get.to(() => const FortuneWheelPrize());
                                      });
                                    });
                                  }
                                });
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.google,
                                  size: 25,
                                ),
                                const SizedBox(width: 15.0),
                                Text('Войти через Google',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

void showDialog(String title, String message, Color titleColor) {
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
}
