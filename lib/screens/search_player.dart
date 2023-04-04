import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_casino/screens/profile.dart';
import 'package:intl/intl.dart';

class SearchPlayer extends StatelessWidget {
  const SearchPlayer({super.key});

  static TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RxString searchingPlayerName = ''.obs;
    searchingPlayerName.value = searchController.text;

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
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 76,
            backgroundColor: Colors.transparent,
            title: SizedBox(
              height: 55,
              child: TextField(
                style: GoogleFonts.roboto(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                ],
                onChanged: (value) => searchingPlayerName.value = value,
                onSubmitted: (value) => searchingPlayerName.value = value,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Имя игрока...',
                  hintStyle: GoogleFonts.roboto(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 62, 68, 75), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 76, 83, 92), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: IconButton(
                splashRadius: 25,
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 28,
                ),
              ),
            ),
          ),
          body: Obx(
            () => StreamBuilder<QuerySnapshot>(
              stream: searchingPlayerName.value.isNotEmpty
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('balance', descending: true)
                      .where('searchIndex',
                          arrayContains: searchingPlayerName.value)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('balance', descending: true)
                      .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(strokeWidth: 3)));
                }

                return ListView.separated(
                    itemCount: snap.data?.docs.length ?? 0,
                    separatorBuilder: (context, index) => customDivider(
                        color: const Color.fromARGB(255, 30, 33, 36)),
                    itemBuilder: (c, index) {
                      return ListTile(
                        tileColor: snap.data?.docs[index].get('id') ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? const Color.fromARGB(255, 45, 50, 54)
                            : Colors.transparent,
                        onTap: () {
                          Get.to(() => Profile(
                              playerID: snap.data?.docs[index].get('id')));
                        },
                        title: Text(snap.data?.docs[index].get('name'),
                            style: GoogleFonts.roboto(
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            )),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text('Баланс: ',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  )),
                              Text(
                                  NumberFormat.compactSimpleCurrency(
                                          locale: Platform.localeName)
                                      .format(double.parse(snap
                                              .data?.docs[index]
                                              .get('balance')
                                              .toString() ??
                                          '0')),
                                  style: GoogleFonts.roboto(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
