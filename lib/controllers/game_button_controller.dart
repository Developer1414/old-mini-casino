import 'package:flutter/cupertino.dart';
import 'package:mini_casino/screens/dice.dart';
import 'package:mini_casino/screens/fortune_wheel.dart';
import 'package:mini_casino/screens/limbo.dart';
import 'package:mini_casino/screens/mines.dart';

class ItemButton {
  String gameName = '';
  Widget newScreen;

  ItemButton({this.gameName = '', required this.newScreen});
}

class GameButtonController {
  List<ItemButton> buttons = [
    ItemButton(gameName: 'Dice', newScreen: const Dice()),
    ItemButton(gameName: 'Mines', newScreen: const Mines()),
    ItemButton(gameName: 'Limbo', newScreen: const Limbo()),
    //ItemButton(gameName: 'Crash', newScreen: const Crash()),
    ItemButton(gameName: 'Fortune wheel', newScreen: const FortuneWheel()),
  ];
}
