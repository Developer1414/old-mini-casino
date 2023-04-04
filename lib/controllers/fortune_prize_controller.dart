import 'package:get/get.dart';

class FortunePrize extends GetxController {
  RxBool isSpinned = false.obs;
  RxDouble deposit = 0.0.obs;
  RxInt againsCount = 2.obs;
  RxString currentNumber = ''.obs;
}
