import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mini_casino/services/games_statistic.dart';

class ProfileController extends GetxController {
  double moneysAnotherPlayer = 0.0;
  RxDouble moneys = 0.0.obs;
  double winningsMoneys = 0.0;
  double lossesMoneys = 0.0;
  int totalGames = 0;
  String myName = '';

  GameData minesData = GameData();
  GameData diceData = GameData();
  GameData limboData = GameData();
  GameData fortuneWheelData = GameData();

  void plusMoneys(double value) async {
    moneys.value += value;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"balance": FieldValue.increment(value.roundToDouble())});
  }

  void minusMoneys(double value) async {
    moneys.value -= value;

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'balance': FieldValue.increment(-value.roundToDouble())});
  }

  void plusLoose(double value, String gameName) async {
    lossesMoneys += value;
    updateGameData(gameName, {'lossesMoneys': FieldValue.increment(value)});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc(gameName)
        .get()
        .then((val) {
      if (double.parse(val.get('biggestLosses').toString()) < value) {
        updateGameData(gameName, {'biggestLosses': value});
      }
    });
  }

  void plusWin(
      {double value = 0.0, double currentX = 0.0, String gameName = ''}) async {
    winningsMoneys += value;

    await updateGameData(
        gameName, {'winningsMoneys': FieldValue.increment(value)});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc(gameName)
        .get()
        .then((value) {
      if (double.parse(value.get('biggestX').toString()) < currentX) {
        updateGameData(gameName, {'biggestX': currentX});
      }
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc(gameName)
        .get()
        .then((val) {
      if (double.parse(val.get('biggestWinnings').toString()) < value) {
        updateGameData(gameName, {'biggestWinnings': value});
      }
    });
  }

  void plusTotalGame(String gameName) async {
    totalGames++;
    updateGameData(gameName, {'totalGames': FieldValue.increment(1)});
  }

  Future loadData({String playerID = ''}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(playerID.isEmpty
            ? FirebaseAuth.instance.currentUser!.uid
            : playerID)
        .get()
        .then((value) {
      if (playerID.isNotEmpty &&
          playerID != FirebaseAuth.instance.currentUser!.uid) {
        moneysAnotherPlayer = double.parse(value.get('balance').toString());
      } else {
        moneys.value = double.parse(value.get('balance').toString());
      }
      myName = value.get('name').toString();
    });

    await loadGame('mines', playerID: playerID);
    await loadGame('limbo', playerID: playerID);
    await loadGame('dice', playerID: playerID);
    await loadGame('fortuneWheel', playerID: playerID);

    totalGames = minesData.totalGames +
        limboData.totalGames +
        diceData.totalGames +
        fortuneWheelData.totalGames;

    winningsMoneys = minesData.winnigsMoneys +
        limboData.winnigsMoneys +
        diceData.winnigsMoneys +
        fortuneWheelData.winnigsMoneys;

    lossesMoneys = minesData.lossesMoneys +
        limboData.lossesMoneys +
        diceData.lossesMoneys +
        fortuneWheelData.lossesMoneys;
  }

  Future loadGame(String gameName, {String playerID = ''}) async {
    GameData temp = GameData();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(playerID.isEmpty
            ? FirebaseAuth.instance.currentUser!.uid
            : playerID)
        .collection('games')
        .doc(gameName)
        .get()
        .then((value) async {
      temp = GameData(
          biggestX:
              double.parse(value.get('biggestX').toString()).toStringAsFixed(2),
          totalGames: value.get('totalGames'),
          winnigsMoneys: double.parse(value.get('winningsMoneys').toString()),
          lossesMoneys: double.parse(value.get('lossesMoneys').toString()),
          biggestLosses: double.parse(value.get('biggestLosses').toString()),
          biggestWinnings:
              double.parse(value.get('biggestWinnings').toString()));
    });

    switch (gameName) {
      case 'mines':
        minesData = temp;
        break;
      case 'limbo':
        limboData = temp;
        break;
      case 'dice':
        diceData = temp;
        break;
      case 'fortuneWheel':
        fortuneWheelData = temp;
        break;
    }
  }

  Future addGamesToDatabase() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc('mines')
        .set({
      'biggestX': 0.0,
      'totalGames': 0,
      'winningsMoneys': 0.0,
      'lossesMoneys': 0.0,
      'biggestLosses': 0.0,
      'biggestWinnings': 0.0,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc('dice')
        .set({
      'biggestX': 0.0,
      'totalGames': 0,
      'winningsMoneys': 0.0,
      'lossesMoneys': 0.0,
      'biggestLosses': 0.0,
      'biggestWinnings': 0.0,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc('limbo')
        .set({
      'biggestX': 0.0,
      'totalGames': 0,
      'winningsMoneys': 0.0,
      'lossesMoneys': 0.0,
      'biggestLosses': 0.0,
      'biggestWinnings': 0.0,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc('fortuneWheel')
        .set({
      'biggestX': 0.0,
      'totalGames': 0,
      'winningsMoneys': 0.0,
      'lossesMoneys': 0.0,
      'biggestLosses': 0.0,
      'biggestWinnings': 0.0,
    });
  }

  Future updateGameData(String gameName, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('games')
        .doc(gameName)
        .update(data);
  }
}
