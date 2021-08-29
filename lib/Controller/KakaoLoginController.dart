import 'package:get/get.dart';

class KakaoLoginController extends GetxController {
  RxBool animateFlag = false.obs;
  bool flag = false;
  RxInt counter = 888.obs;
  int counter2 = 777;

  void changeAnimateFlag() {
    // flag =  !flag;
    animateFlag.value = !animateFlag.value;
    // print('phil : $animateFlag.value');

  }

  void initAnimateFlag() {
    animateFlag.value = false;
  }
}
